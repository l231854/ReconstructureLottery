//
//  UIBarButtonItem+DWBarButtonItem.h
//  lottery
//
//  Created by wayne on 2017/11/1.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DWBarButtonItem)

+(instancetype)dwItemWithTitle:(NSString *)title
                    titleColor:(UIColor *)titleColor
                     titleFont:(UIFont *)titleFont
                          size:(CGSize)size
           horizontalAlignment:(UIControlContentHorizontalAlignment)contentAlignment
                        target:(id)target
                        action:(SEL)action;

+(instancetype)dwItemWithImage:(UIImage *)image
                          size:(CGSize)size
           horizontalAlignment:(UIControlContentHorizontalAlignment)contentAlignment
                        target:(id)target
                        action:(SEL)action;

@end
