//
//  CPGlobalDataManager.m
//  lottery
//
//  Created by wayne on 2017/6/8.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_GlobalDataManager.h"

static CookBook_GlobalDataManager *shareGlobalData;

@interface CookBook_GlobalDataManager()
{
    SystemSoundID soundFileObject;
}

@property(nonatomic,copy)NSString *localVersion;

@end

@implementation CookBook_GlobalDataManager

+(CookBook_GlobalDataManager *)shareGlobalData{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareGlobalData = [CookBook_GlobalDataManager new];
        
        //得到音效文件的地址
        NSString*soundFilePath =[[NSBundle mainBundle]pathForResource:@"weico_click" ofType:@"wav"];
        
        //将地址字符串转换成url
        NSURL*soundURL = [NSURL  fileURLWithPath:soundFilePath];
        
        //生成系统音效id
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL, &shareGlobalData->soundFileObject);
    });
    
    return shareGlobalData;
}

-(NSString *)localVersion
{
    if (!_localVersion) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _localVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return _localVersion;
}

-(BOOL)isReviewVersion
{
    return NO;
    BOOL isReviewVersion = NO;
    if ([self compareVersion:self.localVersion greaterThanVersion:self.currentVersion]) {
        isReviewVersion = YES;
    }
    return isReviewVersion;
}

-(BOOL)isNeedUpdateNewestVersion
{
    _isNeedUpdateNewestVersion = NO;
    if ([self compareVersion:self.lowVersion greaterThanVersion:self.localVersion]) {
        _isNeedUpdateNewestVersion = YES;
    }
    return _isNeedUpdateNewestVersion;
}

-(BOOL)compareVersion:(NSString *)originVersion greaterThanVersion:(NSString *)newVersion
{
    if (!originVersion || !newVersion) {
        return NO;
    }
    BOOL isGreaterThan = NO;
    //版本比较
    NSRange originPointRange = [originVersion rangeOfString:@"."];
    NSRange greaterPointRange = [newVersion rangeOfString:@"."];
    
    NSInteger originValue;
    NSInteger greaterValue;
    
    NSString *lastOriginVersion = @"0";
    NSString *lastGreaterVersion = @"0";
    if (originPointRange.location != NSNotFound && greaterPointRange.location != NSNotFound) {
        
        originValue = [[originVersion substringToIndex:originPointRange.location]integerValue];
        greaterValue = [[newVersion substringToIndex:greaterPointRange.location]integerValue];
        
        lastOriginVersion = [originVersion substringFromIndex:originPointRange.location+originPointRange.length];
        lastGreaterVersion = [newVersion substringFromIndex:greaterPointRange.location+greaterPointRange.length];

        
    }else if (originPointRange.location == NSNotFound && greaterPointRange.location == NSNotFound){
        
        originValue = [originVersion integerValue];
        greaterValue = [newVersion integerValue];
        
    }else if (originPointRange.location != NSNotFound && greaterPointRange.location == NSNotFound){
        
        originValue = [[originVersion substringToIndex:originPointRange.location]integerValue];
        greaterValue = [newVersion integerValue];
        
        lastOriginVersion = [originVersion substringFromIndex:originPointRange.location+originPointRange.length];

        
    }else if (originPointRange.location == NSNotFound && greaterPointRange.location != NSNotFound){
        
        originValue = [originVersion integerValue];
        greaterValue = [[newVersion substringToIndex:greaterPointRange.location]integerValue];
        lastGreaterVersion = [newVersion substringFromIndex:greaterPointRange.location+greaterPointRange.length];

    }
    
    lastOriginVersion = lastOriginVersion?lastOriginVersion:@"0";
    lastGreaterVersion = lastGreaterVersion?lastGreaterVersion:@"0";

    if (originValue > greaterValue) {
        isGreaterThan = YES;
    }else if (originValue<greaterValue)
        isGreaterThan = NO;
    
    else{
        
        if (originPointRange.location == NSNotFound && greaterPointRange.location == NSNotFound) {
            isGreaterThan = NO;
        }else{
            isGreaterThan = [self compareVersion:lastOriginVersion greaterThanVersion:lastGreaterVersion];
        }
    }
    return isGreaterThan;
    
}


+(void)cookBook_playButtonClickVoice
{
    
    return;
    //播放系统音效
    AudioServicesPlaySystemSound([CookBook_GlobalDataManager shareGlobalData]->soundFileObject);
    
}


@end
