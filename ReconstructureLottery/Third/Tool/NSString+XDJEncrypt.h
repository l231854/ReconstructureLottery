//
//  NSString+XDJEncrypt.h
//  XDJElectricityStandard
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma mark - NSDictionary XDJJSONString
@interface NSDictionary (XDJJSONString)

- (NSString *)JSONString;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
#pragma mark - NSData XDJBase64
@interface NSData (XDJBase64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

@end

#pragma mark - NSString XDJBase64
@interface NSString (XDJBase64)

+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
- (NSString *)base64DecodedString;
- (NSData *)base64DecodedData;

@end
#pragma mark - NSString XDJEncrypt
@interface NSString (XDJEncrypt)
/**
 *  AES解密
 *  @param base64EncodedString 主要是中文需要转为gbk格式的流
 */
+ (NSString *)decryptByGBKAES:(NSString *)base64EncodedString;

/**
 *  AES加密
 *  @return content 主要是服务器返回的带中文格式的内容
 */
+ (NSString *)encryptedByGBKAES:(NSString *)base64EncodedString;

/**
 *  验签
 *  @param array 排好序的数组
 */
+ (NSString *)getSignStringWithSortArray:(NSArray *)array;
@end


