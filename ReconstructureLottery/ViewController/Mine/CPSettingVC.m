//
//  CPSettingVC.m
//  lottery
//
//  Created by wayne on 2017/8/30.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPSettingVC.h"
#import "CPModifyLoginPasswordVC.h"
#import "CookBook_AboutUsVC.h"
#import "CPSetQAMessageVC.h"
#import "CPModifyQAMessageVC.h"
#import "CPModifyPayPasswordVC.h"
#import "CPBankCardInfoVC.h"

@interface CPSettingVC ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *_tableView;
    IBOutlet UIView *_footerView;
    IBOutlet UIView *_headerView;
    
    NSArray *_dataList;
    NSArray *_imageList;
    
    BOOL _isSetTkPasswd;
    BOOL _isSetBank;
    BOOL _isSetQuestion;

    NSString *_aboutUsMessage;
}


@end

@implementation CPSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    
    if ([CookBook_GlobalDataManager shareGlobalData].isReviewVersion) {
        _dataList = @[@[@"登录密码",@"密保问题"],@[@"关于我们"]];
        _imageList = @[@[@"shezhi_03_goucai_mine",@"geren_tubiao_13_goucai_mine"],@[@"geren_tubiao_30_goucai_mine"]];
    }else{
        _dataList = @[@[@"登录密码",@"密保问题",@"提款密码",@"我的银行卡"],@[@"关于我们"]];
        _imageList = @[@[@"shezhi_03_goucai_mine",@"geren_tubiao_13_goucai_mine",@"shezhi_03_goucai_mine",@"shezhi_04_goucai_mine"],@[@"geren_tubiao_30_goucai_mine"]];
    }
    
    if ([CookBook_User shareUser].isTryPlay) {
        _dataList = @[@[@"登录密码"],@[@"关于我们"]];
        _imageList = @[@[@"shezhi_03_goucai_mine"],@[@"geren_tubiao_30_goucai_mine"]];
    }
    
    _tableView.tableHeaderView = _headerView;
    _tableView.tableFooterView = _footerView;
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self querySettingInfo];
    }];
    [self querySettingInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)logoutAction:(UIButton *)sender {
    [self queryLogout];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self querySettingInfo];
}

#pragma mark- network

-(void)queryLogout
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPILogout
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
 
                   [[CookBook_User shareUser]cookBook_logout];
                   [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForLogOut object:nil];
                   [self.navigationController popToRootViewControllerAnimated:YES];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];


}


-(void)querySettingInfo
{
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPISetting
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               if (_tableView.mj_header.isRefreshing) {
                   [_tableView.mj_header endRefreshing];
               }
               if (request.resultIsOk) {
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   _isSetTkPasswd = [[dataInfo DWStringForKey:@"tkPasswd"]intValue];
                   _isSetQuestion = [[dataInfo DWStringForKey:@"question"]intValue];
                   _isSetBank = [[dataInfo DWStringForKey:@"bank"]intValue];
                   [_tableView reloadData];

               }else{
               }
               
               
           } failure:^(__kindof CookBook_Request *request) {
               
               if (_tableView.mj_header.isRefreshing) {
                   [_tableView.mj_header endRefreshing];
               }
           }];
}


-(void)queryAboutUsMessage
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPISettingAboutUs
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSString *urlString = [request.resultInfo DWStringForKey:@"data"];
                   _aboutUsMessage = urlString;
                   [self goToAboutUsViewController];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
    
}


-(void)queryGetQa
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPISettingGetQa
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSString *qaMessage = [request.resultInfo DWStringForKey:@"data"];
                   [self goToQaViewControllerWithOldQuestion:qaMessage];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
    
}

-(void)queryIsWithdrawPasswdSet
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPISettingIsWithdrawPasswdSet
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   BOOL isSet = [[request.resultInfo DWStringForKey:@"data"]intValue]==1?YES:NO;
                   [self goToPayPasswordControllerIsSet:isSet];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}

-(void)queryGetBank
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPISettingGetBank
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *bankInfoMessage = [request.resultInfo DWDictionaryForKey:@"data"];
                   [self goToBankCardViewControllerWithBankInfo:bankInfoMessage];
                   /*
                    {
                    "bankName":"浦发银行",银行名称
                    "accountCode":"354***211",--银行账号
                    "accountName":"123",--开户人姓名
                    "provice":"12",--省份
                    "city":"12",--城市
                    "expand":{
                                "isWithdrawPasswdSet":1--是否已经设置提款密码 1已设置 0未设置
                             }
                    }

                    */
                   
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
    
}

#pragma mark- tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *list = _dataList[section];
    return list.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *markString = @"markString";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:markString];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:markString];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0f];
        cell.textLabel.textColor = kCOLOR_R_G_B_A(109, 109, 109, 1);
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.detailTextLabel.textColor = kCOLOR_R_G_B_A(169, 169, 169, 1);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSArray *dataInfo = _dataList[indexPath.section];
    NSArray *imageInfo = _imageList[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:imageInfo[indexPath.row]];
    NSString *title = dataInfo[indexPath.row];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    
    NSString *detailText = @"";
    if ([title isEqualToString:@"密保问题"]) {
        detailText = _isSetQuestion?@"已设置":@"未设置";
    }else if ([title isEqualToString:@"提款密码"]) {
        detailText = _isSetTkPasswd?@"已设置":@"未设置";
    }else if ([title isEqualToString:@"我的银行卡"]) {
        detailText = _isSetBank?@"已绑定":@"未绑定";
    }else if([title isEqualToString:@"关于我们"]){
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        detailText = [NSString stringWithFormat:@"当前版本%@",app_Version];
    }
    cell.detailTextLabel.text = detailText;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CookBook_GlobalDataManager cookBook_playButtonClickVoice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *dataInfo = _dataList[indexPath.section];
    NSString *title = dataInfo[indexPath.row];
    
    if ([title isEqualToString:@"登录密码"]) {
        CPModifyLoginPasswordVC *vc = [CPModifyLoginPasswordVC new];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([title isEqualToString:@"密保问题"]) {
        [self queryGetQa];
    }else if ([title isEqualToString:@"提款密码"]) {
        [self queryIsWithdrawPasswdSet];
    }else if ([title isEqualToString:@"我的银行卡"]) {
        [self queryGetBank];
    }else if ([title isEqualToString:@"关于我们"]) {
        if (_aboutUsMessage.length>0) {
            [self goToAboutUsViewController];
        }else{
            [self queryAboutUsMessage];
        }
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

#pragma mark- push 

-(void)goToAboutUsViewController
{
    CookBook_AboutUsVC *vc = [CookBook_AboutUsVC new];
    vc.message = _aboutUsMessage;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goToQaViewControllerWithOldQuestion:(NSString *)oldQuestion
{
    if (oldQuestion.length>0) {
        CPModifyQAMessageVC * vc = [CPModifyQAMessageVC new];
        vc.question = oldQuestion;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        CPSetQAMessageVC * vc = [CPSetQAMessageVC new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)goToPayPasswordControllerIsSet:(BOOL)isSet
{
    CPModifyPayPasswordVC * vc = [CPModifyPayPasswordVC new];
    vc.isSeted = isSet;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goToBankCardViewControllerWithBankInfo:(NSDictionary *)bankInfo
{
    CPBankCardInfoVC *vc = [CPBankCardInfoVC new];
    vc.bankInfo = bankInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
