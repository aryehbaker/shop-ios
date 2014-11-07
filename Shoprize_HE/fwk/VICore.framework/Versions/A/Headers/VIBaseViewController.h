//
//  VIViewController.h
//  Coffee
//
//  Created by mk on 13-1-14.
//  Copyright (c) 2013年 Shenzhen Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIUtilsViewController.h"
#import "App.h"
#import "MKNetworkKit.h"
/**
 *    基础类
 *    @author mk
 */
@interface VIBaseViewController : VIUtilsViewController

@property(nonatomic,retain) HttpCfg         *defcfg;
@property(nonatomic,retain) NSMutableDictionary  *requests;

/**
 *    中间变量的处理
 *    @returns 获得2个Controller之间传递变量的值
 */
- (NSMutableDictionary *)contentValue;

/**
 *    获得某个路径下的值 比如：userinfo/0/userName
 *    @param path 路径
 *    @returns 返回存储的具体的值
 */
- (id)getContentValueWithPath:(NSString *)path;
- (id)contentValueForKey:(NSString *)path;
- (void)setValueToContent:(id)value forKey:(NSString *)key;

/**
 *    获得xib的内容
 *    @param xibName xib的名字
 *    @returns 获得返回的对象
 */
- (UIView  *)loadXib:(NSString *)xibName;
- (UIView  *)loadXib:(NSString *)xibName withTag:(int)tag;

+ (UIView  *)loadXibView:(NSString *)xibName;
+ (NSArray *)loadXibViews:(NSString *)xibName;
+ (UIView  *)loadXibView:(NSString *)xibName withTag:(int)tag;
/**
 *    进入下一个页面
 *    @param ctrler 类
 */
- (void)push:(UIViewController *)ctrler;

/**
 *    把某个类push到下一个页面中
 *    @param ctrlName 类名的字符串形式
 *    @param isnib 是否是xib模式
 *    @param data 传递过去的数据，默认都是以ctrlName 作为Key
 */
- (void)push:(NSString *)ctrlName isNib:(BOOL)isnib;
- (void)push:(NSString *)ctrlName isNib:(BOOL)isnib data:(id)data;
- (void)pushTo:(NSString *)ctrlClassNameWithNoXib;
- (void)pushTo:(NSString *)ctrlClassNameWithNoXib data:(id)data;

/**
 *    弹出到上一个界面，是否带动画
 *    @param animation YES带动画
 */
- (void)pop:(BOOL)animation;
- (void)pop;

/**
 *    弹回到某个具体的Controller
 *    @param ctrlName controller的名字
 */
- (void)popTo:(NSString *)ctrlName;

/**
 * 弹出某个Controller
 * @param     controller 需要显示的框架
 */
- (void)presentModalViewController:(UIViewController *)controller;
- (void)dismissModalViewController;

/**
 * 影藏下方的工具条
 */
- (void)hideTabBar:(BOOL)hide;

/**
 * 保存登陆用户的信息
 * @param userInfo 用户信息
 */
- (void)saveUserInfo:(NSDictionary *)userInfo;

- (NSDictionary *)getLoginInfo;

/**
 * 注销当前用户信息
 */
- (void)logout;

/**
 * 判断用户是否已经登陆
 * @return YES 如果已经登陆
 */
- (BOOL)userHadLogin;

/**
 * 添加键盘的通知事件
 */
- (void)addKeyboardNotify;

/**
 * 键盘将被弹起的事件，在这个之前请先调用 addKeyboardNotify
 * 键盘的落下事件
 * @param notify 通知
 * @param showTime 动画切换时间
 * @param frame 键盘显示的显示的大小
 */
- (void)_keyboard_WillShow:(NSNotification *)notify withBoardFrame:(CGRect)frame showTime:(NSTimeInterval)time;
- (void)_keyboard_WillHide:(NSNotification *)notify showTime:(NSTimeInterval)time;


#pragma mark 扩展函数

- (void)startLoading;
- (void)startLockLoading;
- (void)stopLoading;

- (void)setCfg:(HttpCfg*)cfg;

- (void)post:(NSString*)url args:(id)args complete:(void(^)(BOOL iscomplete,id resp))complete;
- (void) get:(NSString*)url args:(id)args complete:(void(^)(BOOL iscomplete,id resp))complete;
- (void)down:(NSString*)url args:(id)args toFile:(NSString *)path progress:(MKNKProgressBlock)progress;
- (void)stopReqIn:(UIViewController *)ctrl;

@end

