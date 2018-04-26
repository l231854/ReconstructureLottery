//
//  CPLotteryResultMainCellStyle7.m
//  lottery
//
//  Created by wayne on 2017/7/18.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_LotteryResultMainCellStyle7.h"

@interface CookBook_LotteryResultMainCellStyle7 ()
{
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_contentLabel;
    
    IBOutlet UILabel *_resultLabel1;
    IBOutlet UILabel *_resultLabel2;
    IBOutlet UILabel *_resultLabel3;

    IBOutlet UIView *_resultBGView;
    
}

@end

@implementation CookBook_LotteryResultMainCellStyle7

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _resultBGView.layer.cornerRadius = _resultBGView.height/2.0f;
    _resultBGView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark-

-(void)addTitle:(NSString *)title content:(NSString *)content result:(NSArray *)result
{
    super.titleLabel = _titleLabel;
    super.contentLabel = _contentLabel;
    [super addTitle:title content:content result:result];
    if (result.count>=3) {
        
        _resultLabel1.text = result[0];
        _resultLabel2.text = result[1];
        _resultLabel3.text = result[2];
        
    }else{
        
        _resultLabel1.text = @"?";
        _resultLabel2.text = @"?";
        _resultLabel3.text = @"?";
    }
    
}




@end
