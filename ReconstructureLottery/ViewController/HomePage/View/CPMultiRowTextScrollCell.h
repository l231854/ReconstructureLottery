//
//  CPMultiRowTextScrollCell.h
//  lottery
//
//  Created by wayne on 2017/6/9.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPMultiRowTextScrollCell : UITableViewCell

-(void)addName:(NSString *)name
        amount:(NSString *)amount
       content:(NSString *)content;

@end
