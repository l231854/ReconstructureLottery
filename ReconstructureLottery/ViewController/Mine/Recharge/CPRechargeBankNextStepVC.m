//
//  CPRechargeBankNextStepVC.m
//  lottery
//
//  Created by wayne on 2017/9/10.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPRechargeBankNextStepVC.h"
#import "CPRechargeBankCompletedVC.h"

@interface CPRechargeBankNextStepVC ()
{
    IBOutlet UIScrollView *_scrollMainView;
    
    IBOutlet UILabel *_orderNoLabel;
    IBOutlet UILabel *_bankLabel;
    IBOutlet UILabel *_colletionMemberLabel;
    IBOutlet UILabel *_accountLabel;
    IBOutlet UILabel *_netPointLabel;
    
    
    IBOutlet UITextField *_currentTimeTf;
    IBOutlet UITextField *_amountTf;
    IBOutlet UITextField *_memberNameTf;
    
    IBOutlet UIButton *_netBankButton;
    UIButton *_markSelectedButton;
    
    NSInteger _selectedType;
    
}
@end

@implementation CPRechargeBankNextStepVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    
    _scrollMainView.contentSize = CGSizeMake(self.view.width, 650.0f);
    
    //init selected type
    _markSelectedButton = _netBankButton;
    _markSelectedButton.selected = YES;
    _selectedType = _markSelectedButton.tag;
    
    
    _orderNoLabel.text = [_bankInfo DWStringForKey:@"orderNo"];
    _bankLabel.text = [_bankInfo DWStringForKey:@"bankName"];
    _colletionMemberLabel.text = [_bankInfo DWStringForKey:@"accountName"];
    _accountLabel.text = [_bankInfo DWStringForKey:@"accountCode"];
    _netPointLabel.text = [_bankInfo DWStringForKey:@"bankAddr"];
    
    _amountTf.text = [_bankInfo DWStringForKey:@"money"];
    _currentTimeTf.text = [_bankInfo DWStringForKey:@"saveTime"];

    /*
     {
         accountCode = 6217711112516313;
         accountName = "\U82d1\U6625\U6885";
         bankAddr = "\U90d1\U5dde\U4eac\U5e7f\U8def\U652f\U884c";
         bankName = "\U4e2d\U4fe1\U94f6\U884c";
         id = 14;
         payMax = 200000;
         payMin = 50;
     }
     */
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonAction:(UIButton *)sender {
    if (sender.tag == 55) {
        //上一步
        [self.navigationController popViewControllerAnimated:YES];
    }else  if (sender.tag == 66) {
        //下一步
        if ([_amountTf.text floatValue]<=0) {
            [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请输入充值金额"];

        }else if ([_memberNameTf.text length]<=0){
            [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请输入存款人姓名"];
        }else{
            
        }
        [self.view endEditing:YES];
        [self queryFinishedBankCharge:[NSString stringWithFormat:@"%ld",(long)_selectedType] bankId:[_bankInfo DWStringForKey:@"id"] order:[_bankInfo DWStringForKey:@"orderNo"] money:_amountTf.text name:_memberNameTf.text time:[_bankInfo DWStringForKey:@"saveTime"]];
        
    }else{
        _markSelectedButton.selected = NO;
        _markSelectedButton = sender;
        _markSelectedButton.selected = YES;
        _selectedType = _markSelectedButton.tag;
    }
}

- (IBAction)copyTextAction:(UIButton *)sender {
    
    NSString *copyString = @"";
    NSString *alertString = @"";
    switch (sender.tag) {
        case 101:
        {
            if (_bankLabel.text.length>0) {
                copyString = _bankLabel.text;
                alertString = @"复制银行名字成功";
            }
            
        }break;
        case 102:
        {
            if (_colletionMemberLabel.text.length>0) {
                copyString = _colletionMemberLabel.text;
                alertString = @"复制收款人姓名成功";
            }
        }break;
        case 103:
        {
            if (_accountLabel.text.length>0) {
                copyString = _accountLabel.text;
                alertString = @"复制账号成功";
            }
        }break;
        case 104:
        {
            if (_netPointLabel.text.length>0) {
                copyString = _netPointLabel.text;
                alertString = @"复制开户网点成功";
            }
        }break;
            
        default:
            break;
    }

    if (copyString.length>0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = copyString;
        [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:alertString];
    }
        

}


#pragma mark- network


-(void)queryFinishedBankCharge:(NSString *)type
                        bankId:(NSString *)bankId
                         order:(NSString *)order
                         money:(NSString *)money
                          name:(NSString *)name
                          time:(NSString *)time
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];

    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    
    [paramsDic setObject:type forKey:@"type"];
    [paramsDic setObject:bankId forKey:@"id"];
    [paramsDic setObject:order forKey:@"orderNo"];
    [paramsDic setObject:money forKey:@"money"];
    [paramsDic setObject:name forKey:@"name"];
    [paramsDic setObject:time forKey:@"time"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIUserRbankSubmit
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   CPRechargeBankCompletedVC *vc = [CPRechargeBankCompletedVC new];
                   vc.rechargeMoney = money;
                   [self.navigationController pushViewController:vc animated:YES];
                   [self removeSelfFromNavigationControllerViewControllers];
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];

}



@end
