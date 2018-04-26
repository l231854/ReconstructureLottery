//
//  CPBuyLetterLotterySectionView.h
//  lottery
//
//  Created by wayne on 2017/10/13.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CPBuyLetterLotterySectionViewDelegate <NSObject>

-(void)cookBook_buyLetterLotteryClickShowDetailAction;

@end

@interface CookBook_BuyLetterLotterySectionView : UIView

@property(nonatomic,strong)NSDictionary *lotteryInfo;

-(instancetype)initWithFrame:(CGRect)frame
              selectMaxCount:(NSInteger)selectMaxCount
                 sectionName:(NSString *)sectionName
                    delegate:(id<CPBuyLetterLotterySectionViewDelegate>)delegate;

-(instancetype)initWithFrame:(CGRect)frame
              selectMaxCount:(NSInteger)selectMaxCount
              selectMinCount:(NSInteger)selectMinCount
                 sectionName:(NSString *)sectionName
                    delegate:(id<CPBuyLetterLotterySectionViewDelegate>)delegate;

-(BOOL)isSelectedResult:(NSArray **)resultLetters
            sectionName:(NSString **)sectionName;

-(BOOL)isSelectedLotterys;
-(BOOL)isVerifySelectedLotterys;
-(NSArray *)betValuesInfo;

@end
