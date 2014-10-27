//
//  NSString+Extra.h
//  VTCore
//
//  Created by mk on 13-2-20.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <VICore/VIKit.h>

/**
 *    字符串的扩展
 *    @author mk
 */
@interface NSString (Extra)

/**
 *    获取字符串的16进制的颜色
 *    @returns 颜色值
 */
- (UIColor *)hexColor;

/**
 *    获取带透明度的颜色
 *    @param alpha 透明度
 *    @returns 颜色值
 */
- (UIColor *)hexColorAlpha:(float)alpha;

/**
 *    [UIImage imageNamed:@""] 简写
 *    @returns 返回图片
 */
- (UIImage *)image;

/**
 *    获得图片的shitu
 *    @returns 图片文件
 */
- (UIColor *)imageColor;

/**
 *    获得对应的图片View
 *    @returns 返回图片视图
 */
- (UIImageView *)imageView;

/**
 * 根据的图片的大小自定义内容，然后放回ImageView
 * @param x 坐标X
 * @param y 坐标Y
 */
- (UIImageView *)imageViewForImgSizeAtX:(float)x Y:(float)y;

/**
 *    获取所在的 bundle路径
 *    @returns 获得对应的路径文件
 */
- (NSString *)bundlePath;

/**
 * 去除前后的空格
 */
- (NSString *)trim;

/**
 *    把字符串转化为日期
 *    @param format 格式
 *    @returns 日期函数
 */
- (NSDate *)parse:(NSString *)format;

/**
 *    转化为默认的日期 yyyy-MM-dd
 *    @returns 返回日期
 */
- (NSDate *)parseDefalut;

/**
 *    把一个日期字符串从一个格式转到另外一个格式
 *    @param ff 原日期格式
 *    @param to 目标日期格式
 *    @returns 目标日志值
 */
- (NSString *)dateTrasnpor:(NSString *)ff to:(NSString *)to;

/*!
 *  获得 在 mainBunlde 中的对应文件名的的Json值
 */
- (id)jsonOfBundleFile;

/*!
 *
 * 获得指定路径文件的Json值
 *
 */
- (id)jsonOfFilePath;

/*!
 *  获得对应文件的内容
 */
- (NSString *)valueOfFilePath;

/**
 *    字符串的JSON值
 *    @returns 把一个字符串直接返回一个json值
 */
- (id)jsonVal;

/**
 *    判断某个字符串是否为YES
 *    @returns 是否为YES
 */
- (BOOL)isYES;

/**
 *    是否包含字符串
 *    @param ofstr 字符串
 *    @returns 包含则返回 YES
 */
- (BOOL)hasString:(NSString *)ofstr;

/**
 *    打开连接文件
 */
- (void)openTelLink;

/**
 *    判断一个字符串是不是空
 *    @returns 为空则返回真
 */
- (BOOL)isEmpty;

/**
 *    获取网络图片地址
 *    @returns 返回网络图片地址
 */
- (NSURL *)netImageURL;

/**
 *    网络图片地址
 *    @returns 获得网络图片的地址
 */

- (NSString *)netImage;

/**
 *    通过一个
 *    @param value 构件一个快速的可变Dict
 *    @returns 可变的dict
 */
- (NSMutableDictionary *)dictWithValue:(id)value;

/**
 *    把当前当作值合并组成dict
 *    @param key key
 *    @returns
 */
- (NSMutableDictionary *)dictWithKey:(NSString *)key;

/**
 *    生成随机的字符串
 *    @returns 产生的随机字符串
 */
+ (NSString *)randString;

/**
 *    语言文件库
 *    @returns 返回语言包内容
 */
- (NSString *)lang;

/**
 *    一样的通商
 *    @param desc 描述字符串
 *    @returns 获取语言内容
 */
- (NSString *)lang:(NSString *)desc;

/**
 * 把一个标准的日期（2010-12-31T12:00:00 => 2010-12-31）转为不含T字母的字符串
 */
- (NSString *)toYMDDate;

/**
 * 查询一个字符串是否在字符串中，不在则返回-1
 */
- (int)indexOf:(NSString *)str;

/**
 *    获得对应的URL对象
 *    @returns 返回URL地址
 */
- (NSURL *)urlValue;

/**
 *   判断这个字符串是不是图片文件。
 *   判断标准： 以.png 结尾
 *    @returns BOOL
 */
- (BOOL)isPng;

/**
 *   判断这个字符串是不是#000000形式的颜色值。
 *    @returns BOOL
 */
- (BOOL)isColor;

/**
 *   判断这个字符串是不是 none 值
 *    @returns BOOL
 */
- (BOOL)isNone;

/**
 * 取日期前十位
 */
- (NSString *)sub10Date;

#pragma makr 过期的方法

/**
 *    获取 Document所在的文件夹
 *    @returns 文件夹路径
 *    请用 VTFile 代替
 */
- (NSString *)pathAtDocumentDir VI_DEPRECATED;

/**
 *    获取对应路径的JSON内容
 *    @returns 返回json内容
 */
- (id)jsonOfFileWithPath VI_DEPRECATED;

/**
 *    获取文件的值
 *    @returns 获取文件的json
 *    通过 jsonOfBundleFile 代替
 */
- (id)jsonOfFile VI_DEPRECATED;

@end

