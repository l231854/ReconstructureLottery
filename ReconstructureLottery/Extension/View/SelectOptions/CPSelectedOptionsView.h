//
//  DDChooseShopSizeView.h
//  dada
//
//  Created by wayne on 16/1/12.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CPSelectedOptionsBlock)(NSInteger index);

@interface CPSelectedOptionsView : UIView

+(void)showWithOnView:(UIView *)superView
              options:(NSArray<NSString *> *)options
        selectedIndex:(NSInteger)selectedIndex
             selected:(CPSelectedOptionsBlock)selected;

+(CPSelectedOptionsView*)showWithOnView:(UIView *)superView
                               options:(NSArray<NSString *> *)options
                         selectedIndex:(NSInteger)selectedIndex
                          clearBgColor:(BOOL)isClearBgColor
                              selected:(CPSelectedOptionsBlock)selected;

-(void)dismiss;
@end
