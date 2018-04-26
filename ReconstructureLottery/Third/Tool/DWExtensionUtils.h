//
//  DWExtensionUtils.h
//  SendEmailTest
//
//  Created by XiaMenDiyou on 15-1-20.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>

@interface DWExtensionUtils : NSObject

@end

@interface NSString(Utils)

- (NSString *)URLEncodedString;
-(NSString *)URLDecodedString;

- (BOOL)isPureInt;
+ (BOOL)checkTelNumber:(NSString *) telNumber;

//过滤中文
+(NSString*)filtrateChinese:(NSString*)url;

+(NSString*)DWMessageDetailListTimeInterval:(NSString*)interval;
+(NSString*)DWMessageSessionListTimeInterval:(NSString*)interval;


/* mailSystem  */
+(NSString*)DWMailListTimeInterval:(NSString*)interval;

+(NSString*)dateTimeInterval:(NSString*)timeInterval dateFormatter:(NSString*)formatterString;
-(NSString*)firstLetterUppercase;
-(NSString*)firstLetterUppercaseChinese;



-(CGSize)suitableFromMaxSize:(CGSize)size font:(UIFont*)font;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

/* unicode转换为中文 */
+(NSString *)replaceUnicode:(NSString *)unicodeStr;
/* 中文转换为unicode */
+(NSString *) stringToUnicode:(NSString *)string;

+ (NSString *)textFromBase64String:(NSString *)base64;
- (NSString *)MD5String;

/* parser deviceToken */
-(NSString*)deviceTokenFormatTransform;

@end

@interface UIImage(Utils)

+(UIImage *)resizeImage:(NSString *)imageName;
+(UIImage *)imageWithColor:(UIColor *)color;
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize )size;
+(UIImage *)imageWithColor:(UIColor *)color alpha:(float)alpha;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage*)imageMaskWithColor:(UIColor *)maskColor;

@end


@interface UIColor(Utils)

+(UIColor*)colorByASCII:(float)asc;

@end


@interface NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密
- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;
- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密
- (NSString *)newStringInBase64FromData;            //追加64编码
+ (NSString*)base64encode:(NSString*)str;           //同上64编码
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;  //base64 解密

#define DEFAULT_POLYNOMIAL 0xEDB88320L
#define DEFAULT_SEED       0xFFFFFFFFL

-(uint32_t) crc32;
-(uint32_t) crc32WithSeed:(uint32_t)seed;
-(uint32_t) crc32UsingPolynomial:(uint32_t)poly;
-(uint32_t) crc32WithSeed:(uint32_t)seed usingPolynomial:(uint32_t)poly;

@end


@interface UIViewController(AfterLoad)

- (void)viewDidAfterLoad;

@end


@interface NSDictionary(DYObjectForKey)

-(NSString *)DWStringForKey:(id)key;
-(NSArray *)DWArrayForKey:(id)key;
-(NSDictionary *)DWDictionaryForKey:(id)key;

@end

@interface NSMutableDictionary(DWObjectKey)

-(void)DWSetObject:(id)object forKey:(id)aKey;

@end


@interface UINavigationItem (CustomBackButton)

-(UIBarButtonItem *)backBarButtonItem;

@end

@interface UIView (nib)

+ (instancetype)createViewFromNib;


@end


@interface NSDate (dwEX)

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

@end


