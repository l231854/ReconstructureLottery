//
//  CPBuyLotteryDetailVC.h
//  lottery
//
//  Created by wayne on 2017/9/16.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_BaseViewController.h"

typedef enum : NSUInteger {
    
    //正常
    CPBuyLotteryTypeNormal      = 0,
    
    //重庆幸运农场||广东快乐十分
    CPBuyLotteryTypeSpecailOne  = 1,
    
    //六合彩
    CPBuyLotteryTypeSpecailTwo  = 2,
    
} CPBuyLotteryType;

@interface CPBuyLotteryDetailVC : CookBook_BaseViewController

@property(nonatomic,strong)NSDictionary *playInfo;
@property(nonatomic,copy)NSString *lotteryName;

@property(nonatomic,assign)CPBuyLotteryType lotteryType;

@end
