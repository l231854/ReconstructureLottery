//
//  CPCPSignRecordCell.h
//  lottery
//
//  Created by wayne on 2017/8/26.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPCPSignRecordCell : UITableViewCell

-(void)addTopLeftText:(NSString *)topLeftText
         topRightText:(NSString *)topRightText
       bottomLeftText:(NSString *)bottomLeftText
      bottomRightText:(NSString *)bottomRightText;

@end
