//
//  CPMultiRowTextScrollCell.m
//  lottery
//
//  Created by wayne on 2017/6/9.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPMultiRowTextScrollCell.h"

@interface CPMultiRowTextScrollCell()
{
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_amountLabel;
    IBOutlet UILabel *_contentLabel;
    
}

@end

@implementation CPMultiRowTextScrollCell


- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)addName:(NSString *)name
        amount:(NSString *)amount
       content:(NSString *)content
{
    _nameLabel.text = name;
    _amountLabel.text = [NSString stringWithFormat:@"%@",amount];
    _contentLabel.text = content;
}


@end
