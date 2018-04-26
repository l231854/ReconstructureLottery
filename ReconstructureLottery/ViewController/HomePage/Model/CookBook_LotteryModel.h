//
//  CPLotteryModel.h
//  lottery
//
//  Created by wayne on 2017/6/12.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
    lastOpen = "2,6,0,6,9";
    lastPeriod = 20170617415;
    name = "\U4e09\U5206\U65f6\U65f6\U5f69";
    num = 51;
    period = 20170617416;
    pic = "/assets/statics/images/icon/51.png";
    timeout = 72;
 }
 
 
 开奖大厅首页数据：
 {
     content = "6,4,4";
     name = "\U6392\U5217\U4e09";
     num = 2;
     openTime = "2017-06-25 20:30:00";
     period = 2017169;
 }
 
 {
 endTime = 1508245495000;
 lastOpen = "1,3,6";
 lastPeriod = 20171017069;
 name = "\U5e7f\U897f\U5feb\U4e09";
 num = 17;
 opentime = "2017-10-17 21:08:00";
 period = 20171017070;
 pic = "/assets/statics/images/icon/17.png";
 type = @"type";
 
 }
 
 */

@interface CookBook_LotteryModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *num;
@property(nonatomic,copy)NSString *pic;

@property(nonatomic,copy)NSString *fullPicUrlString;


@property(nonatomic,copy)NSString *lastOpen;
@property(nonatomic,copy)NSString *lastPeriod;
@property(nonatomic,copy)NSString *period;
@property(nonatomic,copy)NSString *timeout;


@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *openTime;

@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *type;

@property(nonatomic,copy)NSString *status;


//extension
@property(nonatomic,assign)int mainResultCellStyle;
@property(nonatomic,retain)NSArray *resultArray;
@property(nonatomic,retain)NSString *noteDes;

@end
