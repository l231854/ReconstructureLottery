//
//  CPRechargeDetailVC.m
//  lottery
//
//  Created by wayne on 2017/8/30.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPRechargeDetailVC.h"

@interface CPRechargeDetailVC ()
{
    IBOutlet UILabel *_orderNOLabel;
    IBOutlet UILabel *_incomeTypeLabel;
    IBOutlet UILabel *_incomeAmountLabel;
    IBOutlet UILabel *_discountAmountLabel;
    IBOutlet UILabel *_giveAmountLabel;
    IBOutlet UILabel *_finalIncomeLabel;
    IBOutlet UILabel *_incomeStatusLabel;
    IBOutlet UILabel *_incomeDateLabel;
    IBOutlet UILabel *_markLabel;
}

@end

@implementation CPRechargeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"入款明细";
    
    _orderNOLabel.text = [_rechargeInfo DWStringForKey:@"orderNo"];
    _incomeTypeLabel.text = [_rechargeInfo DWStringForKey:@"type"];
    _incomeAmountLabel.text = [_rechargeInfo DWStringForKey:@"amount"];
    _discountAmountLabel.text = [_rechargeInfo DWStringForKey:@"addAmount"];
    _giveAmountLabel.text = [_rechargeInfo DWStringForKey:@"giftAmount"];
    _finalIncomeLabel.text = [_rechargeInfo DWStringForKey:@"fAmount"];
    _incomeDateLabel.text = [_rechargeInfo DWStringForKey:@"saveTime"];
    _markLabel.text = [_rechargeInfo DWStringForKey:@"remark"];
    
    int status = [[_rechargeInfo DWStringForKey:@"status"]intValue];
    switch (status) {
        case 0:
            _incomeStatusLabel.text = @"待审核";
            break;
        case 1:
            _incomeStatusLabel.text = @"已存入";
            break;
        case -1:
        case -2:
            _incomeStatusLabel.text = @"已取消";
            break;
            
        default:
            break;
    }
    
    /*
     {
     "amount":"1.00",--存入金额
     "fAmount":"1.00",--最终存入金额
     "orderNo":"1500650803383305",--订单号
     "saveTime":"2017-07-21 23:26:43",--存入时间
     "remark":"无效订单",--备注
     "status":"-1",--状态 0待审核 1已存入 -1/-2已取消
     "giftAmount":"0.00",--赠送彩金
     "type":"支付宝入款",--类型
     "addAmount":"0.00"--优惠金额
     }
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-

@end
