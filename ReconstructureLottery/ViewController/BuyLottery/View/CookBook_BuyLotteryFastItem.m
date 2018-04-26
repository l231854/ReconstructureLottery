//
//  CPBuyLotteryFastItem.m
//  lottery
//
//  Created by wayne on 2017/9/16.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_BuyLotteryFastItem.h"

@interface CookBook_BuyLotteryFastItem ()

@property(nonatomic,strong)UILabel *topLabel;
@property(nonatomic,strong)UILabel *bottomLabel;
@property(nonatomic,strong)CPVoiceButton *selectecButton;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,copy)CPBuyLotteryFastItemClickAction action;
@property(nonatomic,copy)CPBuyLotteryFastItemClickActionTwo actionTwo;
@property(nonatomic,copy)CPBuyLotteryFastItemClickActionThree actionThree;

@property(nonatomic,strong)UIColor *detailLabelTextColor;

@property(nonatomic,copy)NSString *infoIndex;

@end

@implementation CookBook_BuyLotteryFastItem


 -(instancetype)initWithFrame:(CGRect)frame
                      buyInfo:(NSDictionary *)buyInfo
                  clickAction:(CPBuyLotteryFastItemClickAction)action
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isSelected = NO;
        self.buyInfo = buyInfo;
        self.action = action;
        
        NSString *haoString = [CookBook_User shareUser].buyLotteryDetailHasNumberPan?@"号":@"";
        self.topLabel.text = [NSString stringWithFormat:@"%@%@",[self.buyInfo DWStringForKey:@"playName"],haoString];
        self.bottomLabel.text = [NSString stringWithFormat:@"%.2f",[[self.buyInfo DWStringForKey:@"bonus"]floatValue]];

        self.selectecButton.selected =NO;

        [self addSubview:self.selectecButton];
        [self addSubview:self.topLabel];
        [self addSubview:self.bottomLabel];
        
        if ([CookBook_BuyLotteryManager shareManager].currentBuyLotteryType == CPLotteryResultForK3) {
            if ([[CookBook_BuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"点数"]) {
                self.topLabel.text = [NSString stringWithFormat:@"%@点",[self.buyInfo DWStringForKey:@"playName"]];
            }else{
                
                NSString *playName = [self.buyInfo DWStringForKey:@"playName"];
                if ([playName isPureInt]) {
                    self.topLabel.text = @"";
                    NSInteger playNameCount = playName.length;
                    CGFloat itemWidth = playNameCount>=3?19.0f:21;
                    CGFloat gap = 1.0f;
                    CGFloat originX = (self.width - playNameCount*itemWidth - (playNameCount-1)*gap)/2.0f;
                    CGFloat originY = 10;
                    
                    for (NSInteger i = 0; i<playNameCount; i++) {
                        NSString *number = [playName substringWithRange:NSMakeRange(i, 1)];
                        
                        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(originX, originY, itemWidth, itemWidth)];
                        imgView.image = [CookBook_BuyLotteryManager k3BackgroundImageByNumber:number];
                        [self addSubview:imgView];
                        originX = originX + gap + itemWidth;
                    }
                    
                }
                
            }
        }

    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
                     buyInfo:(NSDictionary *)buyInfo
{
    self = [self initWithFrame:frame buyInfo:buyInfo clickAction:nil];
    if (self) {
        self.bottomLabel.text = [self.buyInfo DWStringForKey:@"bonus"];
    }
    return self;
}

-(void)setDetailLabelTextColor:(UIColor *)detailLabelTextColor
{
    _bottomLabel.textColor = detailLabelTextColor;
}

-(void)cancelSelected
{
    self.isSelected = self.isSelected?NO:YES;
}

+(void)cookBook_addBuyLotteryFastItemOnView:(UIView *)supView
                         withFrame:(CGRect)frame
                           buyInfo:(NSDictionary *)buyInfo
                       clickAction:(CPBuyLotteryFastItemClickAction)acion
{
    CookBook_BuyLotteryFastItem *item = [[CookBook_BuyLotteryFastItem alloc]initWithFrame:frame buyInfo:buyInfo clickAction:acion];
    [supView addSubview:item];
}

+(void)cookBook_addBuyLotteryFastItemOnView:(UIView *)supView
                         withFrame:(CGRect)frame
                           buyInfo:(NSDictionary *)buyInfo
              detailLabelTextColor:(UIColor *)detailLabelTextColor
                       clickAction:(CPBuyLotteryFastItemClickActionTwo)acionTwo
{
    CookBook_BuyLotteryFastItem *item = [[CookBook_BuyLotteryFastItem alloc]initWithFrame:frame buyInfo:buyInfo];
    item.actionTwo = acionTwo;
    item.bottomLabel.textColor = detailLabelTextColor;
    [supView addSubview:item];
}

+(void)cookBook_addBuyLotteryFastItemOnView:(UIView *)supView
                         withFrame:(CGRect)frame
                           buyInfo:(NSDictionary *)buyInfo
                         infoIndex:(NSInteger)infoIndex
                       clickAction:(CPBuyLotteryFastItemClickActionThree)acion
{
    CookBook_BuyLotteryFastItem *item = [[CookBook_BuyLotteryFastItem alloc]initWithFrame:frame buyInfo:buyInfo];
    item.actionThree = acion;
    item.infoIndex = [NSString stringWithFormat:@"%ld",infoIndex];
    [supView addSubview:item];
}

#pragma mark- setter & getter

-(void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (_isSelected) {
        self.selectecButton.selected =YES;
    }else{
        self.selectecButton.selected =NO;
    }
}

-(UIButton *)selectecButton
{
    if (!_selectecButton) {
        _selectecButton = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
        _selectecButton.frame = CGRectMake(self.width*0.1, 6, self.width*0.8, self.height-12);
        [_selectecButton addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
        [_selectecButton setBackgroundImage:[UIImage imageNamed:@"liuhecai_btn_xiao"] forState:UIControlStateNormal];
        [_selectecButton setBackgroundImage:[UIImage imageNamed:@"liuhecai_btn_xuanzhong"] forState:UIControlStateSelected];

    }
    return _selectecButton;
}

-(UILabel *)topLabel
{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.width, self.height/2.0f-10)];
        _topLabel.textAlignment = NSTextAlignmentCenter;
        _topLabel.font = [UIFont systemFontOfSize:11.0f];
        _topLabel.textColor = kCOLOR_R_G_B_A(51, 51, 51, 1);
    }
    return _topLabel;
}

-(UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height/2.0f, self.width, self.height/2.0f-10)];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.font = [UIFont systemFontOfSize:11.0f];
        _bottomLabel.textColor = kMainColor;
    }
    return _bottomLabel;
}

#pragma mark-

-(void)clickAction
{
    self.isSelected = self.isSelected?NO:YES;
    if (self.action) {
        self.action(self.buyInfo,self.isSelected);
    }
    
    if (self.actionTwo) {
        self.actionTwo(self,self.buyInfo,self.isSelected);
    }
    
    if (self.actionThree) {
        self.actionThree(self.infoIndex,self.isSelected);
    }
}

@end
