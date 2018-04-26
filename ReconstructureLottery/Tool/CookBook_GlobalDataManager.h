//
//  CPGlobalDataManager.h
//  lottery
//
//  Created by wayne on 2017/6/8.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookBook_GlobalDataManager : NSObject

@property(nonatomic,copy)NSString *domainUrlString;
@property(nonatomic,copy)NSString *updateUrl;
@property(nonatomic,copy)NSString *currentVersion;
@property(nonatomic,copy)NSString *lowVersion;

@property(nonatomic,copy)NSString *kefuUrlString;


@property(nonatomic,assign)BOOL isNeedUpdateNewestVersion;

@property(nonatomic,assign)BOOL isReviewVersion;

+(CookBook_GlobalDataManager *)shareGlobalData;
+(void)cookBook_playButtonClickVoice;

@end







