//
//  NSString+Extra.h
//  VTCore
//
//  Created by mk on 13-2-20.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *    字符串的扩展
 *    @author mk
 */

#ifndef __NSString_Extra
#define __NSString_Extra

#endif

@interface NSString (Extra)

#pragma mark  颜色操作

- (UIColor *)hexColor;                  /** 获取字符串的16进制的颜色 */
- (UIColor *)hexColorAlpha:(float)alpha;    /* 获取带透明度的颜色 */
- (UIColor *)imageColor; /* 获得图片的shitu */

#pragma mark 图像操作

- (UIImage *)image;
- (UIImageView *)imageView; /** 获得对应的图片View */
- (UIImageView *)imageViewForImgSizeAtX:(float)x Y:(float)y; /* 根据的图片的大小自定义内容，然后放回ImageView */

#pragma mark 日期出来函数
- (NSDate *)parse:(NSString *)format;   /** 把字符串转化为日期  */
- (NSDate *)parseDefalut;               /** 转化为默认的日期 yyyy-MM-dd */


#pragma mark 文件操作
- (NSString *)bundlePath;       /** 获取所在的 bundle路径  */
- (id)jsonVal;                  /** 字符串的JSON值 */
- (id)jsonOfBundleFile;         /* 获得 在 mainBunlde 中的对应文件名的的Json值 */
- (id)jsonOfFilePath;           /* 获得指定路径文件的Json值 */
- (id)contentOfBunlde;            /* 获取Bundle的文件内容 */
- (id)contentOfFile;              /* 获得文件路径的文本   */

#pragma mark 多语言操作
- (NSString *)lang;                     /* 获取当前语言的内容 */
- (NSString *)lang:(NSString *)desc;    /* 获取当前语言的内容 */

#pragma mark 字符串操作
+ (NSString *)randString;               /** 生成随机的字符串  */
- (NSInteger)indexOf:(NSString *)str;   /** 查询一个字符串是否在字符串中，不在则返回-1 */
- (BOOL)hasString:(NSString *)instr;    /* 是否包含字符串 */
- (NSString *)trim;                     /** 去除前后的空格 */
- (BOOL)hasText;                        /* [true : ' ','ab'],[false: '',nil,null ] */
- (BOOL)isBlank;                        /* [true : 'ab'],[false: ' ','',nil,null ]  */
- (NSString *)contact:(NSString *)first,... NS_REQUIRES_NIL_TERMINATION; //把多个字符串拼接成一个

#pragma mark  URL底子相关操作
- (NSString *)uriEncode;    /** 获得对应的String对象 */
- (NSURL *)urlEncode;       /** 获得对应的URL对象 */
- (NSURL *)netImageURL;  /* 获取网络图片地址 */
- (NSString *)netImage;  /*  网络图片地址 */

#pragma mark 扩展类
+ (NSString *)complieTemp:(NSString *)fmt data:(id)data;

- (void)openTelLink;    /** 打开连接文件 :直接传电话 */
- (void)openText;       /* 直接打开内容 */

#pragma mark 自定表格相关
- (BOOL)isPng;      /** 判断这个字符串是不是图片文件。 判断标准： 以.png 结尾 */
- (BOOL)isColor;    /** 判断这个字符串是不是#000000形式的颜色值。*/
- (BOOL)isNone;     /** 判断这个字符串是不是 none 值 */
- (BOOL)isYES;      /** 判断某个字符串是否为YES */
- (BOOL)isHttp;

@end

