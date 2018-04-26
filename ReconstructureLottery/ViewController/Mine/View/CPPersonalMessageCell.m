//
//  CPPersonalMessageCell.m
//  lottery
//
//  Created by wayne on 2017/8/29.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPPersonalMessageCell.h"

@interface CPPersonalMessageCell ()
{
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_detailLabel;
    IBOutlet UILabel *_unreadLabel;
    
}

@end

@implementation CPPersonalMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _unreadLabel.layer.cornerRadius = _unreadLabel.width/2.0f;
    _unreadLabel.layer.masksToBounds = YES;
    _unreadLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addTitle:(NSString *)title
     detailText:(NSString *)detailText
       isRead:(BOOL)isRead
{
    _titleLabel.text = title;
    _detailLabel.text = detailText;
    _unreadLabel.hidden = isRead;
}

@end
