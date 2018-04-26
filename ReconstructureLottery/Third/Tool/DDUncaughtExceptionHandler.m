//
//  DDUncaughtExceptionHandler.m
//  dada
//
//  Created by wayne on 16/4/13.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import "DDUncaughtExceptionHandler.h"

#ifdef DAILY
#define ISDAILY YES

#else
#define ISDAILY NO

#endif

@implementation DDUncaughtExceptionHandler


#pragma mark- path && name

NSString *applicationDocumentsDirectory() {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

NSString *exceptionFileName(){
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVrsion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *fileName = [NSString stringWithFormat:@"exception-ios-dada-%@%@.%@",currentVrsion,ISDAILY?@"-daily":@"",exceptionFileType()];
    return fileName;
    
}

NSString *exceptionFileType(){
    
    return @"txt";
}

NSString *exceptionFilePath(){
    
    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:exceptionFileName()];
    return path;
}


#pragma mark- handle

+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}

void UncaughtExceptionHandler(NSException *exception) {
    
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVrsion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    NSString *text = [NSString stringWithFormat:@"=============异常崩溃报告=============\n名称:\n%@\n\n设备版本:\n%@\n\n软件版本:\n%@\n\n原因:\n%@\n\n描述:\n%@\n",
                     name,[UIDevice currentDevice].systemVersion,appVrsion,reason,[arr componentsJoinedByString:@"\n"]];
    NSString *path = exceptionFilePath();
    
    
    /**
     *  判断文件是否已经存在
     */
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    
    if ([fileManager fileExistsAtPath:path]) {
        
        NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];
        [handle seekToEndOfFile];
        NSData * dataFile = [[NSString stringWithFormat:@"\n\n%@",text] dataUsingEncoding:NSUTF8StringEncoding];
        [handle writeData:dataFile];
        [handle closeFile];
        
    }else{
        
        [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
}

+ (NSUncaughtExceptionHandler*)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

+ (void)uploadExceptionFile
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *path = exceptionFilePath();
        NSFileManager * fileManager = [NSFileManager defaultManager];
        
        if ([fileManager fileExistsAtPath:path]) {
            
            [DDUncaughtExceptionHandler queryUploadTokenByFilePath:path];
        }
    });
    
}

+(void)deleteExceptionFile
{
    
    NSString *path = exceptionFilePath();
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        
        NSError * error;
        if (![fileManager removeItemAtPath:path error:&error]) {
            DLog(@"删除Exception文件失败");
        }
    }
}

#pragma mark- network

+(void)queryUploadTokenByFilePath:(NSString *)filePath
{
    
    NSURL *fileurl = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileurl];
    NSURLResponse *repsonse = nil;
    NSData *fileData = [NSURLConnection sendSynchronousRequest:request returningResponse:&repsonse error:nil];
    if (!repsonse) {
        return;
    }
    uint32_t crc = [fileData crc32];
    NSUInteger length = [fileData length];
    
    NSMutableString * fileName = [[NSMutableString alloc]initWithString:exceptionFileName()];
    NSRange rangeType = [fileName rangeOfString:[NSString stringWithFormat:@".%@",exceptionFileType()]];
    if (rangeType.length>0) {
        
        NSString * typeString = [fileName substringWithRange:rangeType];
        [fileName deleteCharactersInRange:rangeType];
        NSDate * date = [NSDate date];
        NSDateFormatter * format = [[NSDateFormatter alloc]init];
        [format setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
        NSString *dateTime = [format stringFromDate:date];
        [fileName appendFormat:@"-%@%@",dateTime,typeString];

    }
    NSMutableDictionary * params = [NSMutableDictionary new];
    [params setObject:@"1.0" forKey:@"v"];
    [params setObject:@"1002" forKey:@"bizCode"];
    
    [params setObject:[NSString stringWithFormat:@"%lu",(unsigned long)length] forKey:@"size"];
    [params setObject:fileName forKey:@"fileName"];
    [params setObject:[NSString stringWithFormat:@"%u",crc] forKey:@"crc"];
    [params setObject:@"WIFI" forKey:@"clientNetType"];

//    
//    [DDNetwork operationWithAPIPath:@"mtop.sys.anonymousGetUploadToken" params:params complete:^(NSDictionary *dicInfo, BOOL isSuccess, NSString *errorMessage) {
//        
//        if (isSuccess) {
//            
//            [DDNetwork operationUploadFileWithServerAddress:[dicInfo DWStringForKey:@"serverAddress"] token:[dicInfo DWStringForKey:@"token"] fileData:fileData fileName:fileName mimeType:repsonse.MIMEType completed:^(NSString *fileUrl, BOOL isSuccess, NSString *errorMsg) {
//               
//                if (isSuccess) {
//                    [DDUncaughtExceptionHandler deleteExceptionFile];
//                }
//            }];
//            
//            
//            /*
//             {
//             maxBodyLength = 10000000;
//             retryCount = 1;
//             serverAddress = "file.api.zoneoto.cn:8063";
//             timeout = 30000;
//             token = 6334b5b253fcef2b6337a6179278a0ac;
//             }
//             */
//            
//        }else{
//            
//            [WSProgressHUD showImage:nil status:errorMessage];
//        }
//        
//    } failed:^(NSError *error,BOOL isCancelled) {
//        
//        [WSProgressHUD showImage:nil status:@"网络异常"];
//    }];
}


@end
