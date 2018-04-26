//
//  CPResetPasswordVC.m
//  lottery
//
//  Created by wayne on 2017/8/21.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPResetPasswordVC.h"

@interface CPResetPasswordVC ()
{
    IBOutlet UITextField *_tfPassword;
    IBOutlet UITextField *_tfPasswordVerify;

}
@end

@implementation CPResetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

#pragma mark-


- (IBAction)queryResetPassword:(UIButton *)sender {
    
    NSString *msg = @"";
    if (_tfPassword.text.length == 0 || _tfPasswordVerify.text.length == 0) {
        msg = @"请输入2次新密码";
        
    }else if (![_tfPassword.text isEqualToString:_tfPasswordVerify.text]){
        msg = @"两次密码输入不一致";
    }
    
    if (msg.length >0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:msg dismissAfterInterval:1.5 onView:self.view];
        return;
    }
    
    [self.view endEditing:YES];
    [self queryResetPassword];
}

-(void)queryResetPassword
{
    
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"password1":_tfPassword.text,@"password":_tfPasswordVerify.text,@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIPasswordReset
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   alertMsg = @"重置密码成功";
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
