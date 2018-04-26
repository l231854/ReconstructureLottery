//
//  CPBuyLotteryCustomItem.m
//  lottery
//
//  Created by wayne on 2017/9/16.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_BuyLotteryCustomItem.h"

@interface CookBook_BuyLotteryCustomItem ()<UITextFieldDelegate>

@property(nonatomic,strong)UILabel *titleLabel;


@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)NSDictionary *buyInfo;
@property(nonatomic,copy)CPBuyLotteryCustomItemFinishedAction action;


@end

@implementation CookBook_BuyLotteryCustomItem


-(instancetype)initWithFrame:(CGRect)frame
                     buyInfo:(NSDictionary *)buyInfo
                 clickAction:(CPBuyLotteryCustomItemFinishedAction)action
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.buyInfo = buyInfo;
        self.action = action;

        NSString *bounus = [NSString stringWithFormat:@"%.2f",[[self.buyInfo DWStringForKey:@"bonus"] floatValue]];
        NSString *haoString = [CookBook_User shareUser].buyLotteryDetailHasNumberPan?@"号":@"";
        haoString = ([CookBook_BuyLotteryManager shareManager].currentBuyLotteryType == CPLotteryResultForK3 && [[CookBook_BuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"点数"])?@"点":@"";
        NSString *title = [NSString stringWithFormat:@"%@%@ %@",[self.buyInfo DWStringForKey:@"playName"],haoString,bounus];
        NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:kCOLOR_R_G_B_A(51, 51, 51, 1)}];
        [att addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[title rangeOfString:bounus]];
        self.titleLabel.attributedText = att;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.textField];
        
        if ([CookBook_BuyLotteryManager shareManager].currentBuyLotteryType == CPLotteryResultForK3) {
            if (![[CookBook_BuyLotteryManager shareManager].currentPlayKindDes isEqualToString:@"点数"])
            {

                CGFloat originHeight = (self.height-30.0f)/2.0f;
                self.textField.frame = CGRectMake(self.textField.originX, self.height-originHeight-5, self.textField.width, originHeight-5);

                NSString *playName = [self.buyInfo DWStringForKey:@"playName"];
                if ([playName isPureInt]) {
                    self.titleLabel.frame = CGRectMake(self.titleLabel.originX, 30.0f, self.titleLabel.width, originHeight);

                    self.titleLabel.attributedText = nil;
                    self.titleLabel.textColor = kMainColor;
                    self.titleLabel.text = bounus;
                    
                    NSInteger playNameCount = playName.length;
                    CGFloat itemWidth = 23.0f;
                    CGFloat gap = 1.0f;
                    CGFloat originX = (self.width - playNameCount*itemWidth - (playNameCount-1)*gap)/2.0f;
                    CGFloat originY = 11;

                    for (NSInteger i = 0; i<playNameCount; i++) {
                        NSString *number = [playName substringWithRange:NSMakeRange(i, 1)];
                        
                        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(originX, originY, itemWidth, itemWidth)];
                        imgView.image = [CookBook_BuyLotteryManager k3BackgroundImageByNumber:number];
                        [self addSubview:imgView];
                        originX = originX + gap + itemWidth;
                    }
                    
                }else{
                    
                    self.titleLabel.frame = CGRectMake(self.titleLabel.originX, 20.0f, self.titleLabel.width, originHeight);

                    NSMutableAttributedString *newAtt = [[NSMutableAttributedString alloc]initWithAttributedString:_titleLabel.attributedText];
                    [newAtt addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} range:NSMakeRange(0,self.titleLabel.attributedText.length)];
                    self.titleLabel.attributedText = newAtt;
            

                }
                
                
            }
        }
        
    }
    return self;
}



+(void)cookBook_addBuyLotteryCustomItemOnView:(UIView *)supView
                           withFrame:(CGRect)frame
                             buyInfo:(NSDictionary *)buyInfo
                         clickAction:(CPBuyLotteryCustomItemFinishedAction)acion
{
    CookBook_BuyLotteryCustomItem *item = [[CookBook_BuyLotteryCustomItem alloc]initWithFrame:frame buyInfo:buyInfo clickAction:acion];
    [supView addSubview:item];
}

#pragma mark-

-(instancetype)initWithHorizontalFrame:(CGRect)frame
                               buyInfo:(NSDictionary *)buyInfo
                           clickAction:(CPBuyLotteryCustomItemFinishedAction)action
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kCOLOR_R_G_B_A(246, 246, 246, 1);
        self.buyInfo = buyInfo;
        self.action = action;
        
        CGFloat leftViewWidth = 120.0f;
        CGFloat numberBgViewWidth = self.height-4.0f;
        
        UIView *numberBgView = [[UIView alloc]initWithFrame:CGRectMake((leftViewWidth-numberBgViewWidth)/2.0f, (self.height - numberBgViewWidth)/2.0f, numberBgViewWidth, numberBgViewWidth)];
        numberBgView.layer.cornerRadius = numberBgView.width/2.0f;
        [self addSubview:numberBgView];
        
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, leftViewWidth, self.height)];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.font = [UIFont systemFontOfSize:16.0f];
        numberLabel.text = [self.buyInfo DWStringForKey:@"playName"];
        [self addSubview:numberLabel];
        numberBgView.backgroundColor = [self lhcBackgroundColorByNumer:numberLabel.text];
        if ([numberLabel.text intValue]<=0) {
            CGFloat width = numberLabel.text.length *18;
            width = width>=leftViewWidth?leftViewWidth:width;
            numberBgView.frame = CGRectMake((leftViewWidth-width)/2.0f, (self.height - numberBgViewWidth)/2.0f, width, numberBgViewWidth);
        }
        
        CGFloat bounusLabelWidth = 80.0f;
        UILabel *bounusLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftViewWidth, 0, bounusLabelWidth, self.height)];
        bounusLabel.textAlignment = NSTextAlignmentCenter;
        bounusLabel.textColor = kCOLOR_R_G_B_A(109, 109, 109, 1);
        bounusLabel.text = [self.buyInfo DWStringForKey:@"bonus"];
        bounusLabel.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:bounusLabel];
        
        CGFloat otherWidth = self.width - leftViewWidth - bounusLabelWidth;
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(self.width-otherWidth+10, 2, otherWidth-20, self.height-4)];
        _textField.delegate = self;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:15.0f];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.textColor = kMainColor;
        _textField.layer.borderColor = kGlobalLineColor.CGColor;
        _textField.layer.borderWidth = kGlobalLineWidth;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_textField];
        
        if (self.buyInfo.allKeys.count <= 1) {
            //号码、赔率、金额
            numberLabel.textColor = [UIColor darkGrayColor];
            numberLabel.text = @"号码";
            numberBgView.hidden = YES;
            
            bounusLabel.textColor = [UIColor darkGrayColor];
            bounusLabel.text = @"赔率";
            
            UILabel *amountLabel = [[UILabel alloc]initWithFrame:_textField.frame];
            amountLabel.textColor = [UIColor darkGrayColor];
            amountLabel.text = @"金额";
            amountLabel.font = numberLabel.font;
            amountLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:amountLabel];
            
            _textField.hidden = YES;
        }
        
        UILabel *bottomLine = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height-0.5f, self.width, 0.5f)];
        bottomLine.backgroundColor = kCOLOR_R_G_B_A(221, 221, 221, 1);
        [self addSubview:bottomLine];
        
        UILabel *leftLine = [[UILabel alloc]initWithFrame:CGRectMake(leftViewWidth, 0, 0.5, self.height)];
        leftLine.backgroundColor = kCOLOR_R_G_B_A(221, 221, 221, 1);
        [self addSubview:leftLine];
        
        UILabel *rightLine = [[UILabel alloc]initWithFrame:CGRectMake(leftViewWidth+bounusLabelWidth, 0, 0.5, self.height)];
        rightLine.backgroundColor = kCOLOR_R_G_B_A(221, 221, 221, 1);
        [self addSubview:rightLine];

    }
    return self;
}

+(void)cookBook_addHorizontalBuyLotteryCustomItemOnView:(UIView *)supView
                                     withFrame:(CGRect)frame
                                       buyInfo:(NSDictionary *)buyInfo
                                   clickAction:(CPBuyLotteryCustomItemFinishedAction)acion
{
    CookBook_BuyLotteryCustomItem *item = [[CookBook_BuyLotteryCustomItem alloc]initWithHorizontalFrame:frame buyInfo:buyInfo clickAction:acion];
    [supView addSubview:item];
}

#pragma mark- setter & getter

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height*0.4)];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _titleLabel;
}


-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(self.width*0.15, self.height*0.4, self.width*0.7, self.height*0.5)];
        _textField.delegate = self;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = [UIFont systemFontOfSize:11.0f];
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.textColor = kMainColor;
        _textField.layer.borderColor = kGlobalLineColor.CGColor;
        _textField.layer.borderWidth = kGlobalLineWidth;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _textField;
}

#pragma mark-

-(UIColor *)lhcBackgroundColorByNumer:(NSString *)number
{
    UIColor *color;
    
    NSArray *redPoArray = @[@"1",@"2",@"7",@"8",@"12",@"13",@"18",@"19",@"23",@"24",@"29",@"30",@"34",@"35",@"40",@"45",@"46",@"01",@"02",@"07",@"08"];
    NSArray *bluePoArray = @[@"3",@"4",@"9",@"10",@"14",@"15",@"20",@"25",@"26",@"31",@"36",@"37",@"41",@"42",@"47",@"48",@"03",@"04",@"09"];
    NSArray *greenPoArray = @[@"5",@"6",@"11",@"16",@"17",@"21",@"22",@"27",@"28",@"32",@"33",@"38",@"39",@"43",@"44",@"49",@"05",@"06"];

    
    if ([redPoArray containsObject:number]|| [number rangeOfString:@"红"].length>0) {
        color = kCOLOR_R_G_B_A(199, 41, 28, 1);
    }else if ([bluePoArray containsObject:number] || [number rangeOfString:@"蓝"].length>0){
        color = kCOLOR_R_G_B_A(81, 143, 176, 1);
    }else if ([greenPoArray containsObject:number] || [number rangeOfString:@"绿"].length>0){
        color = kCOLOR_R_G_B_A(102, 177, 76, 1);
    }else{
        color = [UIColor lightGrayColor];
    }
    
    return color;
}

#pragma mark- textfield

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *value = textField.text;
    if (self.action) {
        self.action(self.buyInfo,value);
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length>0) {
        
        if ((textField.text.length<1||[textField.text rangeOfString:@"."].length>0 )&& [string isEqualToString:@"."]) {
            
            return NO;
        }else if ([textField.text rangeOfString:@"."].length>0&&textField.text.length==[textField.text rangeOfString:@"."].location +3)
        {
            return NO;
        }else if ([textField.text isEqualToString:@"0"]&&![string isEqualToString:@"."])
        {
            return NO;
        }
        
    }
    /*
    if (textField.text.length == 0 && [string intValue]==0) {
        return NO;
    }
    if (string.length>0 && ![self validateNumber:string]) {
        return NO;
    }
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self verifyBetAmount];
    });
    
    return YES;
}

-(void)verifyBetAmount
{
    NSRange rangePoin = [_textField.text rangeOfString:@"."];
    if (rangePoin.length>0) {
        if (_textField.text.length>(rangePoin.location+rangePoin.length+2)) {
            _textField.text = [_textField.text substringToIndex:rangePoin.location+rangePoin.length+2];
        }
    }
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}
@end
