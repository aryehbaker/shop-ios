//
//  UIViewController+Location.h
//  VICore
//
//  Created by vnidev on 8/27/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UIViewController (Location)

- (void)startLocationCall:(void(^)(BOOL isOK,CLLocation *location))call;

+ (CLLocation *)defaultPoint;

- (CLLocation *)lastPoint;

@end

// Cllocation的扩展函数
@interface CLLocation (ExtraMthod)

- (NSString *)latStrVal;
- (NSString *)lonStrVal;

- (double)latVal;
- (double)lonVal;

@end