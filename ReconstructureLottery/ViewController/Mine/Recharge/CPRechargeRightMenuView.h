//
//  CPRechargeRightMenuView.h
//  lottery
//
//  Created by 施小伟 on 2017/11/27.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPRechargeRightMenuView : UIView

+(void)showRightMenuViewOnView:(UIView *)supview
    actionNavigationController:(UINavigationController *)nav;

-(void)dismiss;

@end
