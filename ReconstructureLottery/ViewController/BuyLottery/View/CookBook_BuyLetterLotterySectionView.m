//
//  CPBuyLetterLotterySectionView.m
//  lottery
//
//  Created by wayne on 2017/10/13.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_BuyLetterLotterySectionView.h"


@interface CPBuyLetterLotterySectionButton : UIButton

@end

@implementation CPBuyLetterLotterySectionButton

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.titleLabel.frame = CGRectMake((self.width-self.titleLabel.width)/2.0f, (self.height-self.titleLabel.height)/2.0f, self.titleLabel.width, self.titleLabel.height);
    self.imageView.frame = CGRectMake((self.width-self.imageView.width)/2.0f, (self.height-self.imageView.height)/2.0f, self.imageView.width, self.imageView.height);;
    
}

@end

@interface CookBook_BuyLetterLotterySectionView()
{
    NSInteger _selectMaxCount;
    NSInteger _selectMinCount;
    NSString *_sectionName;
    
    UIImageView *_arrowImageView;
    UILabel *_sectionLabel;
}
@property(nonatomic,assign)BOOL isShowDetail;

@property(nonatomic,assign)CGFloat sectionHeight;
@property(nonatomic,assign)CGFloat contentHeight;
@property(nonatomic,assign)CGFloat itemHeight;

@property(nonatomic,strong)UIView *contentView;
@property(nonatomic,assign)id<CPBuyLetterLotterySectionViewDelegate>delegate;

@property(nonatomic,assign)NSInteger lineCount;
@property(nonatomic,assign)NSInteger rowCount;
@property(nonatomic,assign)NSInteger letterCount;

@property(nonatomic,retain)NSMutableArray *selectedButtons;

@property(nonatomic,retain)NSMutableArray *selectedLetters;
@property(nonatomic,retain)NSMutableArray *selectedLetterInfos;

@end

@implementation CookBook_BuyLetterLotterySectionView

-(instancetype)initWithFrame:(CGRect)frame
              selectMaxCount:(NSInteger)selectMaxCount
              selectMinCount:(NSInteger)selectMinCount
                 sectionName:(NSString *)sectionName
                    delegate:(id<CPBuyLetterLotterySectionViewDelegate>)delegate
{
    if (self = [super initWithFrame:frame]) {
        
        _selectMaxCount = selectMaxCount;
        _selectMinCount = selectMinCount;
        _sectionName = sectionName;
        _isShowDetail = YES;
        self.delegate = delegate;
        self.backgroundColor = kCOLOR_R_G_B_A(243, 243, 243, 1);
        self.selectedButtons = [NSMutableArray new];
        [self buildSection];
        [self buildContentView];
        self.height = self.sectionHeight + self.contentHeight;
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
              selectMaxCount:(NSInteger)selectMaxCount
                 sectionName:(NSString *)sectionName
                    delegate:(id<CPBuyLetterLotterySectionViewDelegate>)delegate
{
    
    if (self = [self initWithFrame:frame selectMaxCount:selectMaxCount selectMinCount:0 sectionName:sectionName delegate:delegate]) {
    }
    return self;
}

#pragma mark- build subviews

-(void)buildContentView
{
    NSInteger line = self.lineCount;
    NSInteger row = self.rowCount;

    CGFloat itemWidth = self.width/line;
    CGFloat itemHeight = self.itemHeight;
    CGFloat originX = 0;
    CGFloat originY = 0;
    NSInteger infoIndex = 0;
    for (int r=0 ; r<row; r++) {
        originY = r * itemHeight;
        
        for (int l=0; l<line; l++) {
            
            originX = l*itemWidth;
            infoIndex = r*line + l+1;
            if (infoIndex-1>=self.letterCount) {
                break;
            }
            CPBuyLetterLotterySectionButton *btn = [CPBuyLetterLotterySectionButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(originX, originY, itemWidth, itemHeight);
            [btn setTitle:[NSString stringWithFormat:@"%ld",infoIndex] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"white_circle_button"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"red_circle_button"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
            btn.tag = infoIndex;
            [btn addTarget:self action:@selector(itemSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            
        }
    }

}

-(void)buildSection
{
    CPVoiceButton *clickBtn = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(0, 0, self.width, self.sectionHeight);
    [clickBtn addTarget:self action:@selector(clickShowDetailAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clickBtn];
    
    _sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.width-20, self.sectionHeight)];
    _sectionLabel.textColor = kCOLOR_R_G_B_A(51, 51, 51, 1);
    _sectionLabel.textAlignment = NSTextAlignmentLeft;
    _sectionLabel.font = [UIFont systemFontOfSize:15.0f];
    _sectionLabel.text = _sectionName;
    [self addSubview:_sectionLabel];
    
    UIImage *img = [UIImage imageNamed:@"arrow_up"];
    _arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_up"] highlightedImage:[UIImage imageNamed:@"arrow_down"]];
    _arrowImageView.frame = CGRectMake(self.width - img.size.width - 15.0f, (self.sectionHeight - img.size.height)/2.0f, img.size.width, img.size.height);
    _arrowImageView.highlighted = YES;
    [self addSubview:_arrowImageView];
    
}


-(void)reloadSelectedLetters
{
    self.selectedLetters = [NSMutableArray new];
    for (UIButton *button in self.selectedButtons) {
        [self.selectedLetters addObject:[NSString stringWithFormat:@"%ld",button.tag]];
    }
    NSArray *sortArray = [self.selectedLetters sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [obj1 compare:obj2]; //升序
        
    }];
    self.selectedLetters = [[NSMutableArray alloc]initWithArray:sortArray];
}


#pragma mark- setter && getter

-(CGFloat)itemHeight
{
    return 43;
}

-(NSInteger)lineCount
{
    return 5;
}

-(NSInteger)rowCount
{
    NSInteger row =self.letterCount/self.lineCount;
    row = (self.letterCount%self.lineCount)>0?row+1:row;
    return row;
}

-(NSInteger)letterCount
{
    return 49;
}

-(CGFloat)sectionHeight
{
    return 40.0f;
}

-(CGFloat)contentHeight
{
    return self.rowCount*self.itemHeight;
}

-(void)setIsShowDetail:(BOOL)isShowDetail
{
    if (isShowDetail == _isShowDetail) {
        return;
    }
    _isShowDetail = isShowDetail;
    CGFloat height = 0;
    if (_isShowDetail) {
        height = self.contentHeight + self.sectionHeight;
        _contentView.hidden = NO;
        _arrowImageView.highlighted = YES;
        
        
    }else{
        height = self.sectionHeight;
        _contentView.hidden = YES;
        _arrowImageView.highlighted = NO;
        
    }
    
    
    self.height = height;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cookBook_buyLetterLotteryClickShowDetailAction)]) {
        [self.delegate cookBook_buyLetterLotteryClickShowDetailAction];
    }
    
}

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.sectionHeight, self.width, self.contentHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
    }
    return _contentView;
}


#pragma mark-

-(BOOL)isSelectedResult:(NSArray **)resultLetters
            sectionName:(NSString **)sectionName
{
    BOOL isSelected = NO;
    
    if (self.selectedButtons.count>0) {
        isSelected = YES;
        
        if (*sectionName) {
            *sectionName = _sectionName;
        }
        NSMutableArray *letters = [NSMutableArray new];
        for (UIButton *button in self.selectedButtons) {
            [letters addObject:[NSString stringWithFormat:@"%ld",button.tag]];
        }
        if (*resultLetters) {
            *resultLetters = letters;
        }
    }
    return isSelected;
}

#pragma mark- action


-(void)clickShowDetailAction
{
    self.isShowDetail = self.isShowDetail?NO:YES;
    
}

-(void)itemSelectedAction:(UIButton *)button
{
    if (button.isSelected) {
        
        button.selected = NO;
        if ([self.selectedButtons containsObject:button]) {
            [self.selectedButtons removeObject:button];
        }
        
    }else{
        
        button.selected = YES;
        [self.selectedButtons addObject:button];
        if (self.selectedButtons.count>_selectMaxCount) {
            UIButton *selectedButton = self.selectedButtons[0];
            selectedButton.selected = NO;
            [self.selectedButtons removeObjectAtIndex:0];
        }
    }
}

-(BOOL)isSelectedLotterys
{
    return self.selectedButtons.count>0?YES:NO;
}

-(BOOL)isVerifySelectedLotterys
{
    BOOL verify = NO;
    
    NSInteger selectedCounts = self.selectedButtons.count;
    if (selectedCounts>0) {
        if (selectedCounts>=_selectMinCount && selectedCounts<=_selectMaxCount) {
            verify = YES;
        }
    }
    
    return verify;
}

-(NSArray *)betValuesInfo
{
    self.selectedLetterInfos = [NSMutableArray new];
    [self reloadSelectedLetters];
    [self combine:(int)self.selectedLetters.count index:(int)_selectMinCount temp:@""];
    return self.selectedLetterInfos;
}

- (void)combine:(int)n index:(int)k temp:(NSString *)str
{
    for(int i = n; i >= k; i--)
    {
        if(k > 1)
        {
            [self combine:i-1 index:k-1 temp:[NSString stringWithFormat:@"%@%@&",str,[self.selectedLetters objectAtIndex:self.selectedLetters.count-i]]];
        }
        else
        {
            NSString *values = [NSString stringWithFormat:@"%@%@",str,[self.selectedLetters objectAtIndex:self.selectedLetters.count-i]];
            NSMutableDictionary *info = [[NSMutableDictionary alloc]initWithDictionary:self.lotteryInfo];
            [info setObject:values forKey:@"playNameValue"];
            [info setObject:[NSString stringWithFormat:@"%@:%@",[self.lotteryInfo DWStringForKey:@"playName"],values] forKey:@"playName"];
            [self.selectedLetterInfos addObject:info];
        }
    }
}

@end
