//
//  VIDrawImage.h
//  VICore
//
//  Created by Mac on 13-7-4.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface VIDrawImage : NSObject

+(UIImage *)drawLineOnImage:(UIImage *)img withPointsArray:(NSMutableArray *)pointArray with:(float)width;
//在一张图片上画传入路径的线，pointArray里面放NSString *pointStr = @"100,100"；类型坐标

+(UIImage *)drawImage:(CGSize)size withPointsArray:(NSMutableArray *)pointArray with:(float)width;//上画传入路径的线，pointArray里面放NSString *pointStr = @"100,100"；类型坐标，返回画好线的图片
+(UIImage *)addOnImage:(UIImage *)img withImage:(UIImage *)logo position:(CGPoint)point;//在一张img上面的一个位置画一张logo图片

+(UIImage *)addTextOnImage:(UIImage *)img text:(NSString *)text1 position:(CGPoint)point;//在图片的一个位置绘制文字

@end
