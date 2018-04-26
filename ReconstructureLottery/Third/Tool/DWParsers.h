//
//  CSParsers.h
//  Cha4Online
//
//  Created by apple1 on 14-2-28.
//  Copyright (c) 2014年 cha4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWParsers : NSObject

+ (id)getObjectByObjectName:(NSString*)objectName andFromDictionary:(NSDictionary*)dictionary;
+ (NSArray*)getObjectListByName:(NSString*)objectName fromArray:(NSArray*)array;

@end
