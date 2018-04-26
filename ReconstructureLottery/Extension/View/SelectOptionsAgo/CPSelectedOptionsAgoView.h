//
//  DDChooseShopSizeView.h
//  dada
//
//  Created by wayne on 16/1/12.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CPSelectedOptionsAgoBlock)(NSInteger index);

@interface CPSelectedOptionsAgoView : UIView

+(void)showWithOnView:(UIView *)superView
                title:(NSString *)title
              options:(NSArray<NSString *> *)options
        selectedIndex:(NSInteger)selectedIndex
             selected:(CPSelectedOptionsAgoBlock)selected;

@end
