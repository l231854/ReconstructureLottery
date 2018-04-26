//
//  CPBuyFastLotteryConfirmView.h
//  lottery
//
//  Created by wayne on 2017/9/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CPBuyFastLotteryConfirmAction)(BOOL isConfirm, NSString *value);

@interface CookBook_BuyFastLotteryConfirmView : UIView


/**
 是否是数字盘
 */
@property(nonatomic,assign)BOOL isNumberPan;

+(void)showFastLotteryConfirmViewOnView:(UIView *)supView
                               lotterys:(NSArray *)lotterys
                          numberPeriods:(NSString *)numberPeriods
                                comfirm:(CPBuyFastLotteryConfirmAction)confirm;

+(void)showFastLotteryConfirmViewOnView:(UIView *)supView
                               lotterys:(NSArray *)lotterys
                          numberPeriods:(NSString *)numberPeriods
                            specailType:(int)specailType
                                comfirm:(CPBuyFastLotteryConfirmAction)confirm;

@end
