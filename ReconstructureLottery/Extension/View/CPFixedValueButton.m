//
//  CPFixedValueButton.m
//  lottery
//
//  Created by wayne on 2017/9/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPFixedValueButton.h"

@implementation CPFixedValueButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    [CookBook_GlobalDataManager cookBook_playButtonClickVoice];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.borderColor = kMainColor.CGColor;
    self.layer.borderWidth = kGlobalLineWidth;
}

@end
