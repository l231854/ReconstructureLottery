//
//  CPRechargeNormalCell.m
//  lottery
//
//  Created by wayne on 2017/9/10.
//  Copyright © 2017年 施冬伟. All rights reserved.
//


#import "CPRechargeNormalCell.h"

@interface CPRechargeNormalCell ()
{
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_detailInfoLabel;
    IBOutlet UIButton *_selectedImageView;
}

@end

@implementation CPRechargeNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_selectedImageView setImage:[UIImage imageNamed:@"cz_01"] forState:UIControlStateNormal];
    [_selectedImageView setImage:[UIImage imageNamed:@"cz_02"] forState:UIControlStateSelected];

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)addBankName:(NSString *)bankName
        detailInfo:(NSString *)detailInfo
          selected:(BOOL)selected
{
    _nameLabel.text = bankName;
    _detailInfoLabel.text = detailInfo;
    [_selectedImageView setSelected:selected];
    
}

@end
