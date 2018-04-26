//
//  CPCPSignRecordCell.m
//  lottery
//
//  Created by wayne on 2017/8/26.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPCPSignRecordCell.h"

@interface CPCPSignRecordCell ()
{
    IBOutlet UILabel *_topLeftLabel;
    IBOutlet UILabel *_topRightLabel;
    IBOutlet UILabel *_bottomLeftLabel;
    IBOutlet UILabel *_bottomRightLabel;
    
}

@end

@implementation CPCPSignRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addTopLeftText:(NSString *)topLeftText
         topRightText:(NSString *)topRightText
       bottomLeftText:(NSString *)bottomLeftText
      bottomRightText:(NSString *)bottomRightText
{
    _topLeftLabel.text = topLeftText;
    _topRightLabel.text = topRightText;
    _bottomLeftLabel.text = bottomLeftText;
    _bottomRightLabel.text = bottomRightText;
}

@end
