//
//  CPRechargeBankCell.m
//  lottery
//
//  Created by wayne on 2017/9/10.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPRechargeBankCell.h"

@interface CPRechargeBankCell()
{
    IBOutlet UILabel *_bankNameLabel;
    IBOutlet UILabel *_collectionNameLabel;
    IBOutlet UILabel *_infoLabel;
    IBOutlet UIButton *_selectedImageView;
}

@end

@implementation CPRechargeBankCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_selectedImageView setImage:[UIImage imageNamed:@"cz_01"] forState:UIControlStateNormal];
    [_selectedImageView setImage:[UIImage imageNamed:@"cz_02"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)addBankName:(NSString *)bankName
    collectionName:(NSString *)collectionName
       infoMessage:(NSString *)message
          selected:(BOOL)selected
{
    _bankNameLabel.text = bankName;
    _collectionNameLabel.text = collectionName;
    _infoLabel.text = message;
    [_selectedImageView setSelected:selected];
    
}

@end
