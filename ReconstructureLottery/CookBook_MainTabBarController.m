//
//  MainTabBarController.m
//  lottery
//
//  Created by wayne on 17/1/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_MainTabBarController.h"
#import "LCLoadingHUD.h"


/**
 初始化数据的背景图

 @return 图片名称
 */
NSString *getLoadingBackgroundImageName(){
    
    NSString *iamgeName = @"";
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if (screenHeight == 480.0) {
        
        iamgeName = @"loadingBg_iphone4";
        
    }else if (screenHeight == 568.0) {
        
        iamgeName = @"loadingBg_iphone5";
        
    }else if (screenHeight == 667.0) {
        
        iamgeName = @"loadingBg_iphone6";
        
    }else if (screenHeight == 736.0) {
        
        iamgeName = @"loadingBg_iphonePlus";
        
    }else{
        
        iamgeName = @"loadingBg_iphoneX";
        
    }
    
    return iamgeName;
}

@interface CookBook_MainTabBarController ()<UITabBarControllerDelegate>
{
    UIView *_loadingView;
    UILabel *_loadingMsgLabel;

}
@end

@implementation CookBook_MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    [self buildLoadingView];
    [self reloadLoading];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cookBook_goToLoginViewController) name:kNotificationNameForPushToLoginViewController object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginTimeOutGoToLoginViewController) name:kNotificationNameForLoginOutTime object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cookBook_logout) name:kNotificationNameForLogOut object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(switchToBuyLotteryViewController) name:kNotificationNameForMainTabBarSwitchToBuyLottery object:nil];


    
    
    
}

-(void)addViewControllers
{
    
    
    CPHomePageVC * elfSupporVC =[[CPHomePageVC alloc]init];
    UINavigationController * nav1=[[UINavigationController alloc]initWithRootViewController:elfSupporVC];
    elfSupporVC.title=@"主页";
    elfSupporVC.tabBarItem.image = [[UIImage imageNamed:@"tab_home_no"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    elfSupporVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_home_check"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    CPBuyLotteryVC * overseasVC =[[CPBuyLotteryVC alloc]init];
    UINavigationController * nav2=[[UINavigationController alloc]initWithRootViewController:overseasVC];
    overseasVC.title=@"购彩大厅";
    overseasVC.tabBarItem.image = [[UIImage imageNamed:@"tab_goucai_no"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    overseasVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_goucai_check"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    CPLotteryResultVC * classifyVC =[[CPLotteryResultVC alloc]init];
    UINavigationController * nav3=[[UINavigationController alloc]initWithRootViewController:classifyVC];
    classifyVC.title=@"开奖";
    classifyVC.tabBarItem.image = [[UIImage imageNamed:@"tab_kaijiang_no"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    classifyVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_kaijiang_check"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    CPLotteryTrendVC * myAccountVC =[[CPLotteryTrendVC alloc]init];
    UINavigationController * nav4=[[UINavigationController alloc]initWithRootViewController:myAccountVC];
    myAccountVC.title=@"走势";
    myAccountVC.tabBarItem.image = [[UIImage imageNamed:@"tab_zoushi_no"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myAccountVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_zoushi_check"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    CPMineVC * myAccountVC2 =[[CPMineVC alloc]init];
//    CPLoginViewController * myAccountVC2 =[[CPLoginViewController alloc]init];
    
    UINavigationController * nav5=[[UINavigationController alloc]initWithRootViewController:myAccountVC2];
    myAccountVC2.title=@"我的";
    myAccountVC2.tabBarItem.image = [[UIImage imageNamed:@"tab_user_no"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myAccountVC2.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_user_check"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    if ([CookBook_GlobalDataManager shareGlobalData].isReviewVersion) {
        self.viewControllers=@[nav1,nav4,nav5];
    }else{
        self.viewControllers=@[nav1,nav2,nav3,nav4,nav5];
    }
}

-(void)buildLoadingView
{
    _loadingView = [[UIView alloc]initWithFrame:self.view.bounds];
    _loadingView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_loadingView];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _loadingView.width, _loadingView.height)];
    [imgView setImage:[UIImage imageNamed:getLoadingBackgroundImageName()]];
    [_loadingView addSubview:imgView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadLoading)];
    [_loadingView addGestureRecognizer:tapGes];
    
    _loadingMsgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,_loadingView.height/2.0 - 50, _loadingView.width, 50)];
    _loadingMsgLabel.textAlignment = NSTextAlignmentCenter;
    _loadingMsgLabel.textColor = kCOLOR_R_G_B_A(51, 51, 51, 1);
    _loadingMsgLabel.font = [UIFont systemFontOfSize:17.0f];
    _loadingMsgLabel.numberOfLines = 0;
    [_loadingView addSubview:_loadingMsgLabel];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



#pragma mark- notification

-(void)switchToBuyLotteryViewController
{
    self.selectedIndex = 1;
}

-(void)logout
{
    CPLoginViewController *loginVC = [CPLoginViewController new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
    self.selectedIndex = 0;
}

-(void)cookBook_goToLoginViewController
{
    
    [SVProgressHUD way_showInfoCanTouchAutoDismissWithStatus:@"请先登录"];
    CPLoginViewController *loginVC = [CPLoginViewController new];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)cookBook_goToTrendViewControllerWithGid:(NSString *)gid
{
    for (int i=0; i<self.viewControllers.count; i++) {
        UINavigationController *nav = self.viewControllers[i];
        UIViewController *vc = nav.viewControllers[0];
        if ([vc isKindOfClass:[CPLotteryTrendVC class]]) {
            if (gid.length>0) {
                CPLotteryTrendVC *trendVc = (CPLotteryTrendVC *)vc;
                trendVc.showInfoByGid = gid;
            }
            self.selectedIndex = i;
            break;
        }
    }

}

-(void)cookBook_goToMineViewController
{
    for (int i=0; i<self.viewControllers.count; i++) {
        UINavigationController *nav = self.viewControllers[i];
        UIViewController *vc = nav.viewControllers[0];
        if ([vc isKindOfClass:[CPMineVC class]]) {
            self.selectedIndex = i;
            break;
        }
    }
    
}

-(void)cookBook_goToDetailResultViewControllerWithGid:(NSString *)gid
{
    CPLotteryResultVC *resultVC;
    int resultIndex = 0;
    for (int i=0; i<self.viewControllers.count; i++) {
        UINavigationController *nav = self.viewControllers[i];
        UIViewController *vc = nav.viewControllers[0];
        if ([vc isKindOfClass:[CPLotteryResultVC class]]) {
            resultVC = (CPLotteryResultVC*)vc;
            resultIndex = i;
            break;
        }
    }
    
    if (resultVC) {
        if (resultVC.isLoadView) {
            [resultVC goToResultDetailWithGid:gid dayType:99 isShowPushAnimated:NO];
            self.selectedIndex = resultIndex;
        }else{
            self.selectedIndex = resultIndex;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [resultVC goToResultDetailWithGid:gid dayType:99 isShowPushAnimated:NO];
            });
        }
    }
    
}

-(void)cookBook_goToHomepageViewController
{
    for (int i=0; i<self.viewControllers.count; i++) {
        UINavigationController *nav = self.viewControllers[i];
        UIViewController *vc = nav.viewControllers[0];
        if ([vc isKindOfClass:[CPHomePageVC class]]) {
            self.selectedIndex = i;
            break;
        }
    }
    
}

-(void)cookBook_goToLotteryResultViewController
{
    for (int i=0; i<self.viewControllers.count; i++) {
        UINavigationController *nav = self.viewControllers[i];
        UIViewController *vc = nav.viewControllers[0];
        if ([vc isKindOfClass:[CPLotteryResultVC class]]) {
            self.selectedIndex = i;
            break;
        }
    }
    
}

-(void)loginTimeOutGoToLoginViewController
{
    if (!self.presentedViewController) {
        [self cookBook_goToLoginViewController];
        [SVProgressHUD way_showInfoCanTouchWithStatus:[CookBook_User shareUser].tokenInfo.errorMsg dismissAfterInterval:1.5 onView:self.view];
    }
    

}

#pragma mark- loading message

-(void)reloadLoading
{
    _loadingMsgLabel.text = @"";
    [LCLoadingHUD showLoading:@"加载数据" inView:self.view];
    [self queryDomainInfo];
    
}

-(void)showLoadingErrorAlert:(NSString *)msg
{
    _loadingMsgLabel.text = msg?msg:@"网络异常！点击刷新";
}


#pragma mark- network

-(void)queryDomainInfo
{
    
    /*
    NSDictionary *paramsDic = @{@"deviceType":@"2"};
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    */
    NSMutableDictionary *paramsDic =[[NSMutableDictionary alloc]initWithDictionary:@{@"token":[CookBook_User shareUser].token}];
    NSString *paramsString = [NSString encryptedByGBKAES:[paramsDic JSONString]];
    [CookBook_Request cookBook_startWithDomainString:CookBook_SerVerAPINameForAPIMain
                              apiName:@""
                               params:@{@"data":paramsString}
                         rquestMethod:YTKRequestMethodGET
           completionBlockWithSuccess:^(__kindof CookBook_Request *request) {
          
          if (request.resultIsOk) {
              
              NSDictionary *info = [request.resultInfo DWDictionaryForKey:@"data"];
              
              NSString *domainString = [info DWStringForKey:@"url"];
              NSString *updateUrl = [info DWStringForKey:@"updateUrl"];
              NSString *currentVersion = [info DWStringForKey:@"currentVersion"];
              NSString *lowVersion = [info DWStringForKey:@"lowVersion"];
              NSURL *domainUrl = [NSURL URLWithString:domainString];
              if (domainUrl) {

                  [CookBook_GlobalDataManager shareGlobalData].domainUrlString = domainString;
                  [CookBook_GlobalDataManager shareGlobalData].updateUrl = updateUrl;
                  [CookBook_GlobalDataManager shareGlobalData].lowVersion = lowVersion;
                  [CookBook_GlobalDataManager shareGlobalData].currentVersion = currentVersion;

                  [self addViewControllers];

                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      
                      [_loadingView removeFromSuperview];
                      [LCLoadingHUD hideInView:self.view];
                      
                      [CookBook_User cookBook_checkUpdateNewestVersion];
                  });
                  
              }else{
                  
                  [LCLoadingHUD hideInView:self.view];
                  [self showLoadingErrorAlert:nil];
              }
              
          }else{
              
              [LCLoadingHUD hideInView:self.view];
              [self showLoadingErrorAlert:nil];
          }
          
      } failure:^(__kindof CookBook_Request *request) {
          
          [LCLoadingHUD hideInView:self.view];
          [self showLoadingErrorAlert:nil];
      }];
}

#pragma mark- UITabBarControllerDelegate

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController

{
    [CookBook_GlobalDataManager cookBook_playButtonClickVoice];
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        UIViewController *rootViewController = nav.viewControllers[0];
        
        if ([rootViewController isKindOfClass:[CPHomePageVC class]]) {
            //主页
            
        }else if ([rootViewController isKindOfClass:[CPBuyLotteryVC class]]){
            //购彩

            
        }else if ([rootViewController isKindOfClass:[CPLotteryResultVC class]]){
            //开奖
            
            
        }else if ([rootViewController isKindOfClass:[CPLotteryTrendVC class]]){
            //主页
            
            
        }else if ([rootViewController isKindOfClass:[CPMineVC class]]){
         
            //我的
            if (![CookBook_User shareUser].isLogin) {
                [self cookBook_goToLoginViewController];
                return NO;
            }
        }
    }
    return YES;
}



@end
