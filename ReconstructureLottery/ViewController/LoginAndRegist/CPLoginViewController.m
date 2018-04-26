//
//  CPLoginViewController.m
//  lottery
//
//  Created by wayne on 2017/8/4.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPLoginViewController.h"
#import "CookBook_RegistViewController.h"
#import "CPTryPlayViewController.h"
#import "CookBook_LookForPasswordVC.h"
#import "WXApi.h"

@interface CPLoginViewController ()
{
    IBOutlet UITextField *_tfName;
    IBOutlet UITextField *_tfPassword;
    
    IBOutlet UIButton *_tryPlayButton;
}
@end

@implementation CPLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:@"topbar_icon_back_n"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"topbar_icon_back_n"] forState:UIControlStateHighlighted];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
    [btn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    if ([CookBook_GlobalDataManager shareGlobalData].isReviewVersion) {
        _tryPlayButton.hidden = YES;
    }
    
    if (self.isPushToRegistViewController) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CookBook_RegistViewController *registVC = [CookBook_RegistViewController new];
            [self.navigationController pushViewController:registVC animated:NO];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(void)loadKefuWebView
{
    
   
    CookBook_WebViewController *toWebVC = [[CookBook_WebViewController alloc] cookBook_WebWithURLString:[[NSString alloc]initWithString:[CookBook_GlobalDataManager shareGlobalData].kefuUrlString]];
    
    toWebVC.title = @"客服";
    toWebVC.showPageTitles = NO;
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
}

-(void)dismissAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- button Actions

- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 101:
        {
            //客服
            if ([CookBook_GlobalDataManager shareGlobalData].kefuUrlString) {
                [self loadKefuWebView];
            }else{
                [self queryKefuUrlString];
            }
        }break;
        case 102:
        {
            //忘记密码
            CookBook_LookForPasswordVC *registVC = [CookBook_LookForPasswordVC new];
            [self.navigationController pushViewController:registVC animated:YES];
            
        }break;
        case 103:
        {
            //登录
            if (_tfName.text.length == 0) {
                [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入账号" dismissAfterInterval:1.5 onView:self.view];
                return;
            }
            if (_tfPassword.text.length == 0) {
                [SVProgressHUD way_showInfoCanTouchWithStatus:@"请输入密码" dismissAfterInterval:1.5 onView:self.view];
                return;
            }
            [self.view endEditing:YES];
            [self queryLoginWithUserName:_tfName.text password:_tfPassword.text];
            
        }break;
        case 104:
        {
            //注册
            CookBook_RegistViewController *registVC = [CookBook_RegistViewController new];
            [self.navigationController pushViewController:registVC animated:YES];
            
        }break;
        case 105:
        {
            //试玩
            CPTryPlayViewController *tryPlayVC = [CPTryPlayViewController new];
            [self.navigationController pushViewController:tryPlayVC animated:YES];

        }break;
        case 108:
        {
            //试玩
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"GSTDoctorApp";
            [WXApi sendReq:req];
            
        }break;
            
        default:
            break;
    }
}


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
               [self.navigationController popViewControllerAnimated:YES];
               
           }];

}

-(void)queryLoginWithUserName:(NSString *)userName
                     password:(NSString *)password
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    NSDictionary *paramsDic = @{@"userName":userName,@"password":password,@"deviceType":@"2"};
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPILoginSubmit
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   NSString *token = [request.resultInfo DWStringForKey:@"token"];
                   [[CookBook_User shareUser]cookBook_addToken:token];
                   [self dismissAction];
                   alertMsg = @"登录成功";
                   [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForLoginSucceed object:nil];
                   
               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];

           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];
}

@end
