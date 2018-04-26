//
//  CPBuyLotteryFastItem.h
//  lottery
//
//  Created by wayne on 2017/9/16.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CookBook_BuyLotteryFastItem;

typedef void(^CPBuyLotteryFastItemClickAction)(NSDictionary *buyInfo, BOOL isSelected);
typedef void(^CPBuyLotteryFastItemClickActionTwo)(CookBook_BuyLotteryFastItem *item, NSDictionary *buyInfo, BOOL isSelected);
typedef void(^CPBuyLotteryFastItemClickActionThree)(NSString *infoIndex, BOOL isSelected);


@interface CookBook_BuyLotteryFastItem : UIView

@property(nonatomic,strong)NSDictionary *buyInfo;


-(void)cancelSelected;

+(void)cookBook_addBuyLotteryFastItemOnView:(UIView *)supView
                         withFrame:(CGRect)frame
                           buyInfo:(NSDictionary *)buyInfo
                       clickAction:(CPBuyLotteryFastItemClickAction)acion;

+(void)cookBook_addBuyLotteryFastItemOnView:(UIView *)supView
                         withFrame:(CGRect)frame
                           buyInfo:(NSDictionary *)buyInfo
              detailLabelTextColor:(UIColor *)detailLabelTextColor
                       clickAction:(CPBuyLotteryFastItemClickActionTwo)acion;

+(void)cookBook_addBuyLotteryFastItemOnView:(UIView *)supView
                         withFrame:(CGRect)frame
                           buyInfo:(NSDictionary *)buyInfo
                         infoIndex:(NSInteger)infoIndex
                       clickAction:(CPBuyLotteryFastItemClickActionThree)acion;

@end
