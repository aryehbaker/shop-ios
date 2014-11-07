//
//  UIKit+Extra.h
//  VICore
//
//  Created by vnidev on 8/14/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <VICore/VICore.h>

@interface UIKit_Extra : NSObject

@end

@interface UIButton (Extra)

//设置颜色
- (void)setTextColor:(NSString *)normal selected:(NSString *)selected;
- (void)setTitle:(NSString *)normal selected:(NSString *)selected;
- (void)setTextFont:(UIFont *)font;

- (void)addImage:(NSString *)name atPoint:(CGPoint)p edge:(UIEdgeInsets)edge;

- (void)setImage:(NSString *)normal selectd:(NSString *)selectd;

- (void)addTarget:(id)target action:(SEL)action;
- (void)addClickEvt:(void(^)(UIButton *target))evt;

- (instancetype)initWithFrame:(CGRect)frame font:(UIFont *)ft title:(NSString *)title color:(NSString *)color;

@end

//排序的居中方式
typedef NS_ENUM(NSInteger, TxtOpt){
    LEFT    = 1 << 0,        /*左对齐*/
    CENTER  = 1 << 1 ,  /*居中对齐*/
    RIGHT   = 1 << 2 ,  /*右对齐*/
    
    START   = 1 << 3 ,  /* Trim 开头 */
    MIDDLE  = 1 << 4 ,  /* Trim 中间 */
    END     = 1 << 5    /* Trim end */
};

@interface UILabel (Extra)

- (void)setTextFmt:(NSString *)fmt , ... NS_REQUIRES_NIL_TERMINATION;  //设置格式话参数

+ (UILabel *)initWithFrame:(CGRect)frame color:(NSString *)color font:(UIFont *)ft align:(TxtOpt)align;

+ (UILabel *)initManyLineWithFrame:(CGRect)frame color:(NSString *)color font:(UIFont *)ft text:(NSString *)text;

- (void)setLineSpace:(int)space;

@end


#pragma make UITextField

@interface UITextField (Extra)

- (void)addLeftPadding:(int)px;

- (BOOL)isEmptyValue;

- (BOOL)isSameTextWith:(UITextField *)other;

- (void)setPlaceholder:(NSString *)placeholder font:(UIFont *)ft align:(TxtOpt)optn color:(NSString*)color placeColor:(NSString *)pcolor;

@end


@interface UIView (Extra)

- (CGFloat)endY;    /** 获得当前视图的结束点坐标 值为 frame 的 y + height */
- (CGFloat)endX;    /**  获得当前视图的结束点坐标 值为 frame 的 x + width */
- (CGFloat)X;       /** 获得当前视图的X坐标体系 */
- (CGFloat)x;
- (CGFloat)Y;       /** 获得当前视图的Y坐标体系 */
- (CGFloat)y;
- (CGFloat)H;   /** 获得当前视图的高度 */
- (CGFloat)h;
- (CGFloat)W;   /** 获得当前视图的宽度 */
- (CGFloat)w;
- (CGSize)size;     /** 获得View的大小 */

- (void)setBackgroundcolorByImage:(NSString *)imageName;    /** 更具图片的名字来设置背景颜色 */
- (void)setBackgroundcolorByHex:(NSString *)hexColor;       /** 更具Html的十六进制的代码来设置背景颜色 */

- (UIView *)setW:(float)width;
- (UIView *)setH:(float)height;
- (UIView *)setW:(float)width andH:(float)height;
- (UIView *)setWH:(CGSize)size;

- (UIView *)addW:(float)width;
- (UIView *)addH:(float)height;
- (UIView *)addW:(float)width andH:(float)height;

- (UIView *)setX:(float)x;
- (UIView *)setY:(float)y;
- (UIView *)setX:(float)x andY:(float)y;
- (UIView *)setXY:(CGPoint)point;
- (UIView *)setPositionCenteredOnPoint:(CGPoint)position;

- (UIView *)setCenterAt:(UIView *)view withY:(float)y;

- (UIView *)addX:(float)x;
- (UIView *)addY:(float)y;
- (UIView *)addX:(float)x andY:(float)y;

- (void)removeSubviews;             /** 删除当前视图的所有子视图  */
- (UIImage *)renderImageFromView;       /** 获得当前视图根据渲染获得的图像 */
- (UIImage *)renderImageFromViewWithRect:(CGRect)frame;/**获得当前视图根据渲染获得的图像 @param frame 根据某一部分来获得图像 */

/**   创建一个新按钮的线条 */
+ (UIView *)lineAtX:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h color:(NSString *)clor;
- (void)addInnerLineAtButtom:(NSString *)color h:(CGFloat)h;

- (void)addTapTarget:(id)target action:(SEL)sel;

/** 获得文本框 @param tag Tag值  */

- (UITextField *)textfiled4Tag:(int)tag;
- (UIButton *)button4Tag:(int)tag;
- (UILabel *)label4Tag:(int)tag;
- (UIImageView *)imageView4Tag:(int)tag;
- (EGOImageView *)egoimageView4Tag:(int)tag;
- (UISwitch *)switch4Tag:(int)tag;
- (UIProgressView *)progress4Tag:(int)tag;
- (UITableView *)tableView4Tag:(int)tag;
- (UITextView *)textView4Tag:(int)tag;
- (UIWebView *)webView4Tag:(int)tag;
- (UIScrollView *)scrollView4Tag:(int)tag;
- (id)id4Tag:(int)tag;

#pragma makr 一些简单的动画

- (void)animationWithFrame:(CGRect)frame inTime:(NSTimeInterval)time over:(void (^)(void))over;
- (void)animationWithFrame:(CGRect)frame ForRemoveinTime:(NSTimeInterval)time;

- (void)animationWithAlpha:(float)toValue inTime:(NSTimeInterval)time over:(void (^)(void))over;
- (void)animationWithAlphaForRemoveInTime:(NSTimeInterval)time;

@end


@interface UIImageView (VTExtra)

+ (UIImageView*)screenshotForView: (UIView*) view;

+ (UIImage*)screenshotForView:(UIView*) view withFrame:(CGRect)frame;

@end


typedef NS_ENUM(NSInteger,OSV) {_V8=8, _V7 = 7,_V6 = 6,_V5 = 5};

@interface UIDevice (Extra)

+(int)version;

+(BOOL)isGt:(int)iOSV;

+(BOOL)isGe:(int)iOSV;

+(NSString*)uuid;

+(NSString *)uuid_;

@end
