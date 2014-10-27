//
//  UIImageView+VTExtra.h
//  VTCore
//
//  Created by mk on 13-3-13.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (VTExtra)

/**
 * 获取某个视图的截屏视图
 */
+ (UIImageView*)screenshotForView: (UIView*) view;


+ (UIImage*)screenshotForView:(UIView*) view withFrame:(CGRect)frame;

@end
