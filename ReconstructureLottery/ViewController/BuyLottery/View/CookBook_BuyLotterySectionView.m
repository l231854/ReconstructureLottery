//
//  CPBuyLotterySectionView.m
//  lottery
//
//  Created by wayne on 2017/9/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_BuyLotterySectionView.h"
#import "CookBook_BuyLotteryFastItem.h"
#import "CookBook_BuyLotteryCustomItem.h"

@interface CookBook_BuyLotterySectionView ()
{
    UIImageView *_arrowImageView;
    
    UILabel *_sectionLabel;
    
    CGFloat _heXiaoBonuds;
}

@property(nonatomic,assign)id<CPBuyLotterySectionViewDelegate>delegate;
@property(nonatomic,assign)CPBuyLotteryBetType betType;

@property(nonatomic,strong)NSArray *itemInfos;

@property(nonatomic,assign)CGFloat sectionHeight;
@property(nonatomic,assign)CGFloat contentHeight;

@property(nonatomic,assign)CGFloat itemHeight;

@property(nonatomic,assign)BOOL isShowDetail;

@property(nonatomic,assign)NSInteger lineCount;
@property(nonatomic,assign)NSInteger rowCount;

@property(nonatomic,strong)UIView *contentView;

//合肖
@property(nonatomic,strong)NSMutableArray *heXiaoArray;
@property(nonatomic,strong)NSArray *heXiaoPlayDetailList;
@property(nonatomic,strong)NSDictionary *heXiaoPlayInfo;


//连肖连尾
@property(nonatomic,strong)NSMutableArray *lianXiaoWeiSelectedIndexs;
@property(nonatomic,strong)NSMutableArray *lianXiaoWeiSelectedFinalInfos;



@end

@implementation CookBook_BuyLotterySectionView

-(id)initWithFrame:(CGRect)frame
    buySectionInfo:(NSDictionary *)buySectionInfo
           betType:(CPBuyLotteryBetType)betType
          delegate:(id<CPBuyLotterySectionViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _isShowDetail = YES;
        self.backgroundColor = kCOLOR_R_G_B_A(243, 243, 243, 1);
        self.buySectionInfo = buySectionInfo;
        self.betType = betType;
        self.delegate = delegate;
        [self buildSection];
        
        if (self.betType == CPBuyLotteryBetForLHCHorizontalViewStyle) {
            [self buildLHCHorizontalViewStyleItems];
        }else{
            [self buildSubItem];
        }
        self.height = self.sectionHeight + self.contentHeight;
        
        if (self.betType == CPBuyLotteryBetForHeXiao) {
            self.heXiaoArray = [NSMutableArray new];
        }else if (self.betType == CPBuyLotteryBetForLianXiaoWei){
            self.lianXiaoWeiSelectedIndexs = [NSMutableArray new];
        }
    }
    return self;
}

#pragma mark- setter && getter

-(NSInteger)lianXiaoWeiMinSelectedCount{
    if (_lianXiaoWeiMinSelectedCount==0) {
        NSString *name = [self.buySectionInfo DWStringForKey:@"name"];
        if ([name rangeOfString:@"二"].length>0) {
            _lianXiaoWeiMinSelectedCount = 2;
            
        }else if ([name rangeOfString:@"三"].length>0) {
            _lianXiaoWeiMinSelectedCount = 3;
            
        }else if ([name rangeOfString:@"四"].length>0) {
            _lianXiaoWeiMinSelectedCount = 4;
            
        }else if ([name rangeOfString:@"五"].length>0) {
            _lianXiaoWeiMinSelectedCount = 5;
        }
    }
    return _lianXiaoWeiMinSelectedCount;
    
}

-(NSArray *)heXiaoPlayDetailList
{
    if (!_heXiaoPlayDetailList) {
        _heXiaoPlayDetailList = [self.delegate cookBook_heXiaoPlayDetailInfoList];
    }
    return _heXiaoPlayDetailList;
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

-(NSArray *)itemInfos
{
    if (!_itemInfos) {
        _itemInfos = [self.buySectionInfo DWArrayForKey:@"list"];
    }
    return _itemInfos;
}

-(CGFloat)sectionHeight
{
    return 40.0f;
}

-(NSInteger)lineCount
{
    if (self.betType == CPBuyLotteryBetForHeXiao) {
        return 3;
    }
    return  4;
}

-(NSInteger)rowCount
{
    if (self.itemInfos.count>0) {
        NSInteger row =self.itemInfos.count/self.lineCount;
        row = (self.itemInfos.count%self.lineCount)>0?row+1:row;
        return row;
    }
    return 0;
}

-(CGFloat)itemHeight
{
    if (self.betType == CPBuyLotteryBetFast) {
        if ([CookBook_BuyLotteryManager shareManager].currentBuyLotteryType == CPLotteryResultForK3) {
            if ([[CookBook_BuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"点数"]) {
                return 50;
            }
            return 50+15;
        }
        return 50.0f;
        
    }else if (self.betType == CPBuyLotteryBetForHeXiao) {
        return 65.0f;
        
    }else if (self.betType == CPBuyLotteryBetForLHCHorizontalViewStyle) {
        return 40.0f;
        
    }else{
        
        if ([CookBook_BuyLotteryManager shareManager].currentBuyLotteryType == CPLotteryResultForK3) {
            if ([[CookBook_BuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"点数"]) {
                return 60.0f;
            }
            return 60.0f+30.0;
        }
        return 60.0f;
    }
}

-(CGFloat)contentHeight
{
    if (_contentHeight<=0) {
        
        if (self.betType == CPBuyLotteryBetForLHCHorizontalViewStyle) {
            _contentHeight = (self.itemInfos.count+1) * self.itemHeight;
        }else{
            _contentHeight = self.itemHeight * self.rowCount;
        }
    }
    return _contentHeight;
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

    if (self.delegate && [self.delegate respondsToSelector:@selector(clickShowDetailBuyInfo)]) {
        [self.delegate clickShowDetailBuyInfo];
    }
    
}

#pragma mark-

-(void)buildSection
{
    CPVoiceButton *clickBtn = [CPVoiceButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(0, 0, self.width, self.sectionHeight);
    [clickBtn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clickBtn];
    
    _sectionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.width-20, self.sectionHeight)];
    _sectionLabel.textColor = kCOLOR_R_G_B_A(51, 51, 51, 1);
    _sectionLabel.textAlignment = NSTextAlignmentLeft;
    _sectionLabel.font = [UIFont systemFontOfSize:15.0f];
    _sectionLabel.text = [self.buySectionInfo DWStringForKey:@"name"];
    [self addSubview:_sectionLabel];
    
    UIImage *img = [UIImage imageNamed:@"arrow_up"];
    _arrowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_up"] highlightedImage:[UIImage imageNamed:@"arrow_down"]];
    _arrowImageView.frame = CGRectMake(self.width - img.size.width - 15.0f, (self.sectionHeight - img.size.height)/2.0f, img.size.width, img.size.height);
    _arrowImageView.highlighted = YES;
    [self addSubview:_arrowImageView];
    
}

-(void)buildSubItem
{
    NSInteger line = self.lineCount;
    NSInteger row = self.rowCount;
    if (row == 0) {
        return;
    }
    CGFloat itemWidth = self.width/line;
    CGFloat itemHeight = self.itemHeight;
    CGFloat originX = 0;
    CGFloat originY = 0;
    NSInteger infoIndex = 0;
    for (int r=0 ; r<row; r++) {
        originY = r * itemHeight;
        
        for (int l=0; l<line; l++) {
            
            originX = l*itemWidth;
            infoIndex = r*line + l;
            if (infoIndex>=self.itemInfos.count) {
                break;
            }

            
            NSDictionary *betNameDic = [self.delegate betNameDictionary]?[self.delegate betNameDictionary]:[NSDictionary new];
            
            NSMutableDictionary *info = [[NSMutableDictionary alloc]initWithDictionary:self.itemInfos[infoIndex]];
            
            [info DWSetObject:[betNameDic DWStringForKey:[NSNumber numberWithInteger:[[info objectForKey:@"playName"]integerValue] ]] forKey:@"playNameValue"];
            
            CGRect frame = CGRectMake(originX, originY, itemWidth, itemHeight);
            if (self.betType == CPBuyLotteryBetForHeXiao) {
            
                [CookBook_BuyLotteryFastItem cookBook_addBuyLotteryFastItemOnView:self.contentView withFrame:frame buyInfo:info detailLabelTextColor:kCOLOR_R_G_B_A(109, 109, 109,1) clickAction:^(CookBook_BuyLotteryFastItem *item, NSDictionary *buyInfo, BOOL isSelected) {
                    if (isSelected) {
                        /*
                         */
                        if (self.heXiaoArray.count>=11) {
                            CookBook_BuyLotteryFastItem *firstItem = [self.heXiaoArray objectAtIndex:0];
                            [firstItem cancelSelected];
                            [self.heXiaoArray removeObjectAtIndex:0];
                        }
                        [self.heXiaoArray addObject:item];
                        
                    }else{
                        if ([self.heXiaoArray containsObject:item]) {
                            [self.heXiaoArray removeObject:item];
                        }
                    }
                    [self reloadSectionTitle];
                    NSString *playId = @"";
                    if (_heXiaoPlayInfo) {
                        playId = [_heXiaoPlayInfo DWStringForKey:@"playId"];
                    }
                    [self.delegate cookBook_buyHeXiaoWithInfos:self.heXiaoArray value:[NSString stringWithFormat:@"%.2f",_heXiaoBonuds] playId:playId];
                
                }];
                
            }else if (self.betType == CPBuyLotteryBetFast) {
                
                [CookBook_BuyLotteryFastItem cookBook_addBuyLotteryFastItemOnView:self.contentView withFrame:frame buyInfo:info clickAction:^(NSDictionary *buyInfo, BOOL isSelected) {
                    [self.delegate cookBook_buyLotteryBetFastBuyInfo:buyInfo sectionName:[self.buySectionInfo DWStringForKey:@"name"] isBuy:isSelected];
                }];
                
            }else if (self.betType ==CPBuyLotteryBetForLianXiaoWei) {
                
                [CookBook_BuyLotteryFastItem cookBook_addBuyLotteryFastItemOnView:self.contentView withFrame:frame buyInfo:info infoIndex:infoIndex clickAction:^(NSString *infoIndex, BOOL isSelected) {
                    
                    //连肖连尾
                    if (isSelected) {
                        [self.lianXiaoWeiSelectedIndexs addObject:infoIndex];
                    }else{
                        if ([self.lianXiaoWeiSelectedIndexs containsObject:infoIndex]) {
                            [self.lianXiaoWeiSelectedIndexs removeObject:infoIndex];
                        }
                    }
                }];
                
            }else{
                
                [CookBook_BuyLotteryCustomItem cookBook_addBuyLotteryCustomItemOnView:self.contentView withFrame:frame buyInfo:info clickAction:^(NSDictionary *buyInfo, NSString *value) {
                    [self.delegate cookBook_buyLotteryBetCustomBuyInfo:buyInfo sectionName:[self.buySectionInfo DWStringForKey:@"name"] value:value];
                }];
                
            }
        }
    }
    
}

-(void)buildLHCHorizontalViewStyleItems
{
    CGFloat itemHeight = self.itemHeight;
    NSMutableArray *infos = [[NSMutableArray alloc]initWithArray:self.itemInfos];
    [infos insertObject:[NSMutableDictionary new] atIndex:0];
    CGFloat originY = 0;
    
    for (int i = 0; i<infos.count; i++) {
        
        NSDictionary *betNameDic = [self.delegate betNameDictionary]?[self.delegate betNameDictionary]:[NSDictionary new];
        
        NSMutableDictionary *info = [[NSMutableDictionary alloc]initWithDictionary:infos[i]];
        [info DWSetObject:[betNameDic DWStringForKey:[NSNumber numberWithInteger:[[info objectForKey:@"playName"]integerValue] ]] forKey:@"playNameValue"];
        
        CGRect frame = CGRectMake(0, originY, self.contentView.width, itemHeight);
        [CookBook_BuyLotteryCustomItem cookBook_addHorizontalBuyLotteryCustomItemOnView:self.contentView withFrame:frame buyInfo:info clickAction:^(NSDictionary *buyInfo, NSString *value) {
            [self.delegate cookBook_buyLotteryBetCustomBuyInfo:buyInfo sectionName:[self.buySectionInfo DWStringForKey:@"name"] value:value];
        }];
        originY = originY + itemHeight;
    }
    
    self.contentView.height = infos.count * itemHeight;
}

#pragma mark- reload

-(void)reloadSectionTitle
{
    NSInteger heXiaoCount = self.heXiaoArray.count;
    NSString *name = [self.buySectionInfo DWStringForKey:@"name"];

    if (heXiaoCount>=2 && self.heXiaoPlayDetailList.count>(heXiaoCount-2)) {
//        heXiaoCount
        heXiaoCount = heXiaoCount -2;
        _heXiaoPlayInfo = [self.heXiaoPlayDetailList objectAtIndex:heXiaoCount];
        _heXiaoBonuds = [[_heXiaoPlayInfo DWStringForKey:@"bonus"]floatValue];
        _sectionLabel.text = [NSString stringWithFormat:@"%@ %.2f",name,_heXiaoBonuds];

    }else{
        _heXiaoBonuds = 0;
        _sectionLabel.text = [NSString stringWithFormat:@"%@",name];
    }
    
}

#pragma mark- action

-(void)clickAction
{
    self.isShowDetail = self.isShowDetail?NO:YES;
    
}

#pragma mark- 连肖连尾

-(BOOL)isSelectedLianXiaoWeiLotterys
{
    return self.lianXiaoWeiSelectedIndexs.count>0?YES:NO;
}

-(BOOL)isVerifySelectedLianXiaoWeiLotterys
{
    BOOL verify = NO;
    
    NSInteger selectedCounts = self.lianXiaoWeiSelectedIndexs.count;
    if (selectedCounts>0) {
        if (selectedCounts>=self.lianXiaoWeiMinSelectedCount ) {
            verify = YES;
        }
    }
    return verify;
}

-(NSArray *)cookBook_betValuesInfo
{
    self.lianXiaoWeiSelectedFinalInfos = [NSMutableArray new];
    
    NSArray *result = [self.lianXiaoWeiSelectedIndexs sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger intObj1 = [obj1 integerValue];
        NSInteger intObj2 = [obj2 integerValue];
        return intObj1 >intObj2; //升序
    }];
    self.lianXiaoWeiSelectedIndexs = [[NSMutableArray alloc]initWithArray:result];
    
    [self combine:(int)self.lianXiaoWeiSelectedIndexs.count index:(int)self.lianXiaoWeiMinSelectedCount temp:@""];
    return self.lianXiaoWeiSelectedFinalInfos;
}

- (void)combine:(int)n index:(int)k temp:(NSString *)str
{
    for(int i = n; i >= k; i--)
    {
        if(k > 1)
        {
            
            [self combine:i-1 index:k-1 temp:[NSString stringWithFormat:@"%@%@&",str,self.lianXiaoWeiSelectedIndexs[self.lianXiaoWeiSelectedIndexs.count-i]]];
        }
        else
        {
            NSString *values = [NSString stringWithFormat:@"%@%@",str,self.lianXiaoWeiSelectedIndexs[self.lianXiaoWeiSelectedIndexs.count-i]];
            NSMutableDictionary *mInfo = [NSMutableDictionary new];
            NSMutableString *mPlayName = [[NSMutableString alloc]initWithFormat:@"%@:",[self.buySectionInfo DWStringForKey:@"name"]];
            NSMutableString *mPlayNameValue = [[NSMutableString alloc]init];
            NSMutableString *mPlayId = [[NSMutableString alloc]init];

            NSArray *indexs = [values componentsSeparatedByString:@"&"];
            CGFloat minBonus = MAXFLOAT;
            for (int i = 0; i<indexs.count; i++) {
                NSInteger index = [indexs[i] integerValue];
                NSDictionary *info = self.itemInfos[index];
                CGFloat bonus = [[info DWStringForKey:@"bonus"]floatValue];
                if (minBonus>bonus) {
                    minBonus = bonus;
                    mPlayId = [NSMutableString stringWithString:[info DWStringForKey:@"playId"]];
                }
                minBonus = minBonus>bonus?bonus:minBonus;
                
                NSString *playName = [info DWStringForKey:@"playName"];
                [mPlayName appendFormat:@"%@&",playName];
                [mPlayNameValue appendFormat:@"%@&",playName];


            }

            [mInfo setObject:[mPlayNameValue substringToIndex:mPlayNameValue.length-1] forKey:@"playNameValue"];
            [mInfo setObject:[mPlayName substringToIndex:mPlayName.length-1] forKey:@"playName"];
            [mInfo setObject:mPlayId forKey:@"playId"];
            [mInfo setObject:[NSString stringWithFormat:@"%.2f",minBonus] forKey:@"bonus"];
            
            [self.lianXiaoWeiSelectedFinalInfos addObject:mInfo];
            
        }
    }
}


@end
