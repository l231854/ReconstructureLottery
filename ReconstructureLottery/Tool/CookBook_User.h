//
//  SUMUser.h
//  sumei
//
//  Created by wayne on 16/11/6.
//  Copyright © 2016年 施冬伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CookBook_UserTokenInfo : NSObject

@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *isLogin;
@property(nonatomic,copy)NSString *memberCode;
@property(nonatomic,copy)NSString *memberName;
@property(nonatomic,copy)NSString *errorMsg;
@property(nonatomic,copy)NSString *type;


@property(nonatomic,assign)BOOL hasLogin;

@end

@interface CookBook_User : NSObject


@property(nonatomic,assign,readonly)BOOL isLogin;
@property(nonatomic,copy,readonly)NSString *domainString;
@property(nonatomic,copy,readonly)NSString *token;
@property(nonatomic,assign,readonly)BOOL isTryPlay;
@property(nonatomic,retain,readonly)CookBook_UserTokenInfo *tokenInfo;


/**
 当前是否是数字盘
 */
@property(nonatomic,assign)BOOL buyLotteryDetailHasNumberPan;


+(CookBook_User *)shareUser;
+(void)cookBook_checkUpdateNewestVersion;
+(void)cookBook_addWebCookies;


-(NSString *)cookBook_fetchLoginToken;
-(void)cookBook_addMainDomainString:(NSString *)domainString;
-(void)cookBook_addToken:(NSString *)token;
-(void)cookBook_logout;


@end



