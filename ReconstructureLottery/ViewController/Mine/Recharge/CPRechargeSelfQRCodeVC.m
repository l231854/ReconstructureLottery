//
//  CPRechargeSelfQRCodeVC.m
//  lottery
//
//  Created by wayne on 2017/9/11.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPRechargeSelfQRCodeVC.h"
#import "CPRechargeRecordVC.h"

@interface CPRechargeSelfQRCodeVC ()<UIScrollViewDelegate,UIWebViewDelegate>
{
    IBOutlet UIScrollView *_scrollView;
    
    IBOutlet UILabel *_orderLabel;
    IBOutlet UILabel *_amountLabel;
    IBOutlet UIImageView *_qrCodeImageView;
    IBOutlet UIWebView *_stepMsgWebView;
    
    
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_nameDesLabel;
    IBOutlet UILabel *_codeLabel;
    IBOutlet UILabel *_codeDesLabel;

    IBOutlet UILabel *_aliasDesLabel;
    IBOutlet UITextField *_aliasTf;


    IBOutlet UILabel *_tipMsg;

    IBOutlet UIView *_topContentView;
    IBOutlet UIView *_centerContentView;
    
}
@end

@implementation CPRechargeSelfQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cp_AddLongPressShotScreenAction];

    _orderLabel.text = [_rechargeInfo DWStringForKey:@"orderNo"];
    _amountLabel.text = [_rechargeInfo DWStringForKey:@"amount"];
    _nameLabel.text = [_rechargeInfo DWStringForKey:@"name"];
    _codeLabel.text = [_rechargeInfo DWStringForKey:@"code"];
    _tipMsg.text = [_rechargeInfo DWStringForKey:@"tip"];
    [_stepMsgWebView loadHTMLString:[_rechargeInfo DWStringForKey:@"step"] baseURL:nil];
    _stepMsgWebView.scrollView.backgroundColor = [UIColor clearColor];

    NSString *imageUrl = [[CookBook_GlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:[_rechargeInfo DWStringForKey:@"img"]];
    [_qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRetryFailed];
    if ([[_rechargeInfo DWStringForKey:@"isShow"]intValue] == 1) {
        _aliasDesLabel.hidden = NO;
        _aliasTf.hidden = NO;

        
    }else{
        _aliasDesLabel.hidden = YES;
        _aliasTf.hidden = YES;
        
        _topContentView.height = _topContentView.height - 30;
        _centerContentView.originY = _topContentView.bottomY;
        _stepMsgWebView.originY = _centerContentView.bottomY;
    }
    
    
    switch (_qrCodeType) {
        case CPRechargeQRCodeTypeQQPay:
        {
            self.title = @"QQ充值";
            _nameDesLabel.text = @"QQ名称";
            _codeDesLabel.text = @"QQ号";
            _aliasDesLabel.text = @"存款QQ昵称";
            _aliasTf.placeholder = @"填写您的QQ昵称";
            
        }break;
        case CPRechargeQRCodeTypeAliPay:
        {
            self.title = @"支付宝充值";
            _nameDesLabel.text = @"支付宝名称";
            _codeDesLabel.text = @"支付宝账号";
            _aliasDesLabel.text = @"支付宝昵称";
            _aliasTf.placeholder = @"填写您的支付宝昵称";
        }break;
        case CPRechargeQRCodeTypeWechatPay:
        {
            self.title = @"微信充值";
            _nameDesLabel.text = @"微信名";
            _codeDesLabel.text = @"微信号";
            _aliasDesLabel.text = @"存款微信昵称";
            _aliasTf.placeholder = @"填写您的微信昵称";
        }break;
            
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark- webViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        webView.frame = CGRectMake(webView.originX, webView.originY, webView.width, webView.scrollView.contentSize.height);
        _scrollView.contentSize = CGSizeMake(webView.width,webView.bottomY + 10.0f);
    });
}

#pragma mark-

- (IBAction)buttonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 55:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }break;
        case 66:
        {
            [self querySubmit];
        }break;
            
        default:
            break;
    }
}

#pragma mark-

-(void)querySubmit
{
    [SVProgressHUD way_showLoadingCanNotTouchClearBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:[_rechargeInfo DWStringForKey:@"amount"] forKey:@"amount"];
    [paramsDic setObject:[_rechargeInfo DWStringForKey:@"orderNo"] forKey:@"orderNo"];
    [paramsDic setObject:[_rechargeInfo DWStringForKey:@"id"] forKey:@"payId"];
    
    if (_aliasTf.text.length>0) {
        [paramsDic setObject:_aliasTf.text forKey:@"inBank"];
    }
    
    NSString *apiName = @"";
    
    switch (_qrCodeType) {
        case CPRechargeQRCodeTypeQQPay:
        {
            apiName = @"";
            
        }break;
        case CPRechargeQRCodeTypeAliPay:
        {
            apiName = CookBook_SerVerAPINameForAPIUserRalipayScanSubmit;

        }break;
        case CPRechargeQRCodeTypeWechatPay:
        {
            apiName = CookBook_SerVerAPINameForAPIUserRwechatScanSubmit;

        }break;
            
        default:
            break;
    }

    
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:apiName
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               
               NSString *alertMsg = @"";
               if (request.resultIsOk) {
                   CPRechargeRecordVC *vc = [CPRechargeRecordVC new];
                   vc.hidesBottomBarWhenPushed = YES;
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
