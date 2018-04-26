//
//  CPSelectedOptionsCollectionCell.m
//  lottery
//
//  Created by wayne on 2017/10/7.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPSelectedOptionsCollectionCell.h"

@interface CPSelectedOptionsCollectionCell ()
{
    
    IBOutlet UILabel *_textLabel;
}

@end

@implementation CPSelectedOptionsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)addText:(NSString *)text
    isSelected:(BOOL)isSelected
{
    _textLabel.text = text;
    _textLabel.textColor = isSelected?kMainColor:kCOLOR_R_G_B_A(105, 105, 105, 1);
        
}

@end
