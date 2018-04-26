//
//  CPPersonalMessageCell.h
//  lottery
//
//  Created by wayne on 2017/8/29.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPPersonalMessageCell : UITableViewCell


-(void)addTitle:(NSString *)title
     detailText:(NSString *)detailText
         isRead:(BOOL)isRead;

@end
