//
//  CPRechargeBankCompletedVC.m
//  lottery
//
//  Created by wayne on 2017/9/11.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CPRechargeBankCompletedVC.h"

@interface CPRechargeBankCompletedVC ()
{
    
    IBOutlet UILabel *_amountLabel;
}
@end

@implementation CPRechargeBankCompletedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行转账";
    
    _amountLabel.text = [NSString stringWithFormat:@"充值金额%@元",self.rechargeMoney];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark- action
- (IBAction)finishedAction:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
