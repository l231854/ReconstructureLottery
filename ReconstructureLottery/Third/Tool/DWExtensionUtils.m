//
//  DWExtensionUtils.m
//  SendEmailTest
//
//  Created by XiaMenDiyou on 15-1-20.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DWExtensionUtils.h"
#import "Header.h"
#import <CommonCrypto/CommonDigest.h>
#import <objc/runtime.h>

@implementation DWExtensionUtils

@end

@implementation  NSString(Utils)

- (NSString *)URLEncodedString
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

-(NSString *)URLDecodedString
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

- (BOOL)isPureInt{
    
    NSScanner* scan = [NSScanner scannerWithString:self];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

+ (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}

+(NSString*)filtrateChinese:(NSString*)url
{
    NSString * strURL= (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)url,
                                                                                             NULL,
                                                                                             NULL,
                                                                                             kCFStringEncodingUTF8));
    return strURL;
}

+(NSString*)DWMessageDetailListTimeInterval:(NSString*)interval
{
    if (!([interval isKindOfClass:[NSString class]]&&[interval length]>0))
    {
        return @"";
    }
    
    // YYYY-MM-dd HH:mm:ss"
    NSDateFormatter *formatter1 =[[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSDateFormatter *formatter2 =[[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"YYYY-MM-dd"];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    [formatter1 setTimeZone:zone];
    
    NSDate * originDate = [NSDate dateWithTimeIntervalSince1970:[interval longLongValue]];
    
    NSDate * nowDate = [NSDate date];
    NSString * nowTime = [formatter1 stringFromDate:nowDate];
    NSString * originTime =[formatter2 stringFromDate:originDate];
    
    // 1. 判断是不是同一年
    if ([[nowTime substringToIndex:4]intValue]==[[originTime substringToIndex:4]intValue])
    {
        
        
        //2.判断是不是同一天
        NSRange rangeDay;
        rangeDay.location=8;
        rangeDay.length=2;
        
        int dayDistance = [[nowTime substringWithRange:rangeDay]intValue]-[[originTime substringWithRange:rangeDay]intValue];
        
        if (dayDistance==0)
        {
            [formatter1 setDateFormat:@"H:mm"];
        }
        else if(dayDistance<7)
        {
            [formatter1 setDateFormat:@"EEE H:mm"];
        }
        else
        {
            [formatter1 setDateFormat:@"M月dd日 H:mm"];

        }
    }
    else
    {
        [formatter1 setDateFormat:@"YY/MM/dd H:mm"];
    }
    
    return [formatter1 stringFromDate:originDate];
}

+(NSString*)DWMessageSessionListTimeInterval:(NSString*)interval
{
    if (!([interval isKindOfClass:[NSString class]]&&[interval length]>0))
    {
        return @"";
    }
    
    // YYYY-MM-dd HH:mm:ss"
    NSDateFormatter *formatter1 =[[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSDateFormatter *formatter2 =[[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"YYYY-MM-dd"];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    [formatter1 setTimeZone:zone];
    
    NSDate * originDate = [NSDate dateWithTimeIntervalSince1970:[interval longLongValue]];
    
    NSDate * nowDate = [NSDate date];
    NSString * nowTime = [formatter1 stringFromDate:nowDate];
    NSString * originTime =[formatter2 stringFromDate:originDate];
    
    // 1. 判断是不是同一年
    if ([[nowTime substringToIndex:4]intValue]==[[originTime substringToIndex:4]intValue])
    {
        
        
        //2.判断是不是同一天
        NSRange rangeDay;
        rangeDay.location=8;
        rangeDay.length=2;
        if ([[nowTime substringWithRange:rangeDay]intValue]==[[originTime substringWithRange:rangeDay]intValue])
        {
            [formatter1 setDateFormat:@"H:mm"];
        }
        else
        {
            [formatter1 setDateFormat:@"M月dd日"];
        }
    }
    else
    {
        [formatter1 setDateFormat:@"YY/MM/dd"];
    }
    
    return [formatter1 stringFromDate:originDate];
}

+(NSString*)DWMailListTimeInterval:(NSString*)interval
{
    if (!([interval isKindOfClass:[NSString class]]&&[interval length]>0))
    {
        return @"";
    }
    
    /*
         NSTimeZone *zone = [NSTimeZone systemTimeZone];
         [formatter setTimeZone:zone];
     */
    
    // YYYY-MM-dd HH:mm:ss"
    NSDateFormatter *formatter1 =[[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSDateFormatter *formatter2 =[[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"YYYY-MM-dd"];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    [formatter1 setTimeZone:zone];
    
    NSDate * originDate = [NSDate dateWithTimeIntervalSince1970:[interval longLongValue]];

    NSDate * nowDate = [NSDate date];
    NSString * nowTime = [formatter1 stringFromDate:nowDate];
    NSString * originTime =[formatter2 stringFromDate:originDate];
    
    // 1. 判断是不是同一年
    if ([[nowTime substringToIndex:4]intValue]==[[originTime substringToIndex:4]intValue])
    {
        
        
        //2.判断是不是同一天
        NSRange rangeDay;
        rangeDay.location=8;
        rangeDay.length=2;
        if ([[nowTime substringWithRange:rangeDay]intValue]==[[originTime substringWithRange:rangeDay]intValue])
        {
            [formatter1 setDateFormat:@"H:mm"];
        }
        else
        {
            [formatter1 setDateFormat:@"M月dd日"];
        }
    }
    else
    {
        [formatter1 setDateFormat:@"YYYY/MM/dd"];
    }
    
    return [formatter1 stringFromDate:originDate];
}

+(NSString*)dateTimeInterval:(NSString*)timeInterval dateFormatter:(NSString*)formatterString
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[timeInterval longLongValue]];
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    
    return [formatter stringFromDate:date];
    
}

-(CGSize)suitableFromMaxSize:(CGSize)size font:(UIFont*)font
{
    
    // label可设置的最大高度和宽度
    //    CGSize size = CGSizeMake(300.f, MAXFLOAT);
    
    //    获取当前文本的属性
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    
    //ios7方法，获取文本需要的size，限制宽度
    
    CGSize  actualsize =[self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:tdic context:nil].size;
   actualsize.width=actualsize.width+2;
   actualsize.height=actualsize.height+1;

    // ios7之前使用方法获取文本需要的size，7.0已弃用下面的方法。此方法要求font，与breakmode与之前设置的完全一致
    //    CGSize actualsize = [tstring sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    //   更新UILabel的frame
    
    return actualsize;
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [self suitableFromMaxSize:maxSize font:font];
//    NSDictionary *attrs = @{NSFontAttributeName : font};
//    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

-(NSString*)firstLetterUppercase
{
    
    if (self.length<1)
    {
        return @"";
    }
    
    NSString * firstLetter=[[self uppercaseString]substringToIndex:1];
    NSString *letterRegex = @"[A-Z0-9]";
    NSPredicate *letterPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", letterRegex];
    
    if (![letterPredicate evaluateWithObject:firstLetter])
    {
        firstLetter=[NSString stringWithFormat:@"%c",pinyinFirstLetters([firstLetter characterAtIndex:0])];
        firstLetter=[firstLetter uppercaseString];
        firstLetter=[letterPredicate evaluateWithObject:firstLetter]?firstLetter:@"@";
    }
    return firstLetter;
}

-(NSString*)firstLetterUppercaseChinese
{
    if (self.length<1)
    {
        return @"";
    }
    
    NSString * firstLetter=[[self uppercaseString]substringToIndex:1];
    NSString *letterRegex = @"[A-Z]";
    NSPredicate *letterPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", letterRegex];
    
    if (![letterPredicate evaluateWithObject:firstLetter])
    {
        firstLetter=[NSString stringWithFormat:@"%c",pinyinFirstLetters([firstLetter characterAtIndex:0])];
        firstLetter=[firstLetter uppercaseString];
        firstLetter=[letterPredicate evaluateWithObject:firstLetter]?firstLetter:@"#";
    }
    return firstLetter;
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}



+(NSString *) stringToUnicode:(NSString *)string

{
    
    NSUInteger length = [string length];
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    for (int i = 0;i < length; i++)
    {
        unichar _char = [string characterAtIndex:i];
        //判断是否为英文和数字
        if (_char <= '9' && _char >= '0')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }
        else if(_char >= 'a' && _char <= 'z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }
        else if(_char >= 'A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }
        else
        {
            
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    return s;
    
    
}

- (NSString *)MD5String
{
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}



//base64解密
#define     LocalStr_None           @""

+ (NSString *)textFromBase64String:(NSString *)base64
{
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        //取项目的bundleIdentifier作为KEY   改动了此处
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        NSData *data = [NSData dataWithBase64EncodedString:base64];
        //IOS 自带DES解密 Begin    改动了此处
//        data = [self DESDecrypt:data WithKey:key];
        //IOS 自带DES加密 End
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    else {
        return LocalStr_None;
    }
}

/* parser deviceToken */
-(NSString*)deviceTokenFormatTransform
{
    NSMutableString * mtDt=[NSMutableString new];
    for (int i=0; i<self.length; i++)
    {
        NSRange range;
        range.location=i;
        range.length=1;
        NSString * character = [self substringWithRange:range];
        
        NSString *regex = @"[A-Za-z0-9]+";
        NSPredicate*predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        if ([predicate evaluateWithObject:character])
        {
            [mtDt insertString:character atIndex:mtDt.length];
        }
    }
    return mtDt;
}

@end


@implementation UIImage(Utils)

+ (UIImage *)resizeImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width * 0.5;
    CGFloat imageH = image.size.height * 0.5;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH, imageW, imageH, imageW) resizingMode:UIImageResizingModeTile];
}

+(UIImage *)imageWithColor:(UIColor *)color
{
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize )size
{
    CGSize imageSize = size;
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(UIImage *)imageWithColor:(UIColor *)color alpha:(float)alpha
{
    color=[color colorWithAlphaComponent:alpha];
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize{
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageMaskWithColor:(UIColor *)maskColor {
    if (!maskColor) {
        return nil;
    }
    
    UIImage *newImage = nil;
    
    CGRect imageRect = (CGRect){CGPointZero,self.size};
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextTranslateCTM(context, 0.0, -(imageRect.size.height));
    
    CGContextClipToMask(context, imageRect, self.CGImage);//选中选区 获取不透明区域路径
    CGContextSetFillColorWithColor(context, maskColor.CGColor);//设置颜色
    CGContextFillRect(context, imageRect);//绘制
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();//提取图片
    
    UIGraphicsEndImageContext();
    return newImage;
}


@end


@implementation UIColor(Utils)

+(UIColor*)colorByASCII:(float)asc
{
    /*
     数字：0-9  对应asc：48-57 （48，49，50，51，52 brownColor  53，54，55，56，57：redColor）
     字母：A-Z  对应asc：65-90  (65,66,67,68: greenColor   69,70,71,72: blueColor   73,74,75,76 :cyanColor   77,78,79,80: yellowColor   81,82,83,84:organgeColor   85,86,87,88: magentaColor   89,90: purpleColor)
     */
    
    UIColor * color;
    
    float alpha = 0.5;
    if (asc>=48&&asc<=52)
    {
        color=[UIColor colorWithRed:0.6 green:0.4 blue:0.2 alpha:alpha];
    }
    else if(asc>=53&&asc<=57)
    {
        color=[UIColor colorWithRed:1.0 green:0.1 blue:0.1 alpha:alpha];
    }
    else if(asc>=65&&asc<=68)
    {
        color=[UIColor colorWithRed:0.1 green:1.0 blue:0.1 alpha:alpha];
    }
    else if(asc>=69&&asc<=72)
    {
        color=[UIColor colorWithRed:0.1 green:0.1 blue:1.0 alpha:alpha];
    }
    else if(asc>=73&&asc<=76)
    {
        color=[UIColor colorWithRed:0.1 green:1.0 blue:1.0 alpha:alpha];
    }
    else if(asc>=77&&asc<=80)
    {
        color=[UIColor colorWithRed:1.0 green:1.0 blue:0.1 alpha:alpha];
    }
    else if(asc>=81&&asc<=84)
    {
        color=[UIColor colorWithRed:1.0 green:0.1 blue:1.0 alpha:alpha];
    }
    else if(asc>=85&&asc<=88)
    {
        color=[UIColor colorWithRed:1.0 green:0.5 blue:0.1 alpha:alpha];
    }
    else if(asc>=89&&asc<=90)
    {
        color=[UIColor colorWithRed:0.5 green:0.1 blue:0.5 alpha:alpha];
    }
    else
    {
        color=[UIColor colorWithRed:0.6 green:0.4 blue:0.2 alpha:alpha];
    }
    
    return color;
}


@end


@implementation NSData (AES)

static char base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

- (NSData *)AES256EncryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}



- (NSData *)AES256DecryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)AES128Operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv
{
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess)
    {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    }
    free(buffer);
    return nil;
}

- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv
{
    return [self AES128Operation:kCCEncrypt key:key iv:iv];
}

- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv
{
    return [self AES128Operation:kCCDecrypt key:key iv:iv];
}



- (NSData *)AES128EncryptWithKey:(NSString *)key   //加密
{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}


- (NSData *)AES128DecryptWithKey:(NSString *)key   //解密
{
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [self bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}




- (NSString *)newStringInBase64FromData            //追加64编码
{
    NSMutableString *dest = [[NSMutableString alloc] initWithString:@""];
    unsigned char * working = (unsigned char *)[self bytes];
    NSInteger srcLen = [self length];
    for (int i=0; i<srcLen; i += 3) {
        for (int nib=0; nib<4; nib++) {
            int byt = (nib == 0)?0:nib-1;
            int ix = (nib+1)*2;
            if (i+byt >= srcLen) break;
            unsigned char curr = ((working[i+byt] << (8-ix)) & 0x3F);
            if (i+nib < srcLen) curr |= ((working[i+nib] >> ix) & 0x3F);
            [dest appendFormat:@"%c", base64[curr]];
        }
    }
    return dest;
}

+ (NSString*)base64encode:(NSString*)str
{
    if ([str length] == 0)
        return @"";
    const char *source = [str UTF8String];
    NSInteger strlength  = strlen(source);
    char *characters = malloc(((strlength + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    NSUInteger i = 0;
    while (i < strlength) {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < strlength)
            buffer[bufferLength++] = source[i++];
        characters[length++] = base64[(buffer[0] & 0xFC) >> 2];
        characters[length++] = base64[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = base64[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = base64[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    NSString *g = [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] ;
    return g;
}

//base64 解密
+ (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:nil];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)base64[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}


//***********************************************************************************************************
//  Function      : generateCRC32Table
//
//  Description   : Generates a lookup table for CRC calculations using a supplied polynomial.
//
//  Declaration   : void generateCRC32Table(uint32_t *pTable, uint32_t poly);
//
//  Parameters    : pTable
//                    A pointer to pre-allocated memory to store the lookup table.
//
//                  poly
//                    The polynomial to use in calculating the CRC table values.
//
//  Return Value  : None.
//***********************************************************************************************************
void generateCRC32Table(uint32_t *pTable, uint32_t poly)
{
    for (uint32_t i = 0; i <= 255; i++)
    {
        uint32_t crc = i;
        
        for (uint32_t j = 8; j > 0; j--)
        {
            if ((crc & 1) == 1)
                crc = (crc >> 1) ^ poly;
            else
                crc >>= 1;
        }
        pTable[i] = crc;
    }
}

//***********************************************************************************************************
//  Method        : crc32
//
//  Description   : Calculates the CRC32 of a data object using the default seed and polynomial.
//
//  Declaration   : -(uint32_t)crc32;
//
//  Parameters    : None.
//
//  Return Value  : The CRC32 value.
//***********************************************************************************************************
-(uint32_t)crc32
{
    return [self crc32WithSeed:DEFAULT_SEED usingPolynomial:DEFAULT_POLYNOMIAL];
}

//***********************************************************************************************************
//  Method        : crc32WithSeed:
//
//  Description   : Calculates the CRC32 of a data object using a supplied seed and default polynomial.
//
//  Declaration   : -(uint32_t)crc32WithSeed:(uint32_t)seed;
//
//  Parameters    : seed
//                    The initial CRC value.
//
//  Return Value  : The CRC32 value.
//***********************************************************************************************************
-(uint32_t)crc32WithSeed:(uint32_t)seed
{
    return [self crc32WithSeed:seed usingPolynomial:DEFAULT_POLYNOMIAL];
}

//***********************************************************************************************************
//  Method        : crc32UsingPolynomial:
//
//  Description   : Calculates the CRC32 of a data object using a supplied polynomial and default seed.
//
//  Declaration   : -(uint32_t)crc32UsingPolynomial:(uint32_t)poly;
//
//  Parameters    : poly
//                    The polynomial to use in calculating the CRC.
//
//  Return Value  : The CRC32 value.
//***********************************************************************************************************
-(uint32_t)crc32UsingPolynomial:(uint32_t)poly
{
    return [self crc32WithSeed:DEFAULT_SEED usingPolynomial:poly];
}

//***********************************************************************************************************
//  Method        : crc32WithSeed:usingPolynomial:
//
//  Description   : Calculates the CRC32 of a data object using supplied polynomial and seed values.
//
//  Declaration   : -(uint32_t)crc32WithSeed:(uint32_t)seed usingPolynomial:(uint32_t)poly;
//
//  Parameters    : seed
//                    The initial CRC value.
//
//                : poly
//                    The polynomial to use in calculating the CRC.
//
//  Return Value  : The CRC32 value.
//***********************************************************************************************************
-(uint32_t)crc32WithSeed:(uint32_t)seed usingPolynomial:(uint32_t)poly
{
    uint32_t *pTable = malloc(sizeof(uint32_t) * 256);
    generateCRC32Table(pTable, poly);
    
    uint32_t crc    = seed;
    uint8_t *pBytes = (uint8_t *)[self bytes];
    uint32_t length = [self length];
    
    while (length--)
    {
        crc = (crc>>8) ^ pTable[(crc & 0xFF) ^ *pBytes++];
    }
    
    free(pTable);
    return crc ^ 0xFFFFFFFFL;
}




@end



@implementation UIViewController(AfterLoad)

- (void)viewDidAfterLoad
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        
    }
}

@end


@implementation NSDictionary(DYObjectForKey)

-(NSString *)DWStringForKey:(id)key
{
    id object=[self objectForKey:key];
    
    if ([object isKindOfClass:[NSNull class]]||object ==nil)
    {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",object];
}

-(NSArray *)DWArrayForKey:(id)key
{
    id object=[self objectForKey:key];
    
    if (![object isKindOfClass:[NSArray class]])
    {
        return [NSArray array];
    }
    return object;
}

-(NSDictionary *)DWDictionaryForKey:(id)key
{
    id object=[self objectForKey:key];
    
    if (![object isKindOfClass:[NSDictionary class]])
    {
        return [NSDictionary dictionary];
    }
    return object;
}


@end

@implementation NSMutableDictionary(DWObjectKey)

-(void)DWSetObject:(id)object forKey:(id)aKey
{
    if (!object || object == nil || [object isKindOfClass:[NSNull class]]) {
        object = @"";
    }
    
    if (!aKey || aKey == nil || [aKey isKindOfClass:[NSNull class]]) {
        aKey = @"";
    }
    [self setObject:object forKey:aKey];
}


@end


@implementation UINavigationItem (CustomBackButton)

-(UIBarButtonItem *)backBarButtonItem{
    
    return [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
}

@end


@implementation UIView (nib)


+ (instancetype)createViewFromNibName:(NSString *)nibName
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    return [nib objectAtIndex:0];
}

+ (instancetype)createViewFromNib
{
    return [self createViewFromNibName:NSStringFromClass(self.class)];
}

@end

@implementation NSDate (dwEX)

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

@end


