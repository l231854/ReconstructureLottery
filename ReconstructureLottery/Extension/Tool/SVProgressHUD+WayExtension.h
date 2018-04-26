//
//  SVProgressHUD+WayExtension.h
//  lottery
//
//  Created by wayne on 2017/8/6.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>

@interface SVProgressHUD (WayExtension)


#pragma mark- showInfo
+(void)way_showInfoCanTouchWithStatus:(NSString *)status
                 dismissAfterInterval:(NSTimeInterval)interval;

+(void)way_showInfoCanTouchWithStatus:(NSString *)status
                 dismissAfterInterval:(NSTimeInterval)interval
                               onView:(UIView *)onView;

+(void)way_showInfoCanTouchWithStatus:(NSString *)status
                 dismissAfterInterval:(NSTimeInterval)interval
                               onView:(UIView *)onView
                         centerOffset:(UIOffset)offset;


+(void)way_showInfoCanTouchAutoDismissWithStatus:(NSString *)status;


#pragma mark- showLoading
+(void)way_showLoadingCanNotTouchClearBackground;
+(void)way_showLoadingCanNotTouchClearBackgroundOnView:(UIView *)onView;
+(void)way_showLoadingCanNotTouchBlackBackground;


#pragma mark- dismiss
+(void)way_dismissThenShowInfoWithStatus:(NSString *)status;
+(void)way_dismissThenShowInfoWithStatus:(NSString *)status
                  showStatusTimeInterval:(NSTimeInterval)timeInterval;
@end
