//
//  CPBackgroundCornerLabel.m
//  lottery
//
//  Created by 施小伟 on 2017/11/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPBackgroundCornerLabel.h"

@interface CPBackgroundCornerLabel()
{
    UIColor *_textColor;
    UIFont *_textFont;
    NSString *_text;
}

@property(nonatomic,retain)UILabel *contentLabel;

@end

@implementation CPBackgroundCornerLabel

-(instancetype)initWithFrame:(CGRect)frame
             backgroundColor:(UIColor *)backgroundColor
                cornerRadius:(CGFloat)cornerRadius
                   textColor:(UIColor *)textColor
                    textFont:(UIFont *)textFont
                        text:(NSString *)text
{
    self = [super initWithFrame:frame];
    if (self) {
        _textColor = textColor;
        _textFont = textFont;
        _text = text;
        [self addSubview:self.contentLabel];
        self.backgroundColor = backgroundColor;
        self.layer.cornerRadius = cornerRadius;
    }
    return self;
}

-(UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = _textFont;
        _contentLabel.textColor = _textColor;
        _contentLabel.text = _text;
    }
    return _contentLabel;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
