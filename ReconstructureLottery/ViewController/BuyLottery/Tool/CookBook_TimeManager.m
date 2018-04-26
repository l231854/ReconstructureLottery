//
//  CPTimeManager.m
//  lottery
//
//  Created by wayne on 2017/10/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_TimeManager.h"

static CookBook_TimeManager *shareTime;

@implementation CookBook_TimeManager


+(CookBook_TimeManager *)shareTimeManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareTime = [CookBook_TimeManager new];
    });
    return shareTime;
}


-(void)cookBook_reloadBeiJingTime
{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSDate *beijingDate = [self getInternetDate];
        if (beijingDate) {
            NSDate *nowDate = [NSDate date];
            NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970];
            NSTimeInterval beiJingTimeInterval = [beijingDate timeIntervalSince1970];
            _beijingTiemDistance =nowTimeInterval - beiJingTimeInterval-1;
        }
        
    });
}

- (NSDate *)getInternetDate
{
    NSString *urlString = @"http://m.baidu.com";
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString: urlString]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval: 10];
    [request setHTTPShouldHandleCookies:FALSE];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSString *date = [[response allHeaderFields] objectForKey:@"Date"];
    date = [date substringFromIndex:5];
    date = [date substringToIndex:[date length]-4];
    NSDateFormatter *dMatter = [[NSDateFormatter alloc] init];
    dMatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [dMatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];
    NSDate *netDate = [dMatter dateFromString:date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: netDate];
    NSDate *localeDate = [netDate  dateByAddingTimeInterval: interval];
    return localeDate;
}



@end
