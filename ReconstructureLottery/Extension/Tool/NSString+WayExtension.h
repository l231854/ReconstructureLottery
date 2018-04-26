//
//  NSString+WayExtension.h
//  lottery
//
//  Created by 施小伟 on 2017/11/20.
//  Copyright © 2017年 施冬伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WayExtension)

-(NSString *)wayStringByAppendingPathComponent:(NSString *)str;
-(BOOL)isPureInt;
@end
