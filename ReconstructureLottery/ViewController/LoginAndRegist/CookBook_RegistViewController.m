//
//  CPRegistViewController.m
//  lottery
//
//  Created by wayne on 2017/8/4.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_RegistViewController.h"
#import "CPLocalCodeLabel.h"
#import "CPTryPlayViewController.h"
@interface CookBook_RegistViewController ()
{
    
    IBOutlet UITextField *_tfName;
    IBOutlet UITextField *_tfPassword;
    IBOutlet UITextField *_referrerId;
    IBOutlet UITextField *_tfCode;
    
    IBOutlet UITextField *_tfPhone;
    IBOutlet UITextField *_tfMail;
    IBOutlet UITextField *_tfQQ;
    
    IBOutlet UIView *_topView;
    IBOutlet UIView *_phoneView;
    IBOutlet UIView *_mailView;
    IBOutlet UIView *_qqView;

    IBOutlet UIView *_bottomView;
    
    IBOutlet UILabel *_webInfoLabel;
    
    int _hasNeedEmailStatus;
    int _hasNeedPhoneStatus;
    int _hasNeedQQStatus;
    
    NSString *_webName;
    NSString *_verifyCode;
    NSString *_webUrl;
    
    IBOutlet CPLocalCodeLabel *_codeLabel;
    IBOutlet UIScrollView *_scrollMainView;
}
@end

@implementation CookBook_RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    [self queryRegistInfoIsLoading:YES];

    
    _phoneView.hidden = YES;
    _mailView.hidden = YES;
    _qqView.hidden = YES;
    
    _bottomView.originY = _topView.bottomY;

    self.navigationItem.rightBarButtonItem = [UIBarButtonItem dwItemWithTitle:@"免费试玩" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:15.0f] size:CGSizeMake(80, 44) horizontalAlignment:UIControlContentHorizontalAlignmentRight target:self action:@selector(freeTryPlayAction)];
    
    if (self.isShowDismissItem) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 44, 44);
        [btn setImage:[UIImage imageNamed:@"topbar_icon_back_n"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"topbar_icon_back_n"] forState:UIControlStateHighlighted];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
        [btn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }
}

-(void)dismissAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)freeTryPlayAction
{
    CPTryPlayViewController *tryPlayVC = [CPTryPlayViewController new];
    [self.navigationController pushViewController:tryPlayVC animated:YES];
}

-(void)showRegistSucceedAlertInfo
{
    [SVProgressHUD way_dismissThenShowInfoWithStatus:@"注册成功"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(void)reloadUIAfterData
{
    //--0不显示 1显示非必输 2显示必输
    CGFloat originY = _topView.bottomY;
    if (_hasNeedPhoneStatus != 0) {
        _phoneView.hidden = NO;
        _phoneView.originY = originY;
        originY += 44;

    }
    if (_hasNeedEmailStatus != 0) {
        _mailView.hidden = NO;
        _mailView.originY = originY;
        originY += 44;

    }
    
    if (_hasNeedQQStatus != 0) {
        _qqView.hidden = NO;
        _qqView.originY = originY;
        originY += 44;

    }

    _bottomView.originY = originY;
    
    _scrollMainView.contentSize = CGSizeMake(_scrollMainView.width, _bottomView.bottomY);
    
    
    NSString *text = [NSString stringWithFormat:@"请牢记%@官方永久域名 %@",_webName,_webUrl];
    NSMutableAttributedString *attDes = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:kCOLOR_R_G_B_A(153, 153, 153, 1)}];
    
    [attDes addAttributes:@{NSForegroundColorAttributeName:kCOLOR_R_G_B_A(255, 149, 28, 1)} range:[text rangeOfString:_webUrl]];
    _webInfoLabel.attributedText = attDes;
    
    _codeLabel.text = _verifyCode;
    [_codeLabel setNeedsDisplay];
//    _webInfoLabel.text = ;
//    [_webNameButton setTitle:_webName forState:UIControlStateNormal];
//    [_webAddressButton setTitle:_webUrl forState:UIControlStateNormal];

}


-(void)queryRegistInfoIsLoading:(BOOL)isLoading
{
    if (isLoading) {
        [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    }
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIRegistPreInfo
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   
                   NSDictionary *preInfo = [request.resultInfo DWDictionaryForKey:@"data"];
                   _hasNeedEmailStatus= [[preInfo DWStringForKey:@"email"]intValue];
                   _hasNeedPhoneStatus= [[preInfo DWStringForKey:@"phone"]intValue];
                   _hasNeedQQStatus = [[preInfo DWStringForKey:@"qq"]intValue];
                   
                   _webName = [preInfo DWStringForKey:@"webName"];
                   _verifyCode = [preInfo DWStringForKey:@"verifyCode"];
                   _webUrl = [preInfo DWStringForKey:@"dhUrl"];
                   [self reloadUIAfterData];
                   
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

#pragma mark- button atcions

- (IBAction)buttonActions:(UIButton *)sender {
    
    switch (sender.tag) {
        case 100:
        {
            //立即登录
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }break;
        case 101:
        {
            //法律声明
            CookBook_WebViewController *toWebVC = [[CookBook_WebViewController alloc] cookBook_WebWithURLString:[[NSString alloc]initWithString:[[CookBook_GlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:CookBook_SerVerAPINameForAPIRegLaw]]];
            toWebVC.title = @"协议";
            toWebVC.showPageTitles = NO;
            toWebVC.showActionButton = NO;
            toWebVC.navigationButtonsHidden = YES;
            [self.navigationController pushViewController:toWebVC animated:YES];
        }break;
        case 103:
        {
            //注册
            NSString *alertMsg = @"";
            
            if (_tfName.text.length == 0) {
                alertMsg = @"请输入用户名";
            }else if (_tfPassword.text.length == 0) {
                alertMsg = @"请输入密码";
            }else if (_tfCode.text.length == 0) {
                alertMsg = @"请输入验证码";
            }else if (_hasNeedPhoneStatus == 2 && _tfPhone.text.length == 0) {
                alertMsg = @"请输入手机号码";
                
            }else if (_hasNeedEmailStatus == 2 && _tfMail.text.length == 0){
                alertMsg = @"请输入邮箱";

            }else if (_hasNeedQQStatus == 2 && _tfQQ.text.length == 0){
                alertMsg = @"请输入QQ号码";

            }
            
            
            if (alertMsg.length>0) {
                
                [SVProgressHUD way_showInfoCanTouchWithStatus:alertMsg dismissAfterInterval:1.5 onView:self.view];
                
            }else{
                
                [self.view endEditing:YES];
                [self queryRegist];
            }
            
            
        }break;
            
        default:
            break;
    }
}


-(void)queryRegist
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"userName":_tfName.text,@"password":_tfPassword.text,@"vcode":_tfCode.text}];
    if (_referrerId.text.length >0) {
        [paramsDic setObject:_referrerId.text forKey:@"tjr"];
    }
    if (_tfPhone.text.length >0) {
        [paramsDic setObject:_tfPhone.text forKey:@"phone"];
    }
    if (_tfMail.text.length >0) {
        [paramsDic setObject:_tfMail.text forKey:@"email"];
    }
    if (_tfQQ.text.length >0) {
        [paramsDic setObject:_tfQQ.text forKey:@"qq"];
    }
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:[CookBook_User shareUser].token forKey:@"token"];
    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPIRegist
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   [self dismissAction];
                   alertMsg = @"注册成功";
                   [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForLoginSucceed object:nil];

               }else{
                   alertMsg = request.requestDescription;
               }
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:alertMsg];
               [self queryRegistInfoIsLoading:NO];
               
           } failure:^(__kindof CookBook_Request *request) {
               
               [SVProgressHUD way_dismissThenShowInfoWithStatus:@"网络异常"];
           }];

}

@end
