//
//  CPLotteryResultDetailWebVC.h
//  lottery
//
//  Created by wayne on 2017/10/5.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookBook_LotteryResultDetailWebVC : UIViewController

@property(nonatomic,copy)NSString *urlString;
/**
 dayType ：0表示当天 -1表示昨天 -2表示前天  99放空
 */
@property(nonatomic,assign)NSInteger dayType;

@end
