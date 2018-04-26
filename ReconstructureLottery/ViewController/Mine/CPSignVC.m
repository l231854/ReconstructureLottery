//
//  CPSignVC.m
//  lottery
//
//  Created by wayne on 2017/8/26.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPSignVC.h"
#import "CPSignRecordVC.h"
#import "CPSelectedOptionsView.h"

@interface CPSignVC ()
{
    
    IBOutlet UILabel *_balanceLabel;
    IBOutlet UILabel *_rechargeDateLabelOne;
    IBOutlet UILabel *_rechargeDateLabelTwo;
    IBOutlet UILabel *_rechargeDateLabelThree;
    
    IBOutlet UILabel *_rechargeValueLabelOne;
    IBOutlet UILabel *_rechargeValueLabelTwo;
    IBOutlet UILabel *_rechargeValueLabelThree;
    
    IBOutlet UILabel *_totalDesLabel;
    IBOutlet UILabel *_totalValueLabel;

    
    IBOutlet UILabel *_givePerDesOne;
    IBOutlet UILabel *_givePerDesTwo;
    
    IBOutlet UILabel *_givePerValueOne;
    IBOutlet UILabel *_givePerValueTwo;

    IBOutlet UILabel *_redPacketValueLabel;

    IBOutlet UIView *_coverView;
    
    NSDictionary *_dataInfo;
}

@end

@implementation CPSignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到";
    
    CPVoiceButton *finishedButton = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    finishedButton.frame = CGRectMake(0, 0, 65, 65);
    [finishedButton addTarget:self action:@selector(signRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [finishedButton setTitle:@"签到记录" forState:UIControlStateNormal];
    [finishedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishedButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    UIBarButtonItem* offsetItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    offsetItem.width = -10;
    self.navigationItem.rightBarButtonItems =@[offsetItem ,[[UIBarButtonItem alloc] initWithCustomView:finishedButton]];
    
    _coverView.layer.opacity = 1;
    
    [self querySignInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)signRecordAction
{
    
    CPSignRecordVC *vc = [CPSignRecordVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)fillInfo
{
    
    _balanceLabel.text = [NSString stringWithFormat:@"￥%@",[_dataInfo DWStringForKey:@"balance"]];
    _redPacketValueLabel.text = [NSString stringWithFormat:@"￥%@",[_dataInfo DWStringForKey:@"giftAmount"]];
    
    NSArray *percentInfoList = [_dataInfo DWArrayForKey:@"percent"];
    
    if (percentInfoList.count>1) {
        NSDictionary *percentInfo = percentInfoList[0];
        
        _givePerDesOne.text = [NSString stringWithFormat:@"%@~%@：",[percentInfo DWStringForKey:@"min"],[percentInfo DWStringForKey:@"max"]];
        _givePerValueOne.text = [NSString stringWithFormat:@"%@",[percentInfo DWStringForKey:@"value"]];

        
        percentInfo = percentInfoList[1];

        _givePerDesTwo.text = [NSString stringWithFormat:@"%@~%@：",[percentInfo DWStringForKey:@"min"],[percentInfo DWStringForKey:@"max"]];
        _givePerValueTwo.text = [NSString stringWithFormat:@"%@",[percentInfo DWStringForKey:@"value"]];

    }

    
    NSArray *rechargeInfoList = [_dataInfo DWArrayForKey:@"rechargeList"];
    
    if (rechargeInfoList.count>3) {
        
        NSDictionary *rechargeInfo = rechargeInfoList[0];
        _rechargeDateLabelOne.text = [NSString stringWithFormat:@"%@：",[rechargeInfo DWStringForKey:@"key"]];
        _rechargeValueLabelOne.text = [NSString stringWithFormat:@"￥%@",[rechargeInfo DWStringForKey:@"value"]];
        
        rechargeInfo = rechargeInfoList[1];
        _rechargeDateLabelTwo.text = [NSString stringWithFormat:@"%@：",[rechargeInfo DWStringForKey:@"key"]];
        _rechargeValueLabelTwo.text = [NSString stringWithFormat:@"￥%@",[rechargeInfo DWStringForKey:@"value"]];
        
        rechargeInfo = rechargeInfoList[2];
        _rechargeDateLabelThree.text = [NSString stringWithFormat:@"%@：",[rechargeInfo DWStringForKey:@"key"]];
        _rechargeValueLabelThree.text = [NSString stringWithFormat:@"￥%@",[rechargeInfo DWStringForKey:@"value"]];

        
        rechargeInfo = rechargeInfoList[3];
        
        _totalDesLabel.text = [NSString stringWithFormat:@"%@：",[rechargeInfo DWStringForKey:@"key"]];
        _totalValueLabel.text = [NSString stringWithFormat:@"￥%@",[rechargeInfo DWStringForKey:@"value"]];

    }
}

#pragma mark- network

-(void)querySignInfo
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserCheckin
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *preInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   NSLog(@"%@",preInfo);
                   _coverView.hidden = YES;
                   _dataInfo = preInfo;
                   [self fillInfo];
                   
               }else{
                   alertMsg = request.requestDescription;
                   [self.navigationController popViewControllerAnimated:YES];
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
               [self.navigationController popViewControllerAnimated:YES];
               
           }];
}

-(void)querySign
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUsercheckinSubmit
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   alertMsg = @"签到成功";

               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
               
           }];
}

#pragma mark-
- (IBAction)signAction:(UIButton *)sender {
    [self querySign];
}



@end
