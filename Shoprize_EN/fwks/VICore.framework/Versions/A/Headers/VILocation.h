//
//  VILocation.h
//  VICore
//
//  Created by mk on 13-2-25.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//
//
//   需要加载的包 : CoreLocation.framework

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <VICore/VIMacro.h>

/**
 * 这个是用于获得到当前的位置信息之后的回调函数
 */

typedef void (^ LocationFinished)(CLLocation *location, UIViewController *inv);

@interface VILocation : NSObject <CLLocationManagerDelegate>

/**
 * 默认的点，默认的点为 (0 ,0)
 **/
+ (CLLocation *)defaultPoint;

/**
 * 获取默认的Loation实例
 */
+ (VILocation *)location VI_DEPRECATED;

/**
 * 获取当前类的实例
 */
+ (VILocation *)instance;
/**
 * 开始定位，定位完成之后一定要调用 realRelease 否则容易造成泄露
 */
+ (void)locationIn:(UIViewController *)inController finish:(LocationFinished)finished;

/**
 * 最后的一次定位的点
 */
+ (CLLocation *)lastPoint;

/**
 * 调用完成之后做释放操作
 */
+ (void)realRelease;

/**
 * 从新更新位置服务,只能在一个Controller中使用
 */
- (void)updateNewLocationAndCallBack:(LocationFinished)back;

/**
 * 在后台更新位置服务
 */
- (void)updateLocationInBackGround;

@end

// Cllocation的扩展函数
@interface CLLocation (ExtraMthod)

- (NSString *)latStrVal;
- (NSString *)lonStrVal;

- (float)latVal;
- (float)lonVal;

@end
