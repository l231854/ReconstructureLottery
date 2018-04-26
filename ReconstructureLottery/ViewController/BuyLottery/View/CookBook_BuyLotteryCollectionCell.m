//
//  CPBuyLotteryCollectionCell.m
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_BuyLotteryCollectionCell.h"

@interface CookBook_BuyLotteryCollectionCell()
{
    IBOutlet UIImageView *_pictureImageView;
    IBOutlet UILabel *_nameLabel;
    
}
@end

@implementation CookBook_BuyLotteryCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

-(void)setLotteryModel:(CookBook_LotteryModel *)lotteryModel
{
    _lotteryModel = lotteryModel;
    [_pictureImageView sd_setImageWithURL:[NSURL URLWithString:_lotteryModel.fullPicUrlString] placeholderImage:nil];
    _nameLabel.text = _lotteryModel.name;
}

@end
