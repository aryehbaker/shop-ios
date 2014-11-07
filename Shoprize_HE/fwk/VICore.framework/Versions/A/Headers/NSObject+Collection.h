//
//  NSObject+Collection.h
//  VICore
//
//  Created by vnidev on 8/20/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import <Foundation/Foundation.h>




#ifndef PAGE_DEF
#define PAGE_DEF

    typedef enum {  ORDER_ASC = 1 << 0, ORDER_DESC = 1 << 1 } ORDER; //排序的类型

    #define PAGE_ONE  [NSNumber numberWithInt:1]
    #define PAGE_ZERO [NSNumber numberWithInt:0]
    // 加一页
    #define PAGE_ADD(page) (page = [NSNumber numberWithInt:[page intValue] + 1])
#endif


@interface NSObject (Collection)

- (BOOL)isArray;

- (BOOL)isDictionary;

- (long)hashLongValue;  /**   获取当前对象的hash值  @returns 返回这个对象的hash值 */

@end


@interface NSArray (Extra)

- (NSString *)jsonString; /** 把 array 对象转化为 json 字符串 */

@end

@interface NSData (Extra)

/**  把 NSData 对象转化为 String 字符串 */
- (NSString *)stringValue;

- (id)jsonVal:(NSError **)error;

@end


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

@interface NSUserDefaults (Extra)

+ (id)getObjectForKey:(NSString *)key;  /* 的到的有JSON String NSArray 等 */

+ (id)getObjectForKey:(NSString *)key forPath:(NSString *)path;

+ (void)insertObject:(id)value forKey:(NSString *)key;

+ (void)removeObjectForKey:(NSString *)key;


+ (NSString *)getValue:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;

+ (void)setValue:(NSString*)value forKey:(NSString *)key;
+ (void)setBool:(BOOL)value forKey:(NSString *)key;

@end


