//
//  CPMineVC.m
//  lottery
//
//  Created by wayne on 17/1/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPMineVC.h"
#import "CookBook_MineActionModel.h"

#import "CPMyRecommendVC.h"
#import "CPSignVC.h"
#import "CPSignRecordVC.h"
#import "CPPersonalMessageVC.h"
#import "CPBetRecordVC.h"
#import "CPAccountRecordVC.h"
#import "CPRechargeRecordVC.h"
#import "CPWithdrawRecordVC.h"
#import "CPSettingVC.h"
#import "CookBook_BusinessControllerManager.h"
#import "CPRechargeMainViewController.h"

@interface CPMineVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
    IBOutlet UIView *_tableHeaderView;
    IBOutlet UITableView *_tableView;
    
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_balanceLabel;
    IBOutlet UIView *_itemView;
    
    IBOutlet UIView *_rechargeView;
    IBOutlet UIView *_withdrawView;
    IBOutlet UIView *_signView;
    NSArray *_modelList;
    IBOutlet UIButton *_kefuButton;
    
    IBOutlet UIView *_balanceView;
}

@property(nonatomic,copy)NSString *balance;
@property(nonatomic,assign)int unReadCount;
@property(nonatomic,retain)UILabel *unreadCountLabel;

@end

@implementation CPMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人中心";

    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 44, 44);
    [btnRight setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [btnRight setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [btnRight addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
//    320/184
    
    _tableHeaderView.size = CGSizeMake(kScreenWidth, kScreenWidth*175/320);
    
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if ([CookBook_GlobalDataManager shareGlobalData].isReviewVersion) {
        
        _modelList = @[
                       [CookBook_MineActionModel cookBook_modelName:@"系统公告" icon:@"geren_tubiao_06_goucai_mine" identify:2],
                       [CookBook_MineActionModel cookBook_modelName:@"签到记录" icon:@"geren_tubiao_hb_goucai_mine" identify:8],
                       [CookBook_MineActionModel cookBook_modelName:@"个人消息" icon:@"geren_tubiao_06_goucai_mine" identify:9]
                       ];
        _balanceView.hidden = YES;
        _withdrawView.hidden = YES;
        _rechargeView.hidden = YES;
        _signView.hidden = YES;
        _itemView.backgroundColor = [UIColor whiteColor];
        _kefuButton.hidden = YES;
        
        _tableView.tableHeaderView = [UIView new];

    }else{
        
        _modelList = @[[CookBook_MineActionModel cookBook_modelName:@"我的推荐[推荐好友获取收益]" icon:@"shezhi_04_goucai_mine" identify:1],
                       [CookBook_MineActionModel cookBook_modelName:@"系统公告" icon:@"geren_tubiao_06_goucai_mine" identify:2],
                       [CookBook_MineActionModel cookBook_modelName:@"投注记录" icon:@"geren_tubiao_13_goucai_mine" identify:3],
                       [CookBook_MineActionModel cookBook_modelName:@"中奖记录" icon:@"geren_tubiao_24_goucai_mine" identify:4],
                       [CookBook_MineActionModel cookBook_modelName:@"账户明细" icon:@"geren_tubiao_26_goucai_mine" identify:5],
                       [CookBook_MineActionModel cookBook_modelName:@"充值记录" icon:@"geren_tubiao_04_goucai_mine" identify:6],
                       [CookBook_MineActionModel cookBook_modelName:@"提款记录" icon:@"geren_tubiao_13_goucai_mine" identify:7],
                       [CookBook_MineActionModel cookBook_modelName:@"签到记录" icon:@"user_qiandao" identify:8],
                       [CookBook_MineActionModel cookBook_modelName:@"我的红包" icon:@"geren_tubiao_hb_goucai_mine" identify:10],
                       [CookBook_MineActionModel cookBook_modelName:@"个人消息" icon:@"geren_tubiao_06_goucai_mine" identify:9]
                       ];
        _tableView.tableHeaderView = _tableHeaderView;

    }
    
    _tableView.tableFooterView = [UIView new];
    
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self queryMineInfo];
    }];
    [_tableView.mj_header beginRefreshing];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_tableView.mj_header.isRefreshing) {
        [self queryMineInfo];
    }
    _nameLabel.text = [CookBook_User shareUser].tokenInfo.memberName;
   
}

-(void)settingAction
{
    [CookBook_GlobalDataManager cookBook_playButtonClickVoice];
    CPSettingVC *vc = [[CPSettingVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark- business method

-(void)loadKefuWebView
{
    CookBook_WebViewController *toWebVC = [[CookBook_WebViewController alloc] cookBook_WebWithURLString:[[NSString alloc]initWithString:[CookBook_GlobalDataManager shareGlobalData].kefuUrlString]];
    toWebVC.title = @"客服";
    toWebVC.showPageTitles = NO;
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    toWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
}

#pragma mark- setter && getter
-(void)setBalance:(NSString *)balance
{
    _balance = balance?balance:@"";
    _balanceLabel.text = [NSString stringWithFormat:@"%.2f",[_balance floatValue]];
}

-(void)setUnReadCount:(int)unReadCount
{
    _unReadCount = unReadCount;
    if (_unReadCount>0) {
        self.unreadCountLabel.hidden = NO;
//        self.unreadCountLabel.text = [NSString stringWithFormat:@"%d",_unReadCount];
    }else{
        self.unreadCountLabel.hidden = YES;
    }
    [_tableView reloadData];
}

-(UILabel *)unreadCountLabel
{
    if (!_unreadCountLabel) {
        CGFloat width = 10;
        _unreadCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(_tableView.width - 50, (44-width)/2.0f, width, width)];
        _unreadCountLabel.textColor = [UIColor whiteColor];
        _unreadCountLabel.backgroundColor = kMainColor;
        _unreadCountLabel.textAlignment = NSTextAlignmentCenter;
        _unreadCountLabel.font = [UIFont systemFontOfSize:13.0f];
        _unreadCountLabel.layer.cornerRadius = _unreadCountLabel.width/2.0f;
        _unreadCountLabel.layer.masksToBounds = YES;
        _unreadCountLabel.tag = 999;
        _unreadCountLabel.hidden = YES;

    }
    return _unreadCountLabel;
}



#pragma mark- network

-(void)queryKefuUrlString
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIKefu
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSString *urlString = [request.resultInfo DWStringForKey:@"data"];
                   [CookBook_GlobalDataManager shareGlobalData].kefuUrlString = urlString;
                   [self loadKefuWebView];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}


-(void)queryMineInfo
{
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"type":@"0"}];

    [paramsDic setObject:[CookBook_User shareUser].token forKey:@"token"];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserAmount
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               if (_tableView.mj_header.isRefreshing) {
                   [_tableView.mj_header endRefreshing];
               }
               if (request.resultIsOk) {
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   self.balance = [dataInfo DWStringForKey:@"balance"];
                   self.unReadCount = [[dataInfo DWStringForKey:@"unReadCount"]intValue];
                   
               }else{
                   [WSProgressHUD showErrorWithStatus:request.requestDescription];
               }
               
               
           } failure:^(__kindof CookBook_Request *request) {
               
               if (_tableView.mj_header.isRefreshing) {
                   [_tableView.mj_header endRefreshing];
               }
               [WSProgressHUD showErrorWithStatus:@"网络异常"];
           }];
}

-(void)queryBalanceInfo
{
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"type":@"0"}];
    
    [paramsDic setObject:[CookBook_User shareUser].token forKey:@"token"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserAmount
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               if (request.resultIsOk) {
                   
                   NSDictionary *dataInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   self.balance = [dataInfo DWStringForKey:@"balance"];
                   self.unReadCount = [[dataInfo DWStringForKey:@"unReadCount"]intValue];
               }
           } failure:^(__kindof CookBook_Request *request) {
            
           }];
}

#pragma mark- tableViewDelegate

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.01f;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CookBook_MineActionModel *model = [_modelList objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = model.name;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    if ([model.name isEqualToString:@"个人消息"]) {
        [cell.contentView addSubview:self.unreadCountLabel];
        if (self.unReadCount>0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%d)",model.name,self.unReadCount];
        }else{
            cell.textLabel.text = model.name;
        }
    }else{
        UIView *subView = [cell.contentView viewWithTag:999];
        if (subView) {
            [subView removeFromSuperview];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CookBook_GlobalDataManager cookBook_playButtonClickVoice];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CookBook_MineActionModel *model = [_modelList objectAtIndex:indexPath.row];
    switch (model.identify) {
        case 1:
        {
            //我的推荐
            if ([CookBook_User shareUser].isTryPlay) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉，试玩账号不能进行存取款操作！" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            CPMyRecommendVC *vc = [CPMyRecommendVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 2:
        {
            //系统公告
            NSString *urlString = [[CookBook_GlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:@"/api/systemNotice"];
            CookBook_WebViewController *toWebVC = [[CookBook_WebViewController alloc] cookBook_WebWithURLString:urlString];
            toWebVC.title = @"公告";
            toWebVC.showPageTitles = NO;
            toWebVC.showActionButton = NO;
            toWebVC.navigationButtonsHidden = YES;
            
            toWebVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:toWebVC animated:YES];

            
        }break;
        case 3:
        {
            //投注记录
            
            CPBetRecordVC *vc = [CPBetRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.onlyShowWinRecord = NO;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 4:
        {
            //中奖记录
            CPBetRecordVC *vc = [CPBetRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            vc.onlyShowWinRecord = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }break;
        case 5:
        {
            //账户明细
            CPAccountRecordVC *vc = [CPAccountRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 6:
        {
            //充值记录
            CPRechargeRecordVC *vc = [CPRechargeRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 7:
        {
            //提款记录
            CPWithdrawRecordVC *vc = [CPWithdrawRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 8:
        {
            //签到记录
            CPSignRecordVC *vc = [CPSignRecordVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 9:
        {
            //个人消息
            CPPersonalMessageVC *vc = [CPPersonalMessageVC new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 10:
        {
            //我的红包
            NSString *urlString = [[CookBook_GlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:@"/api/user/hbList"];
            CookBook_WebViewController *toWebVC = [[CookBook_WebViewController alloc] cookBook_WebWithURLString:urlString];
            toWebVC.title = @"我的红包";
            toWebVC.showPageTitles = NO;
            toWebVC.showActionButton = NO;
            toWebVC.navigationButtonsHidden = YES;
            
            toWebVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:toWebVC animated:YES];
        }break;
            
        default:
            break;
    }
}

#pragma mark- actions

- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 101:
        {
            //刷新余额
            [self queryBalanceInfo];
            
        }break;
        case 102:
        {
            //在线客服
            if ([CookBook_GlobalDataManager shareGlobalData].kefuUrlString) {
                [self loadKefuWebView];
            }else{
                [self queryKefuUrlString];
            }
        }break;
        case 103:
        {
            //充值
            if ([CookBook_User shareUser].isTryPlay) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉，试玩账号不能进行存取款操作！" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            CPRechargeMainViewController *vc = [CPRechargeMainViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];

        }break;
        case 104:
        {
            //提现
            if ([CookBook_User shareUser].isTryPlay) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉，试玩账号不能进行存取款操作！" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            [CookBook_BusinessControllerManager cookBook_pushToWithdrawControllerOnViewController:self];
        }break;
        case 105:
        {
            //签到
            if ([CookBook_User shareUser].isTryPlay) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"抱歉，试玩账号不能进行签到操作！" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            CPSignVC *signVC = [CPSignVC new];
            signVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:signVC animated:YES];
            
        }break;
        case 122:
        {
            //手机购彩
            NSString *urlString = [[CookBook_GlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:@"/common/app/down1"];
            CookBook_WebViewController *toWebVC = [[CookBook_WebViewController alloc] cookBook_WebWithURLString:urlString];
            toWebVC.title = @"手机APP下载";
            toWebVC.showPageTitles = NO;
            toWebVC.showActionButton = NO;
            toWebVC.navigationButtonsHidden = YES;
            
            toWebVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:toWebVC animated:YES];

            
        }break;
            
        default:
            break;
    }
}


@end
