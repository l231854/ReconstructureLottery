//
//  CPWebViewController.m
//  lottery
//
//  Created by wayne on 2017/6/14.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_WebViewController.h"
#import "CPRechargeMainViewController.h"
#import "CPRechargeRecordVC.h"

@interface CookBook_WebViewController ()

@property(nonatomic,assign)BOOL isPop;

@end

@implementation CookBook_WebViewController

-(instancetype)cookBook_WebWithURLString:(NSString *)urlString;
{
//    self = [super initWithURLString:[NSURL URLWithString:urlString]];

    NSRange rangeWebMark = [urlString rangeOfString:kTransformSafariWebView];
    NSMutableString *mUrlString = [[NSMutableString alloc]initWithString:urlString?urlString:@""];
    if (rangeWebMark.length>0) {
        [mUrlString deleteCharactersInRange:rangeWebMark];
        NSURL *openUrl = [NSURL URLWithString:mUrlString];
        [[UIApplication sharedApplication]openURL:openUrl];
    }
    if (self) {
        
        self.url = [NSURL URLWithString:mUrlString];
        self.urlRequest = [[NSMutableURLRequest alloc]initWithURL:self.url];
        if (![urlString isEqualToString:mUrlString] && urlString) {
            self.isPop = YES;
        }
        
    }
    return self;
}

//- (instancetype)initWithURLString:(NSString *)urlString
//{
//
//    NSRange rangeWebMark = [urlString rangeOfString:kTransformSafariWebView];
//    NSMutableString *mUrlString = [[NSMutableString alloc]initWithString:urlString];
//    if (rangeWebMark.length>0) {
//        [mUrlString deleteCharactersInRange:rangeWebMark];
//        NSURL *openUrl = [NSURL URLWithString:mUrlString];
//        [[UIApplication sharedApplication]openURL:openUrl];
//        self.isPop = YES;
//    }
//    if (self = [super initWithURLString:mUrlString])
//    {
//
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cp_AddLongPressShotScreenAction];
    if(self.title.length == 0){
        self.showPageTitles = YES;
    }
    self.navigationItem.hidesBackButton = YES;
    self.webView.delegate = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self createNavigationLeftReturnBtn];
//    });
    
    
    if (self.isPop) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }


}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self createNavigationLeftReturnBtn];
    if (self.showHongBaoList == 1) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem dwItemWithTitle:@"红包记录" titleColor:[UIColor whiteColor] titleFont:[UIFont systemFontOfSize:15.0f] size:CGSizeMake(70, 44) horizontalAlignment:UIControlContentHorizontalAlignmentRight target:self action:@selector(hongBaoListAction)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-

-(void)hongBaoListAction
{
 
    if (![CookBook_User shareUser].isLogin) {
        [self.navigationController popViewControllerAnimated:NO];
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.maiTabBarController cookBook_goToLoginViewController];
        return ;
    }
    NSString *urlString = [[CookBook_GlobalDataManager shareGlobalData].domainUrlString wayStringByAppendingPathComponent:@"/api/user/hbList"];
    CookBook_WebViewController *toWebVC = [[CookBook_WebViewController alloc]cookBook_WebWithURLString:urlString];
    toWebVC.title = @"红包记录";
    toWebVC.showPageTitles = NO;
    toWebVC.showActionButton = NO;
    toWebVC.navigationButtonsHidden = YES;
    
    toWebVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:toWebVC animated:YES];
}

#pragma mark-

- (void)createNavigationLeftReturnBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:[UIImage imageNamed:@"topbar_icon_back_n"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"topbar_icon_back_n"] forState:UIControlStateHighlighted];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)]; 
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}


-(void)backAction
{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存图片到相册"]) {
        [self cp_ScreenShotWithView:self.webView];
    }
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    if ([urlString rangeOfString:@"weixin://"].length>0 || [urlString rangeOfString:@"mqqapi://"].length>0) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
        return NO;
    }else if ([urlString rangeOfString:@"cp89://"].length>0){
        
        NSInteger subFromIndex = [urlString rangeOfString:@"cp89://"].length;
        if (urlString.length>subFromIndex+1) {
            NSString *action = [urlString substringFromIndex:subFromIndex];
            if ([action isEqualToString:@"login"]) {
                
                if (![CookBook_User shareUser].isLogin) {
                    [self.navigationController popViewControllerAnimated:NO];
                    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [app.maiTabBarController cookBook_goToLoginViewController];
                    return NO;
                }else{
                    [CookBook_User cookBook_addWebCookies];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [webView reload];
                    });
                    return NO;
                }
                
            }else if ([action isEqualToString:@"recharge"]){
                
                CPRechargeMainViewController *vc = [CPRechargeMainViewController new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if ([action isEqualToString:@"chongzhiList"]){
                
                CPRechargeRecordVC *vc = [CPRechargeRecordVC new];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    NSLog(@"%@",request.URL.absoluteString);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (self.showPageTitles) {
        self.title = title;
    }
    
}

@end
