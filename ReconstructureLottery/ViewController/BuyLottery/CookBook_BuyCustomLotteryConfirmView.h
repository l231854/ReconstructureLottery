//
//  CPBuyFastLotteryConfirmView.h
//  lottery
//
//  Created by wayne on 2017/9/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CPBuyCustomLotteryConfirmAction)(BOOL isConfirm);

@interface CookBook_BuyCustomLotteryConfirmView : UIView

+(void)cookBook_showCustomLotteryConfirmViewOnView:(UIView *)supView
                                 lotterys:(NSArray *)lotterys
                            numberPeriods:(NSString *)numberPeriods
                                  comfirm:(CPBuyCustomLotteryConfirmAction)confirm;


@end
