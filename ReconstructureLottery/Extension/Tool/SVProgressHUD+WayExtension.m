//
//  SVProgressHUD+WayExtension.m
//  lottery
//
//  Created by wayne on 2017/8/6.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "SVProgressHUD+WayExtension.h"

static const CGFloat WaySVExtensionMinimumDismissTimeInterval = 1.2f;

typedef enum : NSUInteger {
    WaySVExtensionForeBackStyleTypeOne = 0,

} WaySVExtensionShowInfoForeBackStyleType;

@implementation SVProgressHUD (WayExtension)

#pragma mark- showInfo

+(void)way_showInfoCanTouch:(BOOL)canTouch
                 withStatus:(NSString *)status
       dismissAfterInterval:(NSTimeInterval)interval
                     onView:(UIView *)onView
           offsetFromCenter:(UIOffset)offset
              foreBackStyle:(WaySVExtensionShowInfoForeBackStyleType)foreBackStyle
{
    [SVProgressHUD popActivity];
    [SVProgressHUD setOffsetFromCenter:offset];
    [SVProgressHUD setContainerView:onView];
    [SVProgressHUD setDefaultMaskType:canTouch?SVProgressHUDMaskTypeNone:SVProgressHUDMaskTypeClear];
    if (interval>0) {
        [SVProgressHUD setMinimumDismissTimeInterval:interval];
        [SVProgressHUD setMaximumDismissTimeInterval:interval];
    }else{
        [SVProgressHUD setMinimumDismissTimeInterval:WaySVExtensionMinimumDismissTimeInterval];
        [SVProgressHUD setMaximumDismissTimeInterval:CGFLOAT_MAX];
    }
    switch (foreBackStyle) {
        case WaySVExtensionForeBackStyleTypeOne :
        {
            [SVProgressHUD way_setCustomHUDStyleAndForeBckgStyleOne];
        }break;
        default:
            break;
    }
    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD showInfoWithStatus:status];


}

+(void)way_showInfoCanTouchWithStatus:(NSString *)status
                 dismissAfterInterval:(NSTimeInterval)interval
{
    
    [SVProgressHUD way_showInfoCanTouch:YES withStatus:status dismissAfterInterval:interval onView:nil offsetFromCenter:UIOffsetZero foreBackStyle:WaySVExtensionForeBackStyleTypeOne];
}

+(void)way_showInfoCanTouchWithStatus:(NSString *)status
                 dismissAfterInterval:(NSTimeInterval)interval
                               onView:(UIView *)onView
{
    [SVProgressHUD way_showInfoCanTouch:YES withStatus:status dismissAfterInterval:interval onView:onView offsetFromCenter:UIOffsetZero foreBackStyle:WaySVExtensionForeBackStyleTypeOne];

}

+(void)way_showInfoCanTouchWithStatus:(NSString *)status
                 dismissAfterInterval:(NSTimeInterval)interval
                               onView:(UIView *)onView
                         centerOffset:(UIOffset)offset
{
    [SVProgressHUD way_showInfoCanTouch:YES withStatus:status dismissAfterInterval:interval onView:onView offsetFromCenter:offset foreBackStyle:WaySVExtensionForeBackStyleTypeOne];
}

+(void)way_showInfoCanTouchAutoDismissWithStatus:(NSString *)status;
{
    [SVProgressHUD way_showInfoCanTouch:YES withStatus:status dismissAfterInterval:0 onView:nil offsetFromCenter:UIOffsetZero foreBackStyle:WaySVExtensionForeBackStyleTypeOne];
}


#pragma mark- showLoading

+(void)way_showLoadingCanNotTouchClearBackground
{
    [SVProgressHUD way_showLoadingWithStatus:nil maskType:SVProgressHUDMaskTypeClear onView:nil offsetFromCenter:UIOffsetZero foreBackStyle:WaySVExtensionForeBackStyleTypeOne];
}

+(void)way_showLoadingCanNotTouchClearBackgroundOnView:(UIView *)onView
{
    [SVProgressHUD way_showLoadingWithStatus:nil maskType:SVProgressHUDMaskTypeClear onView:onView offsetFromCenter:UIOffsetZero foreBackStyle:WaySVExtensionForeBackStyleTypeOne];
}

+(void)way_showLoadingCanNotTouchBlackBackground
{
    [SVProgressHUD way_showLoadingWithStatus:nil maskType:SVProgressHUDMaskTypeBlack onView:nil offsetFromCenter:UIOffsetZero foreBackStyle:WaySVExtensionForeBackStyleTypeOne];
}


+(void)way_showLoadingWithStatus:(NSString *)status
                        maskType:(SVProgressHUDMaskType)maskType
                          onView:(UIView *)onView
                offsetFromCenter:(UIOffset)offset
                   foreBackStyle:(WaySVExtensionShowInfoForeBackStyleType)foreBackStyle

{
    [SVProgressHUD popActivity];
    [SVProgressHUD resetOffsetFromCenter];
    [SVProgressHUD setContainerView:onView];
    [SVProgressHUD setOffsetFromCenter:offset];
    [SVProgressHUD setDefaultMaskType:maskType];
    switch (foreBackStyle) {
        case WaySVExtensionForeBackStyleTypeOne :
        {
            [SVProgressHUD way_setCustomHUDStyleAndForeBckgStyleOne];
        }break;
        default:
            break;
    }
    [SVProgressHUD showWithStatus:status];

}

#pragma mark- dismiss

+(void)way_dismissThenShowInfoWithStatus:(NSString *)status
                  showStatusTimeInterval:(NSTimeInterval)timeInterval
{
    [SVProgressHUD dismissWithCompletion:^{
        if (status.length > 0) {
            [SVProgressHUD way_showInfoCanTouchWithStatus:status dismissAfterInterval:timeInterval];
        }
    }];
}

+(void)way_dismissThenShowInfoWithStatus:(NSString *)status
{
    [SVProgressHUD way_dismissThenShowInfoWithStatus:status showStatusTimeInterval:0];
}


#pragma mark- CustomStyle

+(void)way_setCustomHUDStyleAndForeBckgStyleOne
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    [SVProgressHUD setCornerRadius:5.0f];

}

@end
