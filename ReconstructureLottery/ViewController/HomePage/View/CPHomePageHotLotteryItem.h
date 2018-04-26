//
//  CPHomePageHotLotteryItem.h
//  lottery
//
//  Created by wayne on 2017/6/12.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CPHomePageHotLotteryItemClickAction)(CookBook_LotteryModel *lotteryModel);

@interface CPHomePageHotLotteryItem : UIView

@property(nonatomic,assign)BOOL isShowRightGapLine;

-(instancetype)initWithFrame:(CGRect)frame
                     lottery:(CookBook_LotteryModel*)lottery
                 clickAction:(CPHomePageHotLotteryItemClickAction)action;

@end
