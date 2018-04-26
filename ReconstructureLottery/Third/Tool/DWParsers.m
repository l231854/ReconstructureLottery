//
//  CSParsers.m
//  Cha4Online
//
//  Created by apple1 on 14-2-28.
//  Copyright (c) 2014年 cha4. All rights reserved.
//

#import "DWParsers.h"

@implementation DWParsers

#pragma mark -------------------------------根据类名实例化对象并将对应属性赋值
+ (id)getObjectByObjectName:(NSString*)objectName andFromDictionary:(NSDictionary*)dictionary
{
    if (![self isExitClassName:objectName])
    {
        DLog(@"反射对象：%@，不存在！",objectName);
        return nil;
    }
    if ([self isNullDictonary:dictionary])
    {
        return nil;
    }
    id mClass =[self getIdForClassName:objectName];
    [self setObject:mClass forAttribute:dictionary];
    return mClass;
}

#pragma mark -------------------------------根据类名实例化对象数组并将对应属性赋值
+ (NSArray*)getObjectListByName:(NSString*)objectName fromArray:(NSArray*)array
{
        if (![self isExitClassName:objectName])
        {
            DLog(@"反射对象：%@，不存在！",objectName);
            return nil;
        }
        
        NSMutableArray* list =[[NSMutableArray alloc]init];
        @try
        {
                if (array.count<1)
                {
                    return list;
                }
                for (NSMutableDictionary* dic in array)
                {
                        if ([self isNullDictonary:dic])
                        {
                        }
                        else
                        {
                                id mObj=[self getObjectByObjectName:objectName andFromDictionary:dic];
                                if (mObj)
                                {
                                    [list addObject:mObj];
                                }
                         }
                }
        }
        @catch (NSException *exception)
        {
        }
        return list;
}



#pragma mark -------------------------------判断类名是否存在
+(BOOL)isExitClassName:(NSString*)className
{
    Class mClass = NSClassFromString(className);
    return mClass?YES:NO;
}

#pragma mark -------------------------------判断字典是否为空
+(BOOL)isNullDictonary:(NSDictionary*)dic
{
    if (!dic || dic ==nil)
    {
        return YES;
    }
    else
    {
            @try
            {
                if ([dic respondsToSelector:@selector(allKeys)])
                {
                        NSArray * keys =[dic allKeys];
                        if (keys.count>0)
                        {
                            return NO;
                        }
                        else
                        {
                            return YES;
                        }
                }
                else
                {
                    return YES;
                }
                
        }
        @catch (NSException *exception)
        {
            return YES;
        }
    }
    
}

#pragma mark -------------------------------通过类名实例对象
+(id)getIdForClassName:(NSString*)className
{
    id myObj = [[NSClassFromString(className) alloc] init];
    return myObj;
    
}

#pragma mark -------------------------------属性填充
+(void)setObject:(id)obj forAttribute:(NSDictionary*)attribute
{
    NSArray* keys =nil;
    @try
    {
        if (attribute && [attribute respondsToSelector:@selector(allKeys)])
        {
            keys =[attribute allKeys];
        }
    }
    @catch (NSException *exception)
    {
        DLog(@"获取对象属性出错!");
    }
    
    if (!keys || keys.count < 1)
    {
        return;
    }
    
    @try
    {
            for (NSString* key in keys)
            {
                id value = [attribute valueForKey:key];
                id  stringValue;
                if ([value isKindOfClass:[NSString class]]||[value isKindOfClass:[NSDictionary class]]||[value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSMutableArray class]])
                {
                    stringValue = value;
                }
                if ([value respondsToSelector:@selector(stringValue)])
                {
                    stringValue = [value stringValue];
                }
                    @try
                    {
                        [obj setValue:stringValue forKey:key];
                    }
                    @catch (NSException *exception)
                    {
                        DLog(@"对象没有属性：%@",key);
                    }
            }
    }
    @catch (NSException *exception)
    {
        DLog(@"setObjectAttribute...属性填充异常!");
    }
}


@end
