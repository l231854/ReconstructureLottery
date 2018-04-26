//
//  CPRechargeDetailVC.m
//  lottery
//
//  Created by wayne on 2017/8/30.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPWithdrawDetailVC.h"

@interface CPWithdrawDetailVC ()
{
    IBOutlet UILabel *_orderNOLabel;
    IBOutlet UILabel *_incomeTypeLabel;
    IBOutlet UILabel *_incomeAmountLabel;
    IBOutlet UILabel *_discountAmountLabel;
    IBOutlet UILabel *_giveAmountLabel;
    IBOutlet UILabel *_incomeStatusLabel;
    IBOutlet UILabel *_incomeDateLabel;
    IBOutlet UILabel *_markLabel;
}

@end

@implementation CPWithdrawDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提款明细";
    
    _orderNOLabel.text = [_withdrawInfo DWStringForKey:@"orderNo"];
    _incomeTypeLabel.text = [[_withdrawInfo DWStringForKey:@"accountCode"] isEqualToString:@"-"]?@"手动扣款":@"会员出款";
    _incomeAmountLabel.text = [_withdrawInfo DWStringForKey:@"amount"];
    _discountAmountLabel.text = [_withdrawInfo DWStringForKey:@"fee"];
    _giveAmountLabel.text = [_withdrawInfo DWStringForKey:@"feeAdmin"];
    _incomeDateLabel.text = [_withdrawInfo DWStringForKey:@"addTime"];
    _markLabel.text = [_withdrawInfo DWStringForKey:@"remark"];
    
    int status = [[_withdrawInfo DWStringForKey:@"status"]intValue];
    switch (status) {
        case 0:
            _incomeStatusLabel.text = @"待审核";
            break;
        case 1:
            _incomeStatusLabel.text = @"已提款";
            break;
        case -1:
            _incomeStatusLabel.text = @"已取消";
            break;
        case -2:
            _incomeStatusLabel.text = @"审核中";
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
