//
//  VTUtils.h
//  VTCore
//
//  Created by mk on 13-8-23.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//
// 这个是网络操作的库

#import <Foundation/Foundation.h>

@interface VIUtils : NSObject

/**
 *    添加对应的崩溃日志报告
 *    会请求URL发送一个HTTPGet请求
 *      包含了如下信息:
 *          device : 设备ID信息
 *          reason : 崩溃的原因
 *          time   : 发生的时间
 *          name   : 异常的名字
 *          stack  : 异常发生的堆栈信息
 *    @param url  URL崩溃的地址
 */
+ (void)addCrashReport:(NSString *)url isPost:(BOOL)post;

/*!
 * 添加一个debug崩溃提示
 */
+ (void)addCrashMailDebug;

@end

