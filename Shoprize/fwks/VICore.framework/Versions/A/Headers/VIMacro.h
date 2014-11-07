//
//  VIMacro.h
//  VICore
//
//  Created by vnidev on 4/23/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

/*!
 ## 2013-8-1 以前
 初始化整个Core的某些内容
 
 ## 2013-8-1
 更新MKNetworkKit库到最新版
 
 ## 2013-8-16
 更新了VIUtilsViewController 让请求在发送的过程中自动终止
 更改了HttpKit类的一些请求方式，增加了http的取消过程
 
 ## 2013-8-19
 增加了一些对应的Uiview的操作，包括宽带和位置的处理
 
 ## 2013-8-23
 更新了FMDB库的内容。
 去除了VIDate类，合并到了NSDate+Extra
 增加VISQLite类，但是没想好怎么写
 增加了对Crash报告的支持
 
 ## 2013-8-26
 去除了网络不稳定容易崩溃的问题
 修改Lang文件中，翻译失败导致的错误无法显示的问题
 
 ## 2013-9-12
 HttpKit 增加下载功能
 修改了一下CfgTableView
 
 ## 2013-9-27
 对AKTab进行修改，让他支持iOS7的特殊效果
 删除了不常用的AKTabBar的一些操作
 修改AKTab为 手动管理内存
 修改系统的崩溃
 
 ## 2013-10-14
 修改了了VICore的一些函数
 增加了View的内置的函数信息
 增加VIAlertView的一些内容
 完善的VIFile的一些类操作
 
 */

#ifndef VICore_VIMacro_h
#define VICore_VIMacro_h

#define VIVersion        @"1.1.2"
#define VIAuthor         @"monlyu.hong@gmail.com"

#define HEIGHT_OF_STATUS_BAR	([[UIApplication sharedApplication] statusBarFrame].size.height)
#define HEIGHT_OF_View          ([UIScreen mainScreen].applicationFrame.size.height)                //整个视图的高度
#define HEIGHT_OF_NAV_BAR		44                                                                  //导航栏的高度
#define HEIGHT_OF_TAB_BAR		49                                                                  //底部Tabbar的高度
#define HEIGHT_OF_SCREEN		([UIScreen mainScreen].bounds.size.height)                          //屏幕的高度

// 细体
#define VI_FONT_10				FontS(10)
#define VI_FONT_12				FontS(12)
#define VI_FONT_14				FontS(14)
#define VI_FONT_16				FontS(16)
#define VI_FONT_18				FontS(18)
#define VI_FONT_20				FontS(20)

// 粗体字
#define VI_FONT_B10				FontB(10)
#define VI_FONT_B12				FontB(12)
#define VI_FONT_B14				FontB(14)
#define VI_FONT_B16				FontB(16)
#define VI_FONT_B18				FontB(18)
#define VI_FONT_B20				FontB(20)

#define FontS(size)             [UIFont systemFontOfSize:size]
#define FontB(size)             [UIFont boldSystemFontOfSize:size]

/** 语言包 */
#define Lang(val) ([val lang])
#define Langc(val,comt) ([val lang])


// 打印当前的坐标标记
#define PRINT_FRAME(var)	(NSLog(@"X:%.1f Y:%.1f W:%.1f H:%.1f", var.origin.x, var.origin.y, var.size.width, var.size.height))

// 从var 坐标开始结束点剩余高度
#define Left_Space(var)     (HEIGHT_OF_View - (var))
#define yStart              ([UIDevice isGe:7] ? 20 : 0)

#pragma mark Frame的相关操作

#define FrmW(var)           (var.size.width)            // 求frame变量的宽
#define FrmH(var)           (var.size.height)           // 求frame变量的高
#define FrmX(var)           (var.origin.x)              // Frame的X坐标
#define FrmY(var)           (var.origin.y)              // frame 的y坐标
#define Frm(x,y,w,h)        CGRectMake(x,y,w,h)         //frame设置

#pragma mark 对应的RGB相关

// 定义RGBA模式
#define RGBA(r, g, b, a)	[UIColor colorWithRed : r / 255.0 green : g / 255.0 blue : b / 255.0 alpha : a]
#define RGB(r, g, b)    [UIColor colorWithRed : r / 255.0 green : g / 255.0 blue : b / 255.0 alpha : 1]
#define Color(hex)          [hex hexColor]

// 拼接字符串操作
#define FORMAT(format, ...) ([NSString stringWithFormat:format,##__VA_ARGS__])
#define Fmt(fmt,...)        ([NSString stringWithFormat:fmt,##__VA_ARGS__])

// 公共的宏定义 //判断相机是否可用
#define CAMERA_IS_AVAILABLE		[UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]
// 选择图片的来源
typedef enum { From_Album,/*相册*/ From_Camera,/*相机*/ From_Album_Camera /*相册或相机*/} IMAGE_FROM;
typedef enum { DONE,/*完成*/ CANCEL,/*取消*/ CLEAN /*清除*/} IMAGE_ACTION;

// 判断是不是4英寸屏幕
#define IS_RETINA_4     (HEIGHT_OF_SCREEN == 568)

#pragma mark iOS6 以上用 NSTextAlignmentCenter 来替代

// 文本居中
#ifdef __IPHONE_6_0 // iOS6 and later
#define VIAlignmentCenter    NSTextAlignmentCenter
#define VITextAlignmentLeft  NSTextAlignmentLeft
#define VITextAlignmentRight NSTextAlignmentRight
#else
#define VIAlignmentCenter    UITextAlignmentCenter
#define VITextAlignmentLeft  UITextAlignmentLeft
#define VITextAlignmentRight UITextAlignmentRight
#endif

// pragma mark 用于区分ARC和非ARC的程序
#ifndef VI_STRONG
#if __has_feature(objc_arc)
#define VI_STRONG	strong
#else
#define VI_STRONG	retain
#endif
#endif

#ifndef VI_WEAK
#if __has_feature(objc_arc_weak)
#define VI_WEAK weak
#elif __has_feature(objc_arc)
#define VI_WEAK unsafe_unretained
#else
#define VI_WEAK assign
#endif
#endif

#pragma mark 用于自动释放的

#if __has_feature(objc_arc)
#define VI_AUTORELEASE(exp)	exp
#define VI_RELEASE(exp)		exp
#define VI_RETAIN(exp)		exp
#else
#define VI_AUTORELEASE(exp)	[exp autorelease]
#define VI_RELEASE(exp)		[exp release]
#define VI_RETAIN(exp)		[exp retain]
#endif

#define   VI_DEPRECATED __attribute__((deprecated))


#endif


