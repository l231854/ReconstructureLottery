//
//  CPHomepageCaijinVC.m
//  lottery
//
//  Created by 施小伟 on 2018/1/2.
//  Copyright © 2018年 施冬伟. All rights reserved.
//

#import "CookBook_HomepageCaijinVC.h"

@interface CookBook_HomepageCaijinVC ()<UITextFieldDelegate>
{
    
    IBOutlet UITextField *_phoneTf;
    IBOutlet UITextField *_codeTf;
    IBOutlet UIButton *_codeButton;
    
    IBOutlet UIWebView *_contentWebView;
    
    int _secondTotal;
}

@end

@implementation CookBook_HomepageCaijinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.caijin.title;
    
    [_contentWebView loadHTMLString:self.caijin.content baseURL:nil];
    _phoneTf.text = self.caijin.phone;
    
    [_codeButton setTitleColor:kMainColor forState:UIControlStateNormal];
    [_codeButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    _codeButton.layer.cornerRadius = 3.0f;
    _codeButton.layer.borderWidth = kGlobalLineWidth;
    _codeButton.layer.masksToBounds = YES;
    _codeButton.layer.borderColor = kMainColor.CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

#pragma mark-

- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 101:
        {
            //发送验证码
            [self querySendPhoneCode];
            
        }break;
        case 102:
        {
            //验证
            if (_codeTf.text.length == 0) {
                [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入验证码" dismissAfterInterval:1.0f onView:self.view];
                return;
            }
            [self queryGetCaijin];
            
        }break;
            
        default:
            break;
    }
}

#pragma mark  倒计时
- (void)setCountDownSecondTotal:(int)total
{
    
    _secondTotal=total;
    [self countDownForSendPhoneCode];
}


- (void)countDownForSendPhoneCode {
    
    _secondTotal--;
    
    if (_secondTotal<=0){
        
        _secondTotal = 0;
        [_codeButton setTitle:@"重发验证码" forState:UIControlStateNormal];
        _codeButton.enabled = YES;
        _codeButton.layer.borderColor = kMainColor.CGColor;

    }else{
        
        _codeButton.enabled = NO;
        _codeButton.layer.borderColor = [UIColor grayColor].CGColor;
        [self performSelector:@selector(countDownForSendPhoneCode) withObject:nil afterDelay:1];
    }
    
    [_codeButton setTitle:[NSString stringWithFormat:@"%@",_secondTotal==0?@"重发验证码":[NSString stringWithFormat:@"重新发送(%d)",_secondTotal]] forState:UIControlStateDisabled];
}


#pragma mark- network

-(void)querySendPhoneCode
{
    
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];

    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPISendMessageCode
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   alertMsg = @"发送成功";
                   
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [_codeTf becomeFirstResponder];
               [self setCountDownSecondTotal:60];
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
}

-(void)queryGetCaijin
{
    //kNotificationNameForReloadHomepageData
    
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:_codeTf.text forKey:@"vcode"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPISendSubmit
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   alertMsg = @"彩金领取成功";
                   [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForReloadHomepageData object:nil];
                   [self.navigationController popToRootViewControllerAnimated:YES];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}

@end
