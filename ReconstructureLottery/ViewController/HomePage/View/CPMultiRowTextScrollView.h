//
//  CPMultiRowTextScrollView.h
//  lottery
//
//  Created by wayne on 2017/6/9.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPMultiRowTextScrollView : UITableView

-(instancetype)initWithFrame:(CGRect)frame
                       style:(UITableViewStyle)style
                   dataArray:(NSArray *)dataArray;

-(CGFloat)cellHeight;

@end
