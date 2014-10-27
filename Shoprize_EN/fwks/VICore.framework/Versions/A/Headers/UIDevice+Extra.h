//
//  UIDevice+Extra.h
//  VTCore
//
//  Created by mk on 13-9-12.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,IOS) { IOS7 = 7,IOS6 = 6,IOS5 = 5,IOS4 = 4 };

@interface UIDevice (Extra)

/*!
 * return the int value of the current version 
 * if the version like 6.1.3 will return 6
 */
+(int)iosVersion;

/*!
 * will return YES if the IOSV is greater than system version
 * @param IOSV the version will test
 */
+(BOOL)isGt:(int)IOSV;

/*!
 * will return YES if the IOSV is greater or equals with system version
 * @param IOSV the version will test
 */
+(BOOL)isGe:(int)IOSV;

@end
