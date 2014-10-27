//
//  NSObject+Extra.h
//  VTCore
//
//  Created by mk on 13-2-20.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extra)

/**
 * 把一个字符串转化为NSArry，如果本身就是个array 则直接返回
 */
- (id)toArray;

- (id)toDict;

- (id)checkShowdataWithType:(__unsafe_unretained Class)cls;

- (BOOL)isArray;

- (BOOL)isDictionary;

/**   获取当前对象的hash值
 *    @returns 返回这个对象的hash值
 */
- (long)hashLongValue;

- (void)setValue2UserDefault:(id)value forKey:(NSString *)key;
- (id)getValueFromUserDefault:(NSString *)key;

@end

