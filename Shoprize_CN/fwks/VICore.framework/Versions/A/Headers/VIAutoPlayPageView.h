//
//  VIAutoPlayPageView.h
//  Hotel
//  自动循环显示一个图片
//  Created by mk on 13-2-27.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIAutoPlayItem.h"

@class VIPageControl;

@protocol VIAutoPlayPageDelegate;

@interface VIAutoPlayPageView : UIView <UIGestureRecognizerDelegate, UIScrollViewDelegate>
@property (nonatomic,retain)  VIPageControl *pageControl;

/**
 * 初始化运行的一些解构信息
 */
- (id)initWithFrame:(CGRect)frame delegate:(id <VIAutoPlayPageDelegate>)delegate focusImageItems:(NSMutableArray *)imageItems alphaBackFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame delegate:(id <VIAutoPlayPageDelegate>)delegate focusImageItems:(NSMutableArray *)imageItems;

/*
 * 设置显示的那个图片的点的按钮
 */
- (void)setPageDot:(NSString *)normal current:(NSString *)current;

/**
 * 开始自动运行
 */
- (void)startAutoRun;

/**
 * 停止自动运行
 */
- (void)stopAutoRun;

/**
 * 获取位置的图片
 */
- (UIImageView*)getImageAtIndex:(NSInteger)index;

- (UIImage *)imageAt:(NSInteger)index;
/**
 * 设置Page的位置
 */
- (void)setPageFrame:(CGRect)rect;

@property(nonatomic, assign) id <VIAutoPlayPageDelegate> delegate;

@end


/**
 * 这个是单击图片的delegate
 */
@protocol VIAutoPlayPageDelegate <NSObject>

- (void)foucusImageFrame:(VIAutoPlayPageView *)imageFrame didSelectItem:(VIAutoPlayItem *)item;

@end