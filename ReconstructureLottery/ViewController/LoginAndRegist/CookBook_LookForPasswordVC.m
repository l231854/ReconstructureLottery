//
//  CPLookForPasswordVC.m
//  lottery
//
//  Created by wayne on 2017/8/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_LookForPasswordVC.h"
#import "CPResetPasswordVC.h"

@interface CookBook_LookForPasswordVC ()
{
    IBOutlet UITextField *_tfUserName;
    IBOutlet UITextField *_tfQuestion;
    IBOutlet UITextField *_tfAnswer;
}
@end

@implementation CookBook_LookForPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"密码找回";
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
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入会员账号" dismissAfterInterval:2 onView:self.view centerOffset:UIOffsetMake(0, -32-28)];
        return;
    }
    if (_tfQuestion.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入密保问题" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    if (_tfAnswer.text.length == 0) {
        [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入密保答案" dismissAfterInterval:2 onView:self.navigationController.view];
        return;
    }
    
    [self.view endEditing:YES];
    [self queryVerify];
}


-(void)queryVerify
{
    
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"userName":_tfUserName.text,@"question":_tfQuestion.text,@"answer":_tfAnswer.text,@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIPasswordVerify
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   CPResetPasswordVC *vc = [CPResetPasswordVC new];
                   [self.navigationController pushViewController:vc animated:YES];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
    
    
}


@end
