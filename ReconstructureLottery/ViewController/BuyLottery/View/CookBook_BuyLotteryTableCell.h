//
//  CPBuyLotteryTableCell.h
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookBook_BuyLotteryTableCell : UITableViewCell

@property(nonatomic,retain)CookBook_LotteryModel *lotteryModel;

+(CGFloat)cellHeightByLotteryModel:(CookBook_LotteryModel *)lotteryModel
                         cellWidth:(CGFloat)cellWidth;
@end
