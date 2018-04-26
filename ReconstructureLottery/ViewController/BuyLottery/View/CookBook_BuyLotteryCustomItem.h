//
//  CPBuyLotteryCustomItem.h
//  lottery
//
//  Created by wayne on 2017/9/16.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CPBuyLotteryCustomItemFinishedAction)(NSDictionary *buyInfo, NSString *value);


@interface CookBook_BuyLotteryCustomItem : UIView

+(void)cookBook_addBuyLotteryCustomItemOnView:(UIView *)supView
                           withFrame:(CGRect)frame
                             buyInfo:(NSDictionary *)buyInfo
                         clickAction:(CPBuyLotteryCustomItemFinishedAction)acion;

+(void)cookBook_addHorizontalBuyLotteryCustomItemOnView:(UIView *)supView
                                     withFrame:(CGRect)frame
                                       buyInfo:(NSDictionary *)buyInfo
                                   clickAction:(CPBuyLotteryCustomItemFinishedAction)acion;

@end
