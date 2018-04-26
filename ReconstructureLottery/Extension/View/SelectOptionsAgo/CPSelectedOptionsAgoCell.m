//
//  DDChooseShopSizeCell.m
//  dada
//
//  Created by wayne on 16/1/12.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import "CPSelectedOptionsAgoCell.h"

@interface CPSelectedOptionsAgoCell ()
{
    IBOutlet UILabel *_lbContent;
    IBOutlet UILabel *_lineLabel;
}

@end

@implementation CPSelectedOptionsAgoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineLabel.height = ([UIScreen mainScreen].scale == 2?(1/[UIScreen mainScreen].scale):(1 / ([UIScreen mainScreen].scale/ 2)));
    _lineLabel.backgroundColor = [UIColor colorWithRed:208/255.0f green:213/255.0f blue:222/255.0f alpha:1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addContentText:(NSString *)text
           isShowLine:(BOOL)showLine
            isSeleted:(BOOL)isSelected
{
    _lbContent.text = text;
    _lineLabel.hidden = !showLine;
    [self setIsSelectedState:isSelected];
}

-(void)setIsSelectedState:(BOOL)isSeleted
{
    if (isSeleted) {
        _lbContent.textColor = [UIColor redColor];
    }else{
        _lbContent.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    }
}

@end
