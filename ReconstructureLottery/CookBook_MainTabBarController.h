//
//  MainTabBarController.h
//  lottery
//
//  Created by wayne on 17/1/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPHomePageVC.h"
#import "CPBuyLotteryVC.h"
#import "CPLotteryResultVC.h"
#import "CPLotteryTrendVC.h"
#import "CPMineVC.h"
#import "CPLoginViewController.h"

@interface CookBook_MainTabBarController : UITabBarController

-(void)cookBook_goToLoginViewController;
-(void)cookBook_goToTrendViewControllerWithGid:(NSString *)gid;
-(void)cookBook_goToMineViewController;
-(void)cookBook_goToHomepageViewController;
-(void)cookBook_goToLotteryResultViewController;
-(void)cookBook_goToDetailResultViewControllerWithGid:(NSString *)gid;

@end
