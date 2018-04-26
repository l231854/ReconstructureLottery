//
//  CPBuyCustomLotteryConfirmView.m
//  lottery
//
//  Created by wayne on 2017/9/19.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_BuyCustomLotteryConfirmView.h"

@interface CookBook_BuyCustomLotteryConfirmView ()
{
    IBOutlet UIView *_contentView;
    IBOutlet UIScrollView *_scrollView;
    
    IBOutlet UILabel *_titleLabel;
    IBOutlet UILabel *_contentLabel;
}

@property(nonatomic,copy)CPBuyCustomLotteryConfirmAction confirm;

@end

@implementation CookBook_BuyCustomLotteryConfirmView

+(void)cookBook_showCustomLotteryConfirmViewOnView:(UIView *)supView
                               lotterys:(NSArray *)lotterys
                          numberPeriods:(NSString *)numberPeriods
                                comfirm:(CPBuyCustomLotteryConfirmAction)confirm
{
    CookBook_BuyCustomLotteryConfirmView *view = [CookBook_BuyCustomLotteryConfirmView createViewFromNib];
    [view showOnView:supView lotterys:lotterys                           numberPeriods:numberPeriods comfirm:confirm];
}

#pragma mark- buttonAction


- (IBAction)buttonAction:(UIButton *)sender {
    
    if (self.confirm) {
        BOOL isConfirm = (sender.tag == 11)?NO:YES;
        self.confirm(isConfirm);
    }
    [self dismiss];
}

-(void)showOnView:(UIView *)onView
         lotterys:(NSArray *)lotterys
    numberPeriods:(NSString *)numberPeriods
          comfirm:(CPBuyCustomLotteryConfirmAction)confirm
{
    
    self.frame = CGRectMake(0, 0, onView.width, onView.height);
    [self layoutSubviews];
    
    NSString *title = [NSString stringWithFormat:@"请确认当前第%@期",numberPeriods];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [att addAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]} range:[title rangeOfString:numberPeriods]];
    _titleLabel.attributedText = att;
 
    NSInteger count = lotterys.count;
    CGFloat allPay = 0;
    CGFloat award = 0;
    CGFloat win = 0;
    for (NSDictionary *info in lotterys) {
        CGFloat betValue = [[info DWStringForKey:@"betValue"]doubleValue];
        NSInteger bouns = [[NSString stringWithFormat:@"%ld",(long)([[info DWStringForKey:@"bonus"]floatValue]*100)]integerValue];
        allPay += betValue;
        CGFloat awardValue = betValue *bouns;
        award = award+awardValue/100.0f;
        win = award - allPay;
    }
    
    NSString *countString = [NSString stringWithFormat:@"%ld",(long)count];
    NSString *allPayString = [NSString stringWithFormat:@"%.2f",allPay];
    NSString *awardString = [NSString stringWithFormat:@"%.2f",award];
    NSString *winString = [NSString stringWithFormat:@"%.2f",win];
    
    NSString *contentString = [NSString stringWithFormat:@"%@注共%@元，若中奖，奖金%@元，盈利%@元",countString,allPayString,awardString,winString];
    NSMutableAttributedString * attContent = [[NSMutableAttributedString alloc]initWithString:contentString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor blackColor]}];
    [attContent addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[contentString rangeOfString:allPayString]];
    [attContent addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[contentString rangeOfString:awardString]];
    [attContent addAttributes:@{NSForegroundColorAttributeName:kMainColor} range:[contentString rangeOfString:winString]];
    _contentLabel.attributedText = attContent;
    
    int line = 4;
    
    CGFloat gap = 3;
    CGFloat originX = 0;
    CGFloat originY = 0;
    CGFloat height = 40.0f;
    CGFloat width = (_scrollView.width - (2+line)*gap)/line;
    
    NSInteger row = lotterys.count/line;
    row = lotterys.count%line>0?row+1:row;
    
    CGFloat contentHeight = 0;
    for (int r = 0; r<row; r++) {
        originY = gap+(gap+height)*r;
        for (int l = 0; l<line; l++) {
            originX = gap+(gap+width)*l;
            NSInteger index = r*line + l;
            if (index>=lotterys.count) {
                break;
            }
            NSDictionary *info = [lotterys objectAtIndex:index];
            NSString *sectionName = [info DWStringForKey:@"sectionName"];
            NSString *haoString = [CookBook_User shareUser].buyLotteryDetailHasNumberPan?@"号":@"";
            NSString *title = [NSString stringWithFormat:@"%@%@%@",sectionName,[info DWStringForKey:@"playName"],haoString];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(originX, originY,width,height)];
            label.text = title;
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = kCOLOR_R_G_B_A(252, 14, 28, 1);
            [_scrollView addSubview:label];
            contentHeight = label.bottomY;
        }
    }
    
    CGFloat othersHeight = 115;
    CGFloat scrollHeight = (contentHeight+othersHeight>=self.height/2.0f)?(self.height/2.0f-othersHeight):contentHeight;
    
    _contentView.height = othersHeight+scrollHeight;
    [_contentView layoutSubviews];
    
    _contentView.centerY = (self.height-_contentView.height)/2.0f+_contentView.height/2.0f;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.width,contentHeight);
    
    
    self.confirm = confirm;
    [self showOnView:onView];
}



#pragma mark-

-(void)showOnView:(UIView *)onView
{
    self.layer.opacity = 0;
    [onView addSubview:self];
    [UIView animateWithDuration:0.38 animations:^{
        self.layer.opacity = 1;
    }];
    
}

-(void)dismiss
{
    [UIView animateWithDuration:0.38 animations:^{
        self.layer.opacity = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



@end
