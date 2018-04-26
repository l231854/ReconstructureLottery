//
//  DDUncaughtExceptionHandler.h
//  dada
//
//  Created by wayne on 16/4/13.
//  Copyright © 2016年 wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDUncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;
+ (void)uploadExceptionFile;

@end
