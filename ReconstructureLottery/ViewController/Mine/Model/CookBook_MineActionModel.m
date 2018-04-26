//
//  CPMineActionModel.m
//  lottery
//
//  Created by wayne on 2017/8/2.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_MineActionModel.h"

@implementation CookBook_MineActionModel

+(instancetype)cookBook_modelName:(NSString *)name
                    icon:(NSString *)icon
                identify:(int)identify
{
    CookBook_MineActionModel *model = [CookBook_MineActionModel new];
    model.name = name;
    model.icon = icon;
    model.identify = identify;
    return model;
}

@end
