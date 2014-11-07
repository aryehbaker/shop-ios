//
//  NSDate+Extra.h
//  VTCore
//
//  Created by mk on 13-2-20.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Extra.h"

#define VI_Format_Y_M_D		@"yyyy-MM-dd"
#define VI_Format_YMD		@"yyyyMMdd"
#define VI_Format__Y_M_D_Hm @"yyyy-MM-dd HH:mm"

@interface NSDate (Extra)

/**
 *    格式化一个日期为字符串
 *    @param format 格式化字符串格式
 *    @returns 值
 */
- (NSString *)format:(NSString *)format;
- (NSString *)formatDefalut;

- (NSDate *)addDay:(int)day;
- (NSDate *)addHour:(int)hour;
- (NSDate *)addMins:(int)mins;
- (NSDate *)addSecond:(int)second;


/*! 获取某个日期的年份 */
- (int)yearValue;

/*! 获取某个日期的月份 */
- (int)monthValue;

/*! 获取某个日期的日 */
- (int)dayValue;

/*! 获取某个时间的小时值 */
- (int)hourValue;

/*! 获取某个分钟值的分钟值 */
- (int)minuteValue;

/*! 获取某个分钟值的秒值 */
- (int)secondValue;

/*! 获得当前月份的最大的天数 */
- (int)maxDayOfMonth;

/*! 获得当前日期是第几周 */
- (int)weekIndex;

/*! (0 周一，1：周二，2 周三 ，3 周四 4 周五，5 周六，6周日）*/
- (int)weekValue;

/*! 获得当前日期中一共有多少周 */
- (int)maxWeeksOfYear;

/**
 *    返回系统的当前时间
 *    @returns 返回NSDate类型的
 */
+ (NSDate *)now;

/**
 * 获取默认的Calendar对象
 */
+ (NSCalendar *)calendar;

@end

