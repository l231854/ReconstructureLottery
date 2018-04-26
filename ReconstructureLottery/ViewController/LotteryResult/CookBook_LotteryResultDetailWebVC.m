//
//  CPLotteryResultDetailWebVC.m
//  lottery
//
//  Created by wayne on 2017/10/5.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_LotteryResultDetailWebVC.h"
#import <WebKit/WebKit.h>
@interface CookBook_LotteryResultDetailWebVC ()<WKNavigationDelegate>
{
    WKWebView *_wkWebView;
    IBOutlet UIView *_sortView;
}

@end

@implementation CookBook_LotteryResultDetailWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *rightItemImage = [UIImage imageNamed:@"top_you_anniu"];
    CPVoiceButton *btn = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, rightItemImage.size.width, rightItemImage.size.height);
    [btn addTarget:self action:@selector(showSortViewAction) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:rightItemImage forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    UIBarButtonItem* offsetItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    offsetItem.width = -10;
    
    self.navigationItem.rightBarButtonItems = @[offsetItem,[[UIBarButtonItem alloc]initWithCustomView:btn]];
    
    _sortView.hidden = YES;
    
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero];
    _wkWebView.navigationDelegate = self;
    [self.view addSubview:_wkWebView];

    [self.view bringSubviewToFront:_sortView];

    [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _wkWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadWebViewData];
    }];
    
    [_wkWebView.scrollView.mj_header beginRefreshing];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)reloadWebViewData
{
    NSString *urlString = _dayType == 99? _urlString:[NSString stringWithFormat:@"%@&dayType=%ld",_urlString,_dayType];
    [_wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];

}

-(void)showSortViewAction
{
    _sortView.hidden = _sortView.hidden?NO:YES;
}

#pragma mark-

-(void)setDayType:(NSInteger)dayType
{
    if (_dayType != dayType) {
        _dayType = dayType;
        [self reloadWebViewData];
    }
}

#pragma mark- webViewDelegate

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if (_wkWebView.scrollView.mj_header.isRefreshing) {
        [_wkWebView.scrollView.mj_header endRefreshing];
    }
    
    [_wkWebView evaluateJavaScript:@"document.getElementById(\"gameName\").value" completionHandler:^(id _Nullable item, NSError * _Nullable error) {

        if ([item isKindOfClass:[NSString class]]) {
            self.title = item;
        }
    }];

}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    if (_wkWebView.scrollView.mj_header.isRefreshing) {
        [_wkWebView.scrollView.mj_header endRefreshing];
    }
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    if (_webView.scrollView.mj_header.isRefreshing) {
//        [_webView.scrollView.mj_header endRefreshing];
//    }
//
//    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"gameName\").value"];
//    self.title = title?title:@"";
//
//}
//
//-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
//{
//    if (_webView.scrollView.mj_header.isRefreshing) {
//        [_webView.scrollView.mj_header endRefreshing];
//    }
//}

#pragma mark- action
- (IBAction)sortAction:(UIButton *)sender {
    switch (sender.tag) {
        case 101:
        {
            //今天
            self.dayType = 0;
        }break;
        case 102:
        {
            //昨天
            self.dayType = -1;
        }break;
        case 103:
        {
            //前天
            self.dayType = -2;
        }break;
            
        default:
            break;
    }
    if (_sortView.hidden == NO) {
        _sortView.hidden = YES;
    }
}



@end
