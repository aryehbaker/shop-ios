//
// Created by mk on 13-2-22.
//
// To change the template use AppCode | Preferences | File Templates.
//
//
//  代码例子：
//  [VIUpdateView checkUpdate:@"https://itunes.apple.com/cn/app/ibooks/id364709193?mt=8"];
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol VIUpdateDelegate;

@interface VIUpdateView : UIView <UIAlertViewDelegate>
@property(nonatomic,assign) id<VIUpdateDelegate> delegate;
/**
*  检查本地版本更新，用于Adhoc 阶段，调试的实话调用本地的APP程序
*  localUrl : 这个是本地的服务端的APP地址也可以为Apple的更新到地址
*/
+ (void)checkUpdate:(NSString *)localUrl;

/**  这个是强制检查更新操作,在后台强制做更新用的 */
+ (void)checkUpdateForce:(NSString *)localUrl;

+ (void)checkUpdate:(NSString *)localUrl delegate:(id<VIUpdateDelegate>)delegate;
+ (void)checkUpdateForce:(NSString *)localUrl delegate:(id<VIUpdateDelegate>)delegate;

//弹出信息内容
- (void)showUpdateAlertView:(NSString *)text updateUrl:(NSString *)url newVersion:(NSString *)verson;

@end

@protocol VIUpdateDelegate <NSObject>

/* 检查更新操作是否需要谈出框 */
- (void)checkResultIfNeedShowAlert:(NSDictionary *)serverinfo inView:(VIUpdateView*)view;

- (BOOL)isSilence;

@end