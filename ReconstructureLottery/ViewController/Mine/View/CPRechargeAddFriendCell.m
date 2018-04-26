//
//  CPRechargeAddFriendCell.m
//  lottery
//
//  Created by wayne on 2017/9/10.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPRechargeAddFriendCell.h"

@interface CPRechargeAddFriendCell()
{
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_detailLabel;
    IBOutlet UIImageView *_qrCodeImageView;
}
@end

@implementation CPRechargeAddFriendCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)addTitleText:(NSString *)title
         detailText:(NSString *)detailText
     imageUrlString:(NSString *)urlString
{
    _titleLabel.text = title;
    _detailLabel.text = detailText;
    [_qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:urlString]placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
}



@end
