//
//  VIUtilsViewController.h
//  VICore
//
//  Created by mk on 13-5-17.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>

// 确认的回调
typedef void (^ ConfirmBack)(BOOL isOk);
// Alert的回调
typedef void (^ AlertCallBack)(int btnIndex, NSString *text);

typedef enum { T_Long  , T_Middle , T_Short } VI_TIME;
typedef enum { M_ERROR , M_INFO  , M_WARING } VI_MType;

/**
 *    集合的类
 *    @author mk
 */
@interface VIUtilsViewController : UIViewController

/**
 *    显示确认对话框
 *    @param t 标题
 *    @param msg 消息内容
 *    @param callback 回调函数
 */
- (void)showConfirmWithTitle:(NSString *)t msg:(NSString *)msg callbk:(ConfirmBack)callback;

/**
 *    用三个按钮的内容
 *    @param title 标题
 *    @param msg 标题内容
 *    @param callback 回调函数
 */
- (void)showConfirm3With:(NSString *)title msg:(NSString *)msg callbk:(ConfirmBack)callback;

/**
 *    显示弹出的Alert框
 *    @param title 标题
 *    @param actions 按钮的title
 *    @param callback 回调函数
 */
- (void)showAlert:(NSString *)title btns:(NSArray *)actions callbk:(AlertCallBack)callback;

/**
 *    显示弹出的Alert框
 *    @param title 标题
 *    @param actions 按钮的title
 *    @param callback 回调函数
 */
- (void)showActionSheets:(NSString *)title btns:(NSArray *)actions callbk:(AlertCallBack)callback;

/**
 *    弹出一个错误提示框
 *    @param msg 标题内容
 */
- (void)showPopErrorMsg:(NSString *)msg;
- (void)showPopInfoMsg:(NSString *)msg;
- (void)showPopWarningMsg:(NSString *)msg;
- (void)showPopMsg:(VI_MType)type msg:(NSString *)msg time:(VI_TIME)time;

- (void)showAlertMsg    :(id)stringOrDict;
- (void)showAlertError  :(id)stringOrDict;

/**
 * 这个函数判断的东西有点多
 * 1. "",nil,"  ", 返回 ture
 * 2. [] , {} 返回 true
 * 3. [NSNull null] 返回 true
 */
+ (BOOL)isEmpty:(id)value;

- (void)doNothing:(id)onOption;


/** HTTP 网络请求的一些方法 */
- (void)httpPostInViewApi:(NSString *)api args:(id)args succ:(SEL)succ;
- (void)httpGetInViewApi :(NSString *)api args:(id)args succ:(SEL)succ;
- (void)httpPostInViewApi:(NSString *)api args:(id)args;
- (void)httpGetDoNothing :(NSString *)api args:(id)args;
- (void)httpPostDoNothing:(NSString *)api args:(id)args;


@end

/*!
 * inner class 
 */
@interface AlertClassDelegate : NSObject <UIAlertViewDelegate, UIActionSheetDelegate>

@property(copy) ConfirmBack callback;
@property(copy) AlertCallBack alertBack;
@end

