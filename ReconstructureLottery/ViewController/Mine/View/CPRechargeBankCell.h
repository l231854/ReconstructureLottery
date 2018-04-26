//
//  CPRechargeBankCell.h
//  lottery
//
//  Created by wayne on 2017/9/10.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPRechargeBankCell : UITableViewCell

-(void)addBankName:(NSString *)bankName
    collectionName:(NSString *)collectionName
       infoMessage:(NSString *)message
          selected:(BOOL)selected;

@end
