//
//  CPLineLabel.m
//  lottery
//
//  Created by wayne on 2017/8/30.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPLineLabel.h"

@implementation CPLineLabel


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.height = kGlobalLineWidth;
    self.originY = self.superview.height-self.height;
    self.backgroundColor = kGlobalLineColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
