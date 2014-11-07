//
//  VIAlertView.h
//  Coffee
//
//  Created by CaRREY on 13-1-18.
//  Copyright (c) 2013年 Shenzhen Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
* 系统默认的弹出信息对话框的封装
*/
@interface VIAlertView : UIAlertView <UIAlertViewDelegate, UIActionSheetDelegate>

/**
* 仅显示一个对话框，和一个取消按钮
*/
+ (void)showMessageWithTitle:(NSString *)t msg:(NSString *)msg;

/*! 显示一条 错误消息 @param msg 消息 */
+ (void)showErrorMsg:(NSString *)msg;

/*! 显示一条消息 @param msg 消息 */
+ (void)showInfoMsg:(NSString *)msg;

/*! 显示一条警告消息  @param msg 消息 */
+ (void)showWarningMsg:(NSString *)msg;

/*! 显示一条警告消息  @param error error对象 */
+(void)showErrorObj:(NSError *)error;

/*! 显示一条警告消息  @param errdict errdic里面要包含 message Key */
+(void)showErrorDict:(NSDictionary *)errdict;


@end
