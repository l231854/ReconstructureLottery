//
//  SUMUser.m
//  sumei
//
//  Created by wayne on 16/11/8.
//  Copyright © 2016年 施冬伟. All rights reserved.
//

#import "CookBook_User.h"

@interface CookBook_User()
{
    NSString *_token;
    CookBook_UserTokenInfo *_tokenInfo;
}

@end

@implementation CookBook_UserTokenInfo

-(BOOL)hasLogin
{
    if ([_isLogin intValue]==0) {
        return NO;
    }
    return YES;
}

-(NSString *)isLogin
{
    return _isLogin?_isLogin:@"";
}


@end

@implementation CookBook_User


static CookBook_User *shareUser;

+(CookBook_User *)shareUser{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        CookBook_User *existUser = [CookBook_User loadUser];
        shareUser = existUser?existUser:[CookBook_User new];
    });
    
    return shareUser;
}

+(void)cookBook_checkUpdateNewestVersion
{
    if ([CookBook_GlobalDataManager shareGlobalData].isNeedUpdateNewestVersion) {
        
//        [UIAlertView showWithTitle:@"发现新版本" message:@"请下载最新版本的应用" cancelButtonTitle:@"好的" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[CPGlobalDataManager shareGlobalData].updateUrl]];
//        }];
        
    }
}


+(void)cookBook_addWebCookies
{
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSURL *url = [NSURL URLWithString:[CookBook_GlobalDataManager shareGlobalData].domainUrlString];
    NSArray<NSHTTPCookie *> *cookies = [cookieStorage cookiesForURL:url];
    [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *properties = [[cookie properties] mutableCopy];
        //将cookie过期时间设置为一年后
        NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*30*12];
        properties[NSHTTPCookieExpires] = expiresDate;
        //下面一行是关键,删除Cookies的discard字段，应用退出，会话结束的时候继续保留Cookies
        [properties removeObjectForKey:NSHTTPCookieDiscard];
        
        [properties setObject:@"loginToken" forKey:NSHTTPCookieName];
        NSString *token = [[CookBook_User shareUser]cookBook_fetchLoginToken];
        [properties setObject:CPPercentEscapedStringFromString(token) forKey:NSHTTPCookieValue];
        [properties setObject:url.host forKey:NSHTTPCookieDomain];
        //重新设置改动后的Cookies
        [cookieStorage setCookie:[NSHTTPCookie cookieWithProperties:properties]];
    }];
    
}


NSString * CPPercentEscapedStringFromString(NSString *string) {
    static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

#pragma mark- class method

-(BOOL)isTryPlay
{
    if (![self.tokenInfo.type isEqualToString:@"0"]) {
        return YES;
    }
    return NO;
}


-(NSString *)cookBook_fetchLoginToken
{
    NSString *token = self.token?self.token:@"";
    return token;
}

-(void)cookBook_addMainDomainString:(NSString *)domainString;
{
    if (domainString.length>0) {
        _domainString = domainString;
    }
}

-(void)cookBook_addToken:(NSString *)token
{
    if (token && token.length>0) {
        
        if (![_token isEqualToString:token]) {
            
            _token = token;
            _tokenInfo = nil;
            [CookBook_User saveUser:self];
            [CookBook_User cookBook_addWebCookies];

        }
        
    }
    
}


-(void)cookBook_logout
{
    _token = @"";
    _tokenInfo = nil;
    [CookBook_User saveUser:self];
    [CookBook_User cookBook_addWebCookies];

}

-(void)lookForLoginToken
{
    /*
     <NSHTTPCookie version:0 name:"token" value:"dgNCzwpeaIrfIDt6zx2KmfwRyKN52g7oijeNJpM6mqllKhX/uKX8EmY/Fch26qy9xtKH8tkCojfbtThDtGtN9t0FxI3WfF/e2YtUb72F7qKozYdkoVJ0/ukSdmzvPITd" expiresDate:(null) created:2017-02-25 06:23:54 +0000 sessionOnly:TRUE domain:"47.89.51.31" partition:"none" path:"/" isSecure:FALSE>
     
     <NSHTTPCookie version:0 name:"JSESSIONID" value:"B2EF8752CEBC7C97EE1D74305C90B535" expiresDate:(null) created:2017-02-25 06:20:58 +0000 sessionOnly:TRUE domain:"47.89.51.31" partition:"none" path:"/lottery_admin" isSecure:FALSE>
     
     <NSHTTPCookie version:0 name:"JSESSIONID" value:"E2712E4D15E4EE5F60987B3ADA7EDA32" expiresDate:(null) created:2017-02-25 06:20:59 +0000 sessionOnly:TRUE domain:"47.89.51.31" partition:"none" path:"/lottery_phone" isSecure:FALSE>
     */
    
    /*
    for (NSHTTPCookie *cookie in  [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookies]) {
        
        if ([cookie.name isEqualToString:@"token"]) {
            NSString *value = cookie.value;
            if (![value isEqualToString:self.loginToken]) {
                self.loginToken = value;
                [SUMUser saveUser:self];
            }
        }
    }
     */
}

#pragma mark- setter && getter

-(NSString *)token
{
    return _token?_token:@"";
}

-(BOOL)isLogin
{
    if (self.tokenInfo.hasLogin) {
        return YES;
    }
    return NO;
}

-(CookBook_UserTokenInfo *)tokenInfo
{

    if (!_tokenInfo) {
        
        CookBook_UserTokenInfo *tokenInfo = nil;
        NSString *jsonString = [NSString decryptByGBKAES:self.token];
        if (jsonString) {
            NSDictionary *tokenDic = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            tokenInfo = [DWParsers getObjectByObjectName:@"CookBook_UserTokenInfo" andFromDictionary:tokenDic];
        }
        _tokenInfo = tokenInfo;
    }
    return _tokenInfo?_tokenInfo:[CookBook_UserTokenInfo new];
}

#pragma mark- coding delegate

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_token forKey:@"_token"];
    [aCoder encodeObject:_domainString forKey:@"_domainString"];

    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if(self != nil)
    {
        _token = [aDecoder decodeObjectForKey:@"_token"];
        _domainString = [aDecoder decodeObjectForKey:@"_domainString"];
    }
    return self;
}

#pragma mark- path

NSString * loadUserInfoFolder(){
 
    return @"guessandguess";
}

NSString * loadUserInfoFullPath(){
    
   return [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:loadUserInfoFolder()];
}

#pragma mark- AES

NSString * loadUserInfoAES256Key(){
    
    return @"nimabidewocao";
}

/**
 *  加载本地储存的用户信息
 *
 *  @return 用户
 */
+(CookBook_User *)loadUser
{
    NSData * aesUserData = [NSData dataWithContentsOfFile:loadUserInfoFullPath()];
    NSData * userData = [aesUserData AES256DecryptWithKey:loadUserInfoAES256Key()];
    CookBook_User * user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
    return user;
}


/**
 * 清除本地储存的用户信息
 */
+(BOOL)clearUserData
{
    @synchronized(self) {
        
        [CookBook_User saveUser:[CookBook_User new]];
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
        BOOL isSuccessed = YES;
        NSFileManager * fileManager =[NSFileManager defaultManager];
        BOOL isExistPath = [fileManager isDeletableFileAtPath:loadUserInfoFullPath()];
        if (isExistPath)
        {
            isSuccessed = [fileManager removeItemAtPath:loadUserInfoFullPath() error:nil];
        }
        
        return  isSuccessed;
    }
    
}

/**
 *  保存User对象到本地路径
 *
 *  @param user 用户模型
 *
 *  @return 是否保存成功
 */
+(BOOL)saveUser:(CookBook_User *)user
{
    @synchronized(self) {
        
        shareUser = user;
        NSData * userData = [NSKeyedArchiver archivedDataWithRootObject:user];
        NSData * aesUserData = [userData AES256EncryptWithKey:loadUserInfoAES256Key()];
        BOOL isOk = [aesUserData writeToFile:loadUserInfoFullPath() atomically:YES];
        return isOk;
    }
    
}



@end
