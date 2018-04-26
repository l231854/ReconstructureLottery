//
//  DYView+DYExtension.m
//  帝友系统V5
//
//  Created by wayne on 15/7/11.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#define kCOLOR_R_G_B_A(r,g,b,a) [UIColor colorWithRed:r/255.0f  green:g/255.0f  blue:b/255.0f alpha:a]


#import "DYView+DYExtension.h"
#import "DWExtensionUtils.h"

@implementation UIView (DYViewExtension)

- (CGFloat)originX {
    return self.frame.origin.x;
}

- (void)setOriginX:(CGFloat)originX {
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
    return;
}

- (CGFloat)originY {
    return self.frame.origin.y;
}

- (void)setOriginY:(CGFloat)originY {
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
    return;
}

- (CGFloat)rightX {
    return [self originX] + [self width];
}

- (void)setRightX:(CGFloat)rightX {
    CGRect frame = self.frame;
    frame.origin.x = rightX - [self width];
    self.frame = frame;
    return;
}

- (CGFloat)bottomY {
    return [self originY] + [self height];
}

- (void)setBottomY:(CGFloat)bottomY {
    CGRect frame = self.frame;
    frame.origin.y = bottomY - [self height];
    self.frame = frame;
    return;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
    return;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
    return;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
    return;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
    return;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
    return;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
    return;
}

///< 移除此view上的所有子视图
- (void)removeAllSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    return;
}

@end

@implementation  UIButton (DYViewExtension)


-(void)dyBackgroundColorStyleModelOne
{
    [self setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(25, 143, 236, 1)]forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(25, 123, 226, 1)] forState:UIControlStateHighlighted];
    self.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.titleLabel.height = 46;
    self.layer.cornerRadius = 3.0f;
    self.layer.masksToBounds = YES;
}

-(void)dyBackgroundColorStyleModelTwo
{
    [self setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(94, 188, 252, 1)] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:kCOLOR_R_G_B_A(94, 160, 230, 1)] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    self.layer.cornerRadius=1.50f;
    self.layer.masksToBounds=YES;
    [self setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self setTitle:@"正在发送" forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
}


@end
