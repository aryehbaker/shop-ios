//
//  VIMapView.h
//  VICore
//
//  Created by mk on 13-3-4.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//
//
//
//  这个包需要如下库：
//    libicucore.dylib 用于正则表达式的
//
//
//
//
//

#import <UIKit/UIKit.h>
#import <VICore/VICore.h>
#import <MapKit/MapKit.h>

@protocol VIMapViewDelegate <NSObject>

@optional

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation;

@end

@interface VIMapView : UIView <MKMapViewDelegate>{}

@property(nonatomic, readonly) MKMapView *mapKitView;
@property(nonatomic, retain) UIImageView *routeView;
@property(nonatomic,assign) id<VIMapViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame showLocation:(BOOL)showYourlocation;

/**
 * 向地图上加入标记点
 * @param annotation
 *      annotation  可以是单独的 VIAnnotation 对象，也可以是NSArray 数据对象
 *
 */
- (void)addAnnotation:(id <MKAnnotation>)annotation;

/**
 * @param annotation
 *      可以是单独的 VIAnnotation 对象，也可以是NSArray 数据对象
 * 去除掉页面的标记
 */
- (void)removeAnnotation:(id <MKAnnotation>)annotation;

/**
 * 去除掉地图上所有的标记点
 */
- (void)removeAnnotation;

/**
 * 缩放到合适的合适的点，让所有的点都能显示在页面上
 */
- (void)zoomToFit;

/**
 *    绘制线路图，从一个点到另外一个点
 *    @param start 开始的点
 *    @param end 结束点
 */
- (void)showWayFrom:(id <MKAnnotation>)start to:(id <MKAnnotation>)end lineColor:(NSString *)color;

//加载数据内容
- (void)loadGoogleLocationOk:(NSString *)locs;

@end

