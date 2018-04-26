//
//  CPRechargeAlipayToBankVC.h
//  lottery
//
//  Created by wayne on 2017/9/12.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPRechargeAlipayToBankVC : UIViewController

@property(nonatomic,strong)NSDictionary *rechargeInfo;


/**
 0:支付宝  1:微信
 */
@property(nonatomic,assign)int type;

@end
