//
//  VIVIAutoPlayItem.h
//  Hotel
//
//  Created by mk on 13-2-27.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//
//  这个是运行的所需要的基本信息框
//
#import <UIKit/UIKit.h>

@interface VIAutoPlayItem : NSObject

//这个是显示的图片的URL的地址
@property(nonatomic, retain) NSString *imageURL;

//这个是需要显示的图片的图片信息
@property(nonatomic, retain) UIImage *image;

//这个是替换的图片信息，如果图片没出来，则用默认图替换
@property(nonatomic, retain) UIImage *placeImage;

//图片所附带的附加信息
@property(nonatomic, retain) NSDictionary *imageInfo;

/** 这个是在图片上方的图片视图 */
@property(nonatomic, retain) UIView *aboveView;

/**
 * 通过网络进行加载图片信息
 */
- (id)initWithURL:(NSString *)url andValue:(NSDictionary *)info;

/**
 * 通过图片进行加载信息
 */
- (id)initWithImage:(UIImage *)image andValue:(NSDictionary *)info;

@end
