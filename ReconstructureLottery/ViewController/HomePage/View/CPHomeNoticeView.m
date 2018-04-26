//
//  CPHomeNoticeView.m
//  lottery
//
//  Created by wayne on 2017/10/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPHomeNoticeView.h"
#import "RTLabel.h"
@interface CPHomeNoticeView ()
{
    
    IBOutlet UIView *_contentView;
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_dateLabel;
    IBOutlet RTLabel *_contentLabel;
    
    IBOutlet UIWebView *_webView;
    NSDictionary *_popInfo;
}

@end

@implementation CPHomeNoticeView

+(void)showWithPopInfo:(NSDictionary *)popInfo
{
    if ([CPHomeNoticeView hasContainNoticeView]) {
        return;
    }
    CPHomeNoticeView *view = [CPHomeNoticeView createViewFromNib];
    [view addAttributionWithPopInfo:popInfo];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [view showOnScreen];
    });
    
}

+(BOOL)hasContainNoticeView
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    BOOL contain = NO;
    for (UIView *subview in app.window.subviews) {
        if ([subview isKindOfClass:[CPHomeNoticeView class]]) {
            contain = YES;
            break;
        }
    }
    return contain;
}

-(void)addAttributionWithPopInfo:(NSDictionary *)popInfo
{
    _popInfo = popInfo;
    
    _titleLabel.text = [popInfo DWStringForKey:@"title"];
    _dateLabel.text = [popInfo DWStringForKey:@"time"];
    _contentLabel.text = [popInfo DWStringForKey:@"content"];
    [_webView loadHTMLString:[popInfo DWStringForKey:@"content"] baseURL:nil];
//    _webView.scrollView.scrollEnabled = NO;
    _contentView.layer.cornerRadius =5.0f;
    _contentView.layer.masksToBounds = YES;
    
    self.layer.opacity = 0;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self];
    self.frame  = CGRectMake(0, 0, self.superview.width, self.superview.height);
    [self layoutSubviews];
    
    CGSize size = [_contentLabel optimumSize];
    CGFloat height = _contentLabel.originY + size.height + 54;
    _contentLabel.hidden = YES;
    
    [_contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
//    [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(@(height));
//    }];

    
}

-(void)showOnScreen
{
    [UIView animateWithDuration:0.15 animations:^{
        self.layer.opacity = 1;
    }];
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    if (sender.tag == 102) {
        //不再提示
        [self queryKefuUrlString];
    }
    
    [UIView animateWithDuration:0.38 animations:^{
        self.layer.opacity = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

-(void)queryKefuUrlString
{
    [SVProgressHUD way_showLoadingCanNotTouchBlackBackground];
    
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    [paramsDic setObject:@"2" forKey:@"deviceType"];
    [paramsDic setObject:[_popInfo DWStringForKey:@"id"] forKey:@"id"];

    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    
    [CookBook_Request cookBook_startWithDomainString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString
                              apiName:CookBook_SerVerAPINameForAPINoticeNoTip
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
               NSString *msg = nil;
               if (!request.resultIsOk) {
                   msg = request.resultMsg;
               }
               [SVProgressHUD way_dismissThenShowInfoWithStatus:msg];

           } failure:^(__kindof CookBook_Request *request) {
               [SVProgressHUD way_dismissThenShowInfoWithStatus:request.resultMsg];
           }];
    
}


@end
