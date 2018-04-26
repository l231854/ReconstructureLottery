//
//  CPCPSignRecordCell.m
//  lottery
//
//  Created by wayne on 2017/8/26.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPBetRecordCell.h"

@interface CPBetRecordCell ()
{
    IBOutlet UILabel *_topLeftLabel;
    IBOutlet UILabel *_topRightLabel;
    IBOutlet UILabel *_centerLeftLabel;
    IBOutlet UILabel *_centerRightLabel;
    
    IBOutlet UILabel *_bottomLeftLabel;
    IBOutlet UILabel *_bottomRightLabel;
    
    IBOutlet UIImageView *_arrowImageView;
    
}

@end

@implementation CPBetRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)addBetRecordInfo:(NSDictionary *)info
{
    _topLeftLabel.text = [NSString stringWithFormat:@"%@  第%@期",[info DWStringForKey:@"gameName"],[info DWStringForKey:@"period"]];
    _topRightLabel.text = [NSString stringWithFormat:@"-%@",[info DWStringForKey:@"amount"]];
    _centerLeftLabel.text = [info DWStringForKey:@"addTime"];
    
    CGFloat winAmount = [[info DWStringForKey:@"realWinAmount"]floatValue];
    NSString *isWin = [info DWStringForKey:@"isWin"];
    
    if ([isWin integerValue]==1) {
        _centerRightLabel.textColor = [UIColor greenColor];
        _centerRightLabel.text = [NSString stringWithFormat:@"赢%.2f元",winAmount];
    }else if ([isWin integerValue] == 0){
        _centerRightLabel.textColor = [UIColor grayColor];
        _centerRightLabel.text = @"未开奖";
    }else{
        _centerRightLabel.textColor = [UIColor grayColor];
        _centerRightLabel.text = @"未中奖";
    }

    _bottomLeftLabel.text = [NSString stringWithFormat:@"玩法名称:%@",[info DWStringForKey:@"playName"]];
    _bottomRightLabel.text = [NSString stringWithFormat:@"投注号码%@",[info DWStringForKey:@"content"]];

}

-(void)addAccountRecordInfo:(NSDictionary *)info
{
    _arrowImageView.hidden = YES;
    
    NSDictionary *expandInfo = [info DWDictionaryForKey:@"expand"];
    _topLeftLabel.text = [expandInfo DWStringForKey:@"remark"];
    _centerLeftLabel.text =[NSString stringWithFormat:@"单号 %@",[info DWStringForKey:@"orderNo"]];
    _centerRightLabel.text =[NSString stringWithFormat:@"余额 %.2f",[[info DWStringForKey:@"amountAfter"]floatValue]];
    
    int inOrOut = [[info DWStringForKey:@"inOut"]intValue];
    if (inOrOut == 1) {
        _topRightLabel.textColor = [UIColor greenColor];
        _topRightLabel.text =[NSString stringWithFormat:@"+%@元",[info DWStringForKey:@"amount"]];
    }else{
        _topRightLabel.textColor = [UIColor redColor];
        _topRightLabel.text =[NSString stringWithFormat:@"-%@元",[info DWStringForKey:@"amount"]];
    }

    /*
     {
     "orderNo":"14970055665136422",--订单号
     "inOut":1,--1收入 -1支出
     "amount":99.00,--金额
     "amountAfter":152310922.80,--余额
     "expand":{"remark":"派奖"}--类型
     }

     
     */
    
}


-(void)addRechargeRecordInfo:(NSDictionary *)info
{
    int status = [[info DWStringForKey:@"status"]intValue];
    NSString *statusString = @"已取消";
    switch (status) {
        case 0:
            statusString = @"待审核";
            break;
        case 1:
            statusString = @"已存入";
            break;
        default:
            break;
    }
    _topLeftLabel.text = statusString;
    _centerLeftLabel.text = [NSString stringWithFormat:@"单号 %@",[info DWStringForKey:@"orderNo"]];
    
    _topRightLabel.textColor = [UIColor greenColor];
    _topRightLabel.text = [NSString stringWithFormat:@"%@元",[info DWStringForKey:@"amount"]];
    
    _centerRightLabel.text = [info DWStringForKey:@"saveTime"];

    /*
     
         {
            "orderNo":"1500650699868069",--单号
            "amount":1.00,--金额
            "status":0,--状态 0待审核 1已出入 -1/-2已取消
            "saveTime":"2017-07-21 23:24:59",--时间
            "id":838
        }
     */
}

-(void)addWithdrawRecordInfo:(NSDictionary *)info
{
    int status = [[info DWStringForKey:@"status"]intValue];
    NSString *statusString = @"";
    switch (status) {
        case 0:
            statusString = @"待审核";
            break;
        case 1:
            statusString = @"已提款";
            break;
        case -1:
            statusString = @"已取消";
            break;
        case 2:
            statusString = @"审核中";
            break;
        default:
            break;
    }
    _topLeftLabel.text = [[info DWStringForKey:@"accountCode"] isEqualToString:@"-"]?@"扣款":@"出款";
    _centerRightLabel.text = statusString;
    _centerLeftLabel.text = [NSString stringWithFormat:@"单号 %@",[info DWStringForKey:@"orderNo"]];
    
    _topRightLabel.textColor = [UIColor redColor];
    _topRightLabel.text = [NSString stringWithFormat:@"-%@元",[info DWStringForKey:@"amount"]];


    /*
     
     {
         accountCode = 123424324231;
         accountName = "\U6d4b\U8bd51";
         addTime = "Aug 30, 2017 2:34:26 PM";
         amount = 100;
         bankName = "\U4e2d\U56fd\U519c\U4e1a\U94f6\U884c";
         fee = 0;
         feeAdmin = 0;
         id = 28018;
         isAuto = 0;
         memberId = 75;
         orderNo = 1504074866048213;
         status = "-1";
         thirdId = 0;
         times = 2;
         totalTimes = 2;
         type = 1;
         updBy = admincp;
         updTime = "Aug 30, 2017 2:34:46 PM";
     }
     */
}


@end
