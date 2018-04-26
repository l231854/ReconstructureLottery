//
//  CPAddFriendRechargeVC.h
//  lottery
//
//  Created by 施小伟 on 2017/11/27.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_BaseViewController.h"

@interface CPAddFriendRechargeVC : CookBook_BaseViewController

@property(nonatomic,assign)int type;

-(void)addTitleText:(NSString *)title
         detailText:(NSString *)detailText
     imageUrlString:(NSString *)urlString;



@end
