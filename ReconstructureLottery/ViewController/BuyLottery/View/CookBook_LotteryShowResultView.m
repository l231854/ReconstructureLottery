//
//  CPLotteryShowResultView.m
//  lottery
//
//  Created by 施小伟 on 2017/11/18.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_LotteryShowResultView.h"
#import "CPBackgroundCornerLabel.h"

#define kPK10ResultColor \
@[\
kCOLOR_R_G_B_A(0, 0, 0, 1),\
kCOLOR_R_G_B_A(255, 179, 5, 1),\
kCOLOR_R_G_B_A(57, 138, 247, 1),\
kCOLOR_R_G_B_A(77, 77, 77, 1),\
kCOLOR_R_G_B_A(238, 122, 48, 1),\
kCOLOR_R_G_B_A(161, 252, 254, 1),\
kCOLOR_R_G_B_A(73, 37, 245, 1),\
kCOLOR_R_G_B_A(184, 184, 184, 1),\
kCOLOR_R_G_B_A(234, 50, 35, 1),\
kCOLOR_R_G_B_A(108, 18, 10, 1),\
kCOLOR_R_G_B_A(95, 190, 56, 1),\
]

//itme的大小
#define kItemWidth               24.0f

//垂直边界间距（上、下间距）
#define kBorderVerticalGap       6.0f

//水平边界间距（左、右间距）
#define kBorderHorizontalGap     3.0f

//item之间的间距
#define kItemGap                 2.0f



@interface CookBook_LotteryShowResultView()
{
    
}

@property(nonatomic,retain)UIView *contentView;
@property(nonatomic,retain)NSMutableDictionary *markListViewHeightDictionary;
@property(nonatomic,retain)NSMutableDictionary *markDetailViewHeightDictionary;


@end

@implementation CookBook_LotteryShowResultView

static CookBook_LotteryShowResultView *_instance;

+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [CookBook_LotteryShowResultView new];
        _instance.markListViewHeightDictionary = [NSMutableDictionary new];
        _instance.markDetailViewHeightDictionary = [NSMutableDictionary new];

    });
    return _instance;
}

+(CGFloat)resultViewHeightByResult:(NSArray *)result
                        resultType:(CPLotteryResultType)resultType
                  isWaitOpenResult:(BOOL)isWaitOpen
                          maxWidth:(CGFloat)maxWidth
                            isList:(BOOL)isList
{
    CGFloat height = 0;
    if (isWaitOpen) {
        return 35.0f;
    }
    switch (resultType) {
        case CPLotteryResultForXGLHC:
        case CPLotteryResultForPK10:
        case CPLotteryResultForPCDD:
        case CPLotteryResultForK3:
        {
            return height = kBorderVerticalGap *2 + kItemWidth;
        }break;
            
        default:{
            
            if (result.count == 10) {
                NSLog(@"..");
            }
            
            NSMutableDictionary *markHeightDictionary = isList? [CookBook_LotteryShowResultView shareInstance].markListViewHeightDictionary : [CookBook_LotteryShowResultView shareInstance].markDetailViewHeightDictionary;
            
            NSString *markHeight =  [markHeightDictionary objectForKey:@(result.count)];
            if (markHeight) {
                height = [markHeight floatValue];
            }else{
                
                CGFloat orginX = kBorderHorizontalGap;
                height = kBorderVerticalGap *2 + kItemWidth;
                for (int i = 0; i<result.count; i++) {
                    orginX = orginX + kItemWidth+kBorderHorizontalGap+kItemGap;
                    if (orginX>maxWidth && (i+1)<result.count) {
                        orginX = kBorderHorizontalGap;
                        height = height + kItemGap + kItemWidth;
                    }
                }
                [markHeightDictionary setObject:[NSString stringWithFormat:@"%f",height] forKey:@(result.count)];
            }
        }break;
    }

    return height;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self addSubview:self.contentView];

}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

-(void)showResult:(NSArray *)result
       resultType:(CPLotteryResultType)resultType
       isWaitOpen:(BOOL)isWaitOpen;
{
    [self.contentView removeAllSubviews];

    if (isWaitOpen) {
        [self addWaitOpenView];
        
    }else{
        switch (resultType) {
            case CPLotteryResultForXGLHC:
            {
                [self addLHCResultView:result];
            }break;
            case CPLotteryResultForPK10:
            {
                [self addPK10ResultView:result];
                
            }break;
            case CPLotteryResultForPCDD:
            {
                [self addPCDDResultView:result];
            }break;
            case CPLotteryResultForK3:
            {
                [self addK3ResultView:result];
            }break;
                
            default:[self addNormalResultView:result];
                break;
        }
    }
}

#pragma mark- setter && getter

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
    }
    _contentView.frame = CGRectMake(0, 0, self.width, self.height);
    return _contentView;
}

#pragma mark- addResultView

-(void)addNormalResultView:(NSArray *)result
{
    CGFloat itemWidth = kItemWidth;
    CGFloat originX = kBorderHorizontalGap;
    CGFloat originY = kBorderVerticalGap;
    CGFloat maxWidth = self.contentView.width;
    for (int i = 0; i<result.count; i++) {
        NSString *text = result[i];
        UIColor *backgroundColor = kCOLOR_R_G_B_A(185, 48, 40, 1);
        if (originX+kItemWidth+kBorderHorizontalGap+kItemGap>maxWidth) {
            originX = kBorderHorizontalGap;
            originY = originY + kItemGap + kItemWidth;
        }
        CPBackgroundCornerLabel *label = [[CPBackgroundCornerLabel alloc]initWithFrame:CGRectMake(originX, originY, itemWidth, itemWidth) backgroundColor:backgroundColor cornerRadius:itemWidth/2.0f textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:16.0f] text:text];
        [self.contentView addSubview:label];
        originX = label.rightX + kItemGap;
    }

}

-(void)addK3ResultView:(NSArray *)result
{
    CGFloat itemWidth = kItemWidth;
    CGFloat originX = kBorderHorizontalGap;
    CGFloat originY = kBorderVerticalGap;
    for (int i = 0; i<result.count; i++) {
        NSString *text = result[i];
        UIImage *image = [self k3BackgroundImageByNumber:text];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(originX, originY, itemWidth, itemWidth)];
        imageView.image = image;
        [self.contentView addSubview:imageView];
        originX = imageView.rightX + kItemGap;
    }
}

-(void)addPCDDResultView:(NSArray *)result
{
    NSMutableArray *mResult = [[NSMutableArray alloc]initWithArray:result];
    if (mResult.count== 4) {
        [mResult insertObject:@"=" atIndex:3];
        [mResult insertObject:@"+" atIndex:2];
        [mResult insertObject:@"+" atIndex:1];

        CGFloat itemWidth = kItemWidth;
        CGFloat originX = kBorderHorizontalGap;
        CGFloat originY = kBorderVerticalGap;
        result = mResult;
        for (int i = 0; i<result.count; i++) {
            NSString *text = result[i];
            if ([text isEqualToString:@"+"]||[text isEqualToString:@"="]) {
                UILabel *label = [self specialNumberWithFrmae:CGRectMake(originX, originY, 15, itemWidth) text:text];
                [self.contentView addSubview:label];
                originX = label.rightX + kItemGap;
                
            }else{
                
                UIColor *backgroundColor = (i+1==result.count)?[self lhcBackgroundColorByNumer:text]:kCOLOR_R_G_B_A(185, 48, 40, 1);
                CPBackgroundCornerLabel *label = [[CPBackgroundCornerLabel alloc]initWithFrame:CGRectMake(originX, originY, itemWidth, itemWidth) backgroundColor:backgroundColor cornerRadius:itemWidth/2.0f textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:16.0f] text:text];
                [self.contentView addSubview:label];
                originX = label.rightX + kItemGap;
            }
            
        }
    }
}

-(void)addLHCResultView:(NSArray *)result
{
    NSMutableArray *mResult = [[NSMutableArray alloc]initWithArray:result];
    if (mResult.count== 7) {
        [mResult insertObject:@"+" atIndex:6];
        
        CGFloat itemWidth = kItemWidth;
        CGFloat originX = kBorderHorizontalGap;
        CGFloat originY = kBorderVerticalGap;
        result = mResult;
        for (int i = 0; i<result.count; i++) {
            NSString *text = result[i];
            if ([text isEqualToString:@"+"]) {
                UILabel *label = [self specialNumberWithFrmae:CGRectMake(originX, originY, 15, itemWidth) text:text];
                [self.contentView addSubview:label];
                originX = label.rightX + kItemGap;
                
            }else{
                
                UIColor *backgroundColor = [self lhcBackgroundColorByNumer:text];
                CPBackgroundCornerLabel *label = [[CPBackgroundCornerLabel alloc]initWithFrame:CGRectMake(originX, originY, itemWidth, itemWidth) backgroundColor:backgroundColor cornerRadius:itemWidth/2.0f textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:16.0f] text:text];
                [self.contentView addSubview:label];
                originX = label.rightX + kItemGap;
            }
            
        }
    }
}

-(void)addPK10ResultView:(NSArray *)result
{
    CGFloat itemWidth = 21.0f;
    CGFloat originX = kBorderHorizontalGap;
    CGFloat originY = (self.contentView.height-itemWidth)/2.0f;

    for (int i = 0; i<result.count; i++) {
        NSString *text = result[i];
        NSInteger colorIndex = [text integerValue];
        
        UIColor *backgroundColor = (kPK10ResultColor.count>colorIndex)? kPK10ResultColor[[text intValue]]:kCOLOR_R_G_B_A(185, 48, 40, 1);
        CPBackgroundCornerLabel *label = [[CPBackgroundCornerLabel alloc]initWithFrame:CGRectMake(originX, originY, itemWidth, itemWidth) backgroundColor:backgroundColor cornerRadius:3.0f textColor:[UIColor whiteColor] textFont:[UIFont systemFontOfSize:16.0f] text:text];
        [self.contentView addSubview:label];
        originX = label.rightX + kItemGap;
    }
}

-(void)addWaitOpenView
{
    UIImage *img = [UIImage imageNamed:@"clock_wait"];
    CGSize imgSize = img?img.size:CGSizeMake(0, 0);
    UIImageView *imgView = [[UIImageView alloc]initWithImage:img];
    imgView.frame = CGRectMake(5, (self.contentView.height-img.size.height)/2.0f, imgSize.width, imgSize.height);
    [self.contentView addSubview:imgView];
    
    UILabel *waitLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgView.rightX+5, 0, self.contentView.width-imgView.rightX-10, self.contentView.height)];
    waitLabel.textAlignment = NSTextAlignmentLeft;
    waitLabel.textColor = [UIColor redColor];
    waitLabel.font = [UIFont systemFontOfSize:15.0f];
    waitLabel.text = @"等待开奖";
    [self.contentView addSubview:waitLabel];
}

-(UILabel *)specialNumberWithFrmae:(CGRect)frame
                              text:(NSString *)text
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = kCOLOR_R_G_B_A(153, 153, 153, 1);
    label.font = [UIFont systemFontOfSize:14.0f];
    label.text = text;
    return label;
}


#pragma mark-

-(UIColor *)lhcBackgroundColorByNumer:(NSString *)number
{
    UIColor *color;
    
    NSArray *redPoArray = @[@"1",@"2",@"7",@"8",@"12",@"13",@"18",@"19",@"23",@"24",@"29",@"30",@"34",@"35",@"40",@"45",@"46",@"01",@"02",@"07",@"08"];
    NSArray *bluePoArray = @[@"3",@"4",@"9",@"10",@"14",@"15",@"20",@"25",@"26",@"31",@"36",@"37",@"41",@"42",@"47",@"48",@"03",@"04",@"09"];

    if ([redPoArray containsObject:number]) {
        color = kCOLOR_R_G_B_A(199, 41, 28, 1);
    }else if ([bluePoArray containsObject:number]){
        color = kCOLOR_R_G_B_A(81, 143, 176, 1);
    }else{
        color = kCOLOR_R_G_B_A(102, 177, 76, 1);
    }
    
    return color;
}

-(UIColor *)pcddBackgroundColorByNumber:(NSString *)number
{
    UIColor *color;
    
    NSArray *grayArray = @[@"00",@"0",@"13",@"14",@"27"];
    NSArray *greenArray = @[@"1",@"4",@"7",@"10",@"16",@"19",@"22",@"25",@"01",@"04",@"07"];
    NSArray *blueArray = @[@"2",@"5",@"8",@"11",@"17",@"20",@"23",@"26",@"02",@"05",@"08"];
    if ([grayArray containsObject:number]) {
        color = kCOLOR_R_G_B_A(153, 153, 153, 1);
    }else if ([greenArray containsObject:number]) {
        color = kCOLOR_R_G_B_A(76, 157, 54, 1);
    }else if ([blueArray containsObject:number]) {
        color = kCOLOR_R_G_B_A(62, 117, 214, 1);
    }else{
        color = kCOLOR_R_G_B_A(222, 68, 60, 1);
    }
    
    return color;
}

-(UIImage *)k3BackgroundImageByNumber:(NSString *)number
{
    int index = [number intValue]-1;
    NSArray *images = @[@"touzi_01_k3",@"touzi_02_k3",@"touzi_03_k3",@"touzi_04_k3",@"touzi_05_k3",@"touzi_06_k3",];
    UIImage *img = [UIImage imageNamed:images[index]];
    return img;
}

@end
