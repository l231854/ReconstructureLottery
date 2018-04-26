//
//  CPBuyLotteryTableCell.m
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_BuyLotteryTableCell.h"

@interface CookBook_BuyLotteryTableCell ()
{
    IBOutlet UIImageView *_pictureImageView;
    IBOutlet UILabel *_titleLabel;
    
    IBOutlet UILabel *_nowLotteryNumberLabel;
    IBOutlet CookBook_LotteryShowResultView *_nowLotteryAnswerView;
    

    IBOutlet UILabel *_nextLotteryDesLabel;
    IBOutlet UILabel *_nextLotteryTimeLabel;
    
    
}

@end

@implementation CookBook_BuyLotteryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadCountDate) name:kNotificationNameForBuyLotteryCountTime object:nil];

}

+(CGFloat)cellHeightByLotteryModel:(CookBook_LotteryModel *)lotteryModel
                         cellWidth:(CGFloat)cellWidth;
{
    CGFloat height = 0;
    CGFloat resultViewMaxWidth = cellWidth - 103;
    NSArray *openResult = [lotteryModel.lastOpen componentsSeparatedByString:@","];
    height = 50 + [CookBook_LotteryShowResultView resultViewHeightByResult:openResult resultType:CPLotteryResultTypeByTypeString(lotteryModel.type) isWaitOpenResult:lotteryModel.lastOpen.length==0?YES:NO maxWidth:resultViewMaxWidth isList:YES];
    return height;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)reloadCountDate
{
    NSTimeInterval distance = [_lotteryModel.endTime doubleValue]/1000 -([[NSDate date] timeIntervalSince1970]-[CookBook_TimeManager shareTimeManager].beijingTiemDistance);
    NSTimeInterval our = distance/(60*60);
    NSInteger intOur = our;
    NSTimeInterval min = (distance - intOur*60*60)/60;
    NSInteger intMin = min;
    NSTimeInterval second = distance - intOur*60*60 - intMin*60;
    NSInteger intSecond = second;
    
    NSString *ourString = intOur>9?[NSString stringWithFormat:@"%ld",intOur]:[NSString stringWithFormat:@"0%ld",intOur];
    NSString *minString = intMin>9?[NSString stringWithFormat:@"%ld",intMin]:[NSString stringWithFormat:@"0%ld",intMin];
    NSString *secondString = intSecond>9?[NSString stringWithFormat:@"%ld",intSecond]:[NSString stringWithFormat:@"0%ld",intSecond];
    
    if (intOur<=0 && intMin<=0 && intSecond<=0) {
        _nextLotteryTimeLabel.text = @"00:00:00";
        [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationNameForBuyLotteryReloadList object:nil];

    }else{
        _nextLotteryTimeLabel.text = [NSString stringWithFormat:@"%@:%@:%@",ourString,minString,secondString];
    }
    

}

/*
 {
     lastOpen = "2,6,0,6,9";
     lastPeriod = 20170617415;
     name = "\U4e09\U5206\U65f6\U65f6\U5f69";
     num = 51;
     period = 20170617416;
     pic = "/assets/statics/images/icon/51.png";
     timeout = 72;
 }
 */
-(void)setLotteryModel:(CookBook_LotteryModel *)lotteryModel
{
    _lotteryModel = lotteryModel;
    [_pictureImageView sd_setImageWithURL:[NSURL URLWithString:_lotteryModel.fullPicUrlString] placeholderImage:nil];
    _titleLabel.text = _lotteryModel.name;
    _nowLotteryNumberLabel.text = [NSString stringWithFormat:@"第%@期",_lotteryModel.lastPeriod];
    NSArray *lastOpenResult = [lotteryModel.lastOpen componentsSeparatedByString:@","];
    [_nowLotteryAnswerView showResult:lastOpenResult resultType:CPLotteryResultTypeByTypeString(_lotteryModel.type) isWaitOpen:_lotteryModel.lastOpen.length==0?YES:NO];
    _nextLotteryDesLabel.text = [NSString stringWithFormat:@"距第%@期 截止还有",_lotteryModel.period];
    [self reloadCountDate];
    
}

@end
