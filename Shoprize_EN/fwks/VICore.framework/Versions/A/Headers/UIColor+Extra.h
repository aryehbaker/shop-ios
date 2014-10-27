//
//  UIColor+Extra.h
//  VTCore
//
//  Created by mk on 13-2-27.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//对于类型的东西

@interface UIColor (Extra)

+ (UIColor *)colorWithR:(int)red g:(int)green b:(int)blue;

+ (UIColor *)colorWithR:(int)red g:(int)green b:(int)blue a:(float)alpha;

+ (UIColor *)blueToUse;

+ (UIColor *)redToUse;

@end
