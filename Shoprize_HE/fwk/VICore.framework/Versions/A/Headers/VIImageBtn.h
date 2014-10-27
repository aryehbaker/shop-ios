//
//  VIImageBtn.h
//  VICore
//
//  Created by mk on 13-5-7.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *    自定的按钮
 *    @author mk
 */
@interface VIImageBtn : UIView

-(id)initWithFrame:(CGRect)frame icon:(NSString *)icon text:(NSString *)text margin:(int)top split:(int)split;

/**
 *    按钮的内部变量
 */
@property(nonatomic, retain) UIButton *button;
@property(nonatomic, retain) UILabel  *buttonLabel;

/**
 *    设置按钮的背景图片
 *    @param image 图片的名字
 */
- (void)setBackgroundWithImg:(NSString *)image;

/**
 *    设置图片的背景
 *    @param img 图片
 *    @param frame 位置
 */
- (void)setButtonIcon:(NSString *)img frame:(CGRect)frame;

/**
 *    设置图片上面的文字
 *    @param text 文字
 *    @param color 颜色
 *    @param frame 位置
 */
- (void)setButtonText:(NSString *)text color:(NSString *)color frame:(CGRect)frame;



@end

