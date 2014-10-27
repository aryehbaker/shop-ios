//
//  VIPinAnnotationView.h
//  VICore
//
//  Created by mk on 13-5-13.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface VIPinAnnotationView : MKPinAnnotationView <MKAnnotation>

@property(nonatomic, copy) NSString			*title;
@property(nonatomic, copy) NSString			*subTitle;
@property (nonatomic) CLLocationCoordinate2D	coordinate;

- (float)lat;

- (float)lon;

- (NSString *)identiy;

- (id)initAnnotationWithCoordinate:(CLLocationCoordinate2D)coords;

- (id)initAnnotationWithCoordinate:(CLLocationCoordinate2D)coords andColor:(MKPinAnnotationColor)color;

- (id)initWithTitle:(NSString *)title sub:(NSString *)sub lat:(float)lat lon:(float)lon;

@end

