//
//  CPBuyLotteryManager.h
//  lottery
//
//  Created by 施小伟 on 2017/11/26.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 e11x5  11选5
 xglhc  六合彩
 ssc    时时彩
 shssl  上海时时乐
 pl3    排列三
 pk10   PK10
 pcdd   PC蛋蛋
 klsf   快乐十分
 k3     快三
 fc3d   福彩3D
 */
typedef enum : NSUInteger {
    
    CPLotteryResultForE11X5     = 0,
    CPLotteryResultForXGLHC     = 1,
    CPLotteryResultForSSC       = 2,
    CPLotteryResultForSHSSL     = 3,
    CPLotteryResultForP13       = 4,
    CPLotteryResultForPK10      = 5,
    CPLotteryResultForPCDD      = 6,
    CPLotteryResultForKLSF      = 7,
    CPLotteryResultForK3        = 8,
    CPLotteryResultForFC3D      = 9
    
    
} CPLotteryResultType;


#define CPLotteryResultTypeByTypeString(typeString)\
[@[@"e11x5",@"xglhc",@"ssc",@"shssl",@"pl3",@"pk10",@"pcdd",@"klsf",@"k3",@"fc3d",] indexOfObject:typeString]

@interface CookBook_BuyLotteryManager : NSObject


+(instancetype)shareManager;

/**
 当前的购买彩种的类型
 */
@property(nonatomic,assign)CPLotteryResultType currentBuyLotteryType;

/**
 当前的玩法名称
 */
@property(nonatomic,copy)NSString *currentPlayKindDes;


/*
 当前投注期数
 */
@property(nonatomic,copy)NSString *currentBetPeriod;



/**
 获取快3类型的图片

 @param number 数字
 */
+(UIImage *)k3BackgroundImageByNumber:(NSString *)number;




@end
