//
//  NSDictionary+Extra.h
//  VTCore
//
//  Created by mk on 13-2-20.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Extra.h"

typedef enum {
    ORDER_ASC, ORDER_DESC
} ORDER; //排序的类型

#define _MAry  [NSMutableArray array]
#define _Ary   [NSArray array]

@interface NSDictionary (Extra)

- (id)objectForPath:(NSString *)aPath;

- (NSString *)jsonString;

- (BOOL)isMutable;

- (NSDictionary *)showData;

- (NSArray *)alphaAscKeys;

- (NSArray *)alphaOrderKeysWith:(ORDER)isasc;

- (NSArray *)numberOrderAscKeys;

- (NSArray *)numberOrderKeysWith:(ORDER)isasc;

- (NSString *)objectForKeyAndNoneNull:(NSString *)key;

- (BOOL)boolValueForKey:(NSString *)key;

- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

- (int)intValueForKey:(NSString *)key;

- (int)intValueForKey:(NSString *)key defaultValue:(int)defaultValue;

- (time_t)timeValueForKey:(NSString *)key;

- (time_t)timeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;

- (NSDate *)dateValueForKey:(NSString *)key;

- (NSDate *)dateValueForKey:(NSString *)key withFomate:(NSString *)ftmate;

- (long long)longLongValueForKey:(NSString *)key;

- (long long)longLongValueForKey:(NSString *)key defaultValue:(long long)defaultValue;

- (NSString *)stringValueForKey:(NSString *)key;

- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

- (NSDictionary *)dictionaryValueForKey:(NSString *)key;

- (NSArray *)arrayValueForKey:(NSString *)key;

- (double)doubleValueForKey:(NSString *)key;

- (double)doubleValueForKey:(NSString *)key defaultValue:(double)defaultValue;

@end
