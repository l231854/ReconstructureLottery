//
//  CPLotteryShowResultView.h
//  lottery
//
//  Created by 施小伟 on 2017/11/18.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CookBook_LotteryShowResultView : UIView


-(void)showResult:(NSArray *)result
       resultType:(CPLotteryResultType)resultType
       isWaitOpen:(BOOL)isWaitOpen;

+(CGFloat)resultViewHeightByResult:(NSArray *)result
                        resultType:(CPLotteryResultType)resultType
                  isWaitOpenResult:(BOOL)isWaitOpen
                          maxWidth:(CGFloat)maxWidth
                            isList:(BOOL)isList;

@end
