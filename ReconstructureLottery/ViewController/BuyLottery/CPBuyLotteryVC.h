//
//  CPBuyLotteryVC.h
//  lottery
//
//  Created by wayne on 17/1/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CookBook_BaseViewController.h"

typedef enum : NSUInteger {
    
    CPBuyLotteryKindAll             = 0,
    CPBuyLotteryKindHighFrequency   = 1,
    CPBuyLotteryKindLowFrequency    = 2,
    
} CPBuyLotteryKind;

typedef enum : NSUInteger {
    
    CPBuyLotteryShowKindTable       = 0,
    CPBuyLotteryShowKindCollection  = 1,
    
} CPBuyLotteryShowKind;


@interface CPBuyLotteryVC : CookBook_BaseViewController

@property(nonatomic,assign)CPBuyLotteryKind lotteryKind;
@property(nonatomic,assign)CPBuyLotteryShowKind showKind;


@end
