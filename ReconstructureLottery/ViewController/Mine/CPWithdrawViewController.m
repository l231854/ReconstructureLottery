//
//  CPWithdrawViewController.m
//  lottery
//
//  Created by wayne on 2017/9/7.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPWithdrawViewController.h"
#import "CPWithdrawRecordVC.h"
@interface CPWithdrawViewController ()<UIScrollViewDelegate>
{
    IBOutlet UILabel *_accountNameLabel;
    IBOutlet UILabel *_accountBalanceLabel;
    IBOutlet UILabel *_accountBankLabel;

    IBOutlet UILabel *_accountCodeLabel;
    IBOutlet UILabel *_canWithdrawLabel;
    IBOutlet UILabel *_freeTimesLabel;
    IBOutlet UILabel *_canWithdrawMsgLabel;
    
    IBOutlet UITextField *_withdrawAmountTf;
    IBOutlet UITextField *_withdrawPasswordTf;
    
    
    IBOutlet UILabel *_alertMsgLabel;
    
    IBOutlet UIScrollView *_scrollView;
    
    IBOutlet UILabel *_tipMsgLabel;
    
}
@end

@implementation CPWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提款";
    
    CPVoiceButton *finishedButton = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    finishedButton.frame = CGRectMake(0, 0, 65, 65);
    [finishedButton addTarget:self action:@selector(withdrawRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [finishedButton setTitle:@"提款记录" forState:UIControlStateNormal];
    [finishedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishedButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    UIBarButtonItem* offsetItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    offsetItem.width = -10;
    self.navigationItem.rightBarButtonItems =@[offsetItem ,[[UIBarButtonItem alloc] initWithCustomView:finishedButton]];
    
    _withdrawAmountTf.keyboardType = UIKeyboardTypeNumberPad;
    
    int status = [[_withdrawInfo DWStringForKey:@"status"]intValue];
    if (status !=1) {
        
        _scrollView.hidden = YES;
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, kScreenWidth-20, self.view.height - 2*10)];
        textView.textColor = kCOLOR_R_G_B_A(51, 51, 51, 1);
        textView.font = [UIFont systemFontOfSize:16.0f];
        textView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:textView];
        
        textView.text = [_withdrawInfo DWStringForKey:@"closeTip"];
        
    }else{
        
        _accountNameLabel.text = [_withdrawInfo DWStringForKey:@"accountName"];
        _accountBalanceLabel.text = [_withdrawInfo DWStringForKey:@"amount"];
        _canWithdrawLabel.text = [_withdrawInfo DWStringForKey:@"canWithdraw"];
        _freeTimesLabel.text = [_withdrawInfo DWStringForKey:@"freeTimes"];
        _canWithdrawMsgLabel.text = [NSString stringWithFormat:@"您最后一笔入款%@，需下注%@才能提款，当前已下注%@",[_withdrawInfo DWStringForKey:@"lastRecharge"],[_withdrawInfo DWStringForKey:@"needDml"],[_withdrawInfo DWStringForKey:@"realDml"]];
        
        _accountCodeLabel.text = [_withdrawInfo DWStringForKey:@"accountCode"];
        _accountBankLabel.text = [_withdrawInfo DWStringForKey:@"bankName"];
        _tipMsgLabel.text = [_withdrawInfo DWStringForKey:@"withdrawTip"];
        _withdrawAmountTf.placeholder = [NSString stringWithFormat:@"最小提现金额为%@元",[_withdrawInfo DWStringForKey:@"minAmount"]];
        _scrollView.contentSize = CGSizeMake(kScreenWidth, 480.0f);
    }
    
  
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)confirmAction:(id)sender {
    
    if (_withdrawAmountTf.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入提款金额" dismissAfterInterval:2 onView:self.navigationController.view];

    }else if (_withdrawPasswordTf.text.length == 0){
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入提款密码" dismissAfterInterval:2 onView:self.navigationController.view];

    }else{
        [self.view endEditing:YES];
        [self queryWithdraw];
    }
    
    
    
}

-(void)withdrawRecordAction
{
    CPWithdrawRecordVC *vc = [CPWithdrawRecordVC new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark-

-(void)queryWithdraw
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    [paramsDic setObject:_withdrawAmountTf.text forKey:@"money"];
    [paramsDic setObject:_withdrawPasswordTf.text forKey:@"password"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserWithdrawSubmit
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   alertMsg = @"提款申请已提交";
                   [self withdrawRecordAction];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];

}


@end
