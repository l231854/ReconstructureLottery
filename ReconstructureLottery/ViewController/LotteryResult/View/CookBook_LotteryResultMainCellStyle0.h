//
//  CPLotteryResultMainCellStyle0.h
//  lottery
//
//  Created by wayne on 2017/7/18.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookBook_LotteryResultMainCellStyle0 : UITableViewCell

@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UILabel *contentLabel;

-(void)addTitle:(NSString *)title
        content:(NSString *)content
         result:(NSArray *)result;

@end
