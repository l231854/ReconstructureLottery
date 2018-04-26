//
//  CPBackgroundCornerLabel.h
//  lottery
//
//  Created by 施小伟 on 2017/11/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPBackgroundCornerLabel : UIView

-(instancetype)initWithFrame:(CGRect)frame
             backgroundColor:(UIColor *)backgroundColor
                cornerRadius:(CGFloat)cornerRadius
                   textColor:(UIColor *)textColor
                    textFont:(UIFont *)textFont
                        text:(NSString *)text;

@end
