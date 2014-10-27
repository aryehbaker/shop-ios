//
//  UILabel+VTExtra.h
//  VTCore
//
//  Created by mk on 13-3-7.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VICore/VICore.h>

//排序的居中方式
typedef NS_ENUM(NSInteger, ALIGN){

    LEFT,   //左对齐
    CENTER, //居中对齐
    RIGHT   //右对齐

};

@interface UILabel (Extra)

//设置格式话参数
-(void)setTextFmt:(NSString *)fmt , ... ;

@end


@interface VILabel : NSObject

/**
 * 初始化一个Lable
 *     1.用透明的背景
 *     2.color 作为前景色
 *     3.居中对其
 *     4.14号字体
 **/

+ (UILabel *)createLableWithFrame:(CGRect)frame color:(NSString *)color font:(UIFont *)ft align:(ALIGN)align;

//多行文本
+ (UILabel *)createManyLines:(CGRect)frame color:(NSString *)color ft:(UIFont *)ft text:(NSString *)text;

@end