//
//  UIBarButtonItem+DWBarButtonItem.m
//  lottery
//
//  Created by wayne on 2017/11/1.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "UIBarButtonItem+DWBarButtonItem.h"

@implementation UIBarButtonItem (DWBarButtonItem)

+(instancetype)dwItemWithTitle:(NSString *)title
                    titleColor:(UIColor *)titleColor
                     titleFont:(UIFont *)titleFont
                          size:(CGSize)size
           horizontalAlignment:(UIControlContentHorizontalAlignment)contentAlignment
                        target:(id)target
                        action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    button.titleLabel.font = titleFont;
    button.contentHorizontalAlignment = contentAlignment;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    return item;
}

+(instancetype)dwItemWithImage:(UIImage *)image
                          size:(CGSize)size
           horizontalAlignment:(UIControlContentHorizontalAlignment)contentAlignment
                        target:(id)target
                        action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button setImage:image forState:UIControlStateNormal];
    button.contentHorizontalAlignment = contentAlignment;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    return item;
}

@end
