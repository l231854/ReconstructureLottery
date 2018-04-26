//
//  CPCPSignRecordCell.h
//  lottery
//
//  Created by wayne on 2017/8/26.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPBetRecordCell : UITableViewCell

-(void)addBetRecordInfo:(NSDictionary *)info;
-(void)addAccountRecordInfo:(NSDictionary *)info;
-(void)addRechargeRecordInfo:(NSDictionary *)info;
-(void)addWithdrawRecordInfo:(NSDictionary *)info;
@end
