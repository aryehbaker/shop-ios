//
//  UIButton+VTExtra.h
//  VTCore
//  Button 的扩展集合
//  Created by mk on 13-3-8.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VICore/VICore.h>

@interface UIButton (Extra)

//设置颜色
- (void)setTitleColor:(NSString *)color hightColor:(NSString *)hightcolor;

- (void)setImage:(NSString *)normal hightImg:(NSString *)hightlight;

- (void)setTitle:(NSString *)normal hightTitle:(NSString *)hightlight;

- (void)addTarget:(id)target action:(SEL)action;

@end

@interface VTButton : UIButton

//通过 设置框/字体/标题
- (id)initWith:(CGRect)frame font:(UIFont *)ft title:(NSString *)title;

//通过 设置框/背景/标题
- (id)initWith:(CGRect)frame byBgImg:(NSString *)imageName title:(NSString *)title;

//通过 坐标/背景/标题
- (id)initWith:(CGPoint)point sizeWithBg:(NSString *)img title:(NSString *)title;

@end