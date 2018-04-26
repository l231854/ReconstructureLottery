//
//  CPLookForPasswordVC.m
//  lottery
//
//  Created by wayne on 2017/8/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_LookForPasswordVC.h"
#import "CPModifyLoginPasswordVC.h"

@interface CPModifyLoginPasswordVC ()
{
    IBOutlet UITextField *_tfUserName;
    IBOutlet UITextField *_tfQuestion;
    IBOutlet UITextField *_tfAnswer;
}
@end

@implementation CPModifyLoginPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark-

- (IBAction)submitAction:(UIButton *)sender {
    
    if (_tfUserName.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入旧密码" dismissAfterInterval:2 onView:self.view centerOffset:UIOffsetMake(0, -32-28)];
        return;
    }
    if (_tfQuestion.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入新密码" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    if (_tfAnswer.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请再次输入新密码" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    
    
    if (![_tfAnswer.text isEqualToString:_tfQuestion.text]) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"两次输入的新密码不一致" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    
    [self.view endEditing:YES];
    [self queryVerify];
}


-(void)queryVerify
{
    
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"oPasswd":_tfUserName.text,@"passwd":_tfQuestion.text,@"nPasswd":_tfAnswer.text,@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPISettingLoginPasswd
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   alertMsg = @"修改密码成功";
                   [self.navigationController popViewControllerAnimated:YES];

               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
    
}


@end
