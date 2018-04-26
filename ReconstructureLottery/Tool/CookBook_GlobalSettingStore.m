//
//  CPGlobalSettingStore.m
//  lottery
//
//  Created by wayne on 2017/6/17.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import "CookBook_GlobalSettingStore.h"

@interface CookBook_GlobalSettingStore ()
{
    NSString *_openButtonVoice;
}

@end

@implementation CookBook_GlobalSettingStore

static CookBook_GlobalSettingStore *shareStore;

+(CookBook_GlobalSettingStore *)shareStore{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        CookBook_GlobalSettingStore *existStore = [CookBook_GlobalSettingStore loadStore];
        shareStore = existStore?existStore:[CookBook_GlobalSettingStore new];
    });
    
    return shareStore;
}

#pragma mark- class method

+(BOOL)saveStore:(CookBook_GlobalSettingStore *)store
{
    @synchronized(self) {
        
        shareStore = store;
        NSData * storeData = [NSKeyedArchiver archivedDataWithRootObject:store];
        NSData * aesStoreData = [storeData AES256EncryptWithKey:loadSettingStoreInfoAES256Key()];
        BOOL isOk = [aesStoreData writeToFile:loadSettingStoreInfoFullPath() atomically:YES];
        return isOk;
    }
    
}

#pragma mark- coding delegate

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_openButtonVoice forKey:@"_openButtonVoice"];
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self != nil)
    {
        _openButtonVoice = [aDecoder decodeObjectForKey:@"_openButtonVoice"];
        
    }
    return self;
}

#pragma mark- object method

-(void)cookBook_switchButtonVoiceIsOpen:(BOOL)isOpen
{
    if (isOpen) {
        _openButtonVoice = @"1";
    }else{
        _openButtonVoice = @"0";
    }
    [CookBook_GlobalSettingStore saveStore:self];
}

#pragma mark- getter

-(BOOL)isOpenButtonVoice
{
    if ([_openButtonVoice isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}

#pragma mark- AES

NSString * loadSettingStoreInfoFolder(){
    
    return @"settingStore";
}

NSString * loadSettingStoreInfoFullPath(){
    
    return [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:loadSettingStoreInfoFolder()];
}

#pragma mark- AES

NSString * loadSettingStoreInfoAES256Key(){
    
    return @"settingStoreA26K";
}

/**
 *  加载本地储存的用户信息
 *
 *  @return 用户
 */
+(CookBook_GlobalSettingStore *)loadStore
{
    NSData * aesStoreData = [NSData dataWithContentsOfFile:loadSettingStoreInfoFullPath()];
    NSData * storeData = [aesStoreData AES256DecryptWithKey:loadSettingStoreInfoAES256Key()];
    CookBook_GlobalSettingStore * store = [NSKeyedUnarchiver unarchiveObjectWithData:storeData];
    return store;
}

@end
