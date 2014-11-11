//
//  VIMapDirectionsViewController.m
//  Shoprize_EN
//
//  Created by vniapp on 11/10/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import "VIMapDirectionsViewController.h"
#import <MapKit/MapKit.h>

#define A_FILE [VIFile getPathForDocuments:@"AFile"]

@interface VIMapDirectionsViewController ()

@end

@implementation VIMapDirectionsViewController

-(id)initRoadFrom:(id)from  to:(id)to;
{
    self = [super init];
    if (self) {
        self.from = from;
        self.to = to;
        self.title = [to stringValueForKey:@"title"];
        
        CGRect frame = CGRectMake(0,0, self.view.w, self.view.h);
        
        self.map = [[MKMapView alloc] initWithFrame:frame];
        _map.showsUserLocation = YES;
        _map.zoomEnabled = YES;
        _map.scrollEnabled = YES;
        _map.userInteractionEnabled = YES;
        _map.delegate = self;
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];

    [self addNav:@"Aroud Me" left:BACK right:MapIt];
    
    self.routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _map.frame.size.width, _map.frame.size.height)];
    _routeView.userInteractionEnabled = NO;
    [_map addSubview:_routeView];
    
    [self.view addSubview:_map];
    
    //去除所有的标记
    [_map removeAnnotations:_map.annotations];
    
    NSString *f_t = @"Current Location";
    double lat = [VINet currentLat];
    double lon = [VINet currentLon];
    
    NSString *t_t = [self.to stringValueForKey:@"title"];
    NSString *t_s = [self.to stringValueForKey:@"subtitle"];
    double tlat = [self.to doubleValueForKey:@"lat"];
    double tlon = [self.to doubleValueForKey:@"lon"];
    
    VIPinAnnotationView *fm = [[VIPinAnnotationView alloc] initWithTitle:f_t sub:@"" lat:lat lon:lon];
    [_map addAnnotation:fm];
    
    VIPinAnnotationView *fm2 = [[VIPinAnnotationView alloc] initWithTitle:t_t sub:t_s lat:tlat lon:tlon];
    
    [_map addAnnotation:fm2];
    
    [self calculateRoutesFrom:fm.coordinate to:fm2.coordinate];
    
}

- (void)dealloc {
    _map.delegate =nil;
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    
}

- (void)loadGoogleLocationOk:(NSString *)locs
{
    NSString* encodedPoints = [locs stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
    self.points = [self decodePolyLine:[encodedPoints mutableCopy]];
    
    if ([_points count]==0) {
        [VIAlertView showErrorMsg:@"Nothing to show"];
        return;
    }
    
    [self updateRouteView:_points];
    @try {
        [self fitAndCenter];
    }
    @catch (NSException *exception) {
        NSLog(@"Excep:%@",exception.description);
    }
    
}

//-------  这个东西是对应的实现路径的算法
-(void)calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
    NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
    NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
    NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@",  daddr,saddr];
    
    [self startLoading];
    [self setCfg:[[HttpCfg defCfg] respType:TEXT]];
    [self get:apiUrlStr args:nil complete:^(BOOL iscomplete, id resp) {
        
        [self stopLoading];
        if (!iscomplete) {
            [VIAlertView showErrorMsg:@"Load Error"];
            return ;
        }
        [self loadGoogleLocationOk:resp];
        
    }];
    
}

-(NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\" options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        [array addObject:loc];
    }
    
    return array;
}

-(void)updateRouteView:(NSArray*)routes{
    CGContextRef context = 	CGBitmapContextCreate(nil,
                                                  _routeView.frame.size.width,
                                                  _routeView.frame.size.height,
                                                  8,
                                                  4 * _routeView.frame.size.width,
                                                  CGColorSpaceCreateDeviceRGB(),
                                                  kCGImageAlphaPremultipliedLast);
    
    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
    CGContextSetLineWidth(context, 3.0);
    
    for(int i = 0; i < routes.count; i++) {
        CLLocation* location = [routes objectAtIndex:i];
        CGPoint point = [_map convertCoordinate:location.coordinate toPointToView:_routeView];
        if(i == 0) {
            CGContextMoveToPoint(context, point.x, _routeView.frame.size.height - point.y);
        } else {
            CGContextAddLineToPoint(context, point.x, _routeView.frame.size.height - point.y);
        }
    }
    
    CGContextStrokePath(context);
    
    CGImageRef image = CGBitmapContextCreateImage(context);
    UIImage* img = [UIImage imageWithCGImage:image];
    
    _routeView.image = img;
    CGContextRelease(context);
}
//地图方法缩小的代理
#pragma mark 地图的一些代理
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    _routeView.hidden = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self updateRouteView:_points];
    _routeView.hidden = NO;
    [_routeView setNeedsDisplay];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    //地点类型
    if ([annotation isKindOfClass:[VIPinAnnotationView class]]) {
        static NSString* detailAnnotationIdentifier = @"detailAnoview";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [_map dequeueReusableAnnotationViewWithIdentifier:detailAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:detailAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorGreen;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            // add a detail disclosure button to the callout which will open a new view controller page
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            // - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
}
-(void)fitAndCenter{
    MKCoordinateRegion region;
    
    CLLocationDegrees maxLat = -90;
    CLLocationDegrees maxLon = -180;
    CLLocationDegrees minLat = 90;
    CLLocationDegrees minLon = 180;
    for(int idx = 0; idx < _points.count; idx++)
    {
        CLLocation* currentLocation = [_points objectAtIndex:idx];
        if(currentLocation.coordinate.latitude > maxLat)
            maxLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.latitude < minLat)
            minLat = currentLocation.coordinate.latitude;
        if(currentLocation.coordinate.longitude > maxLon)
            maxLon = currentLocation.coordinate.longitude;
        if(currentLocation.coordinate.longitude < minLon)
            minLon = currentLocation.coordinate.longitude;
    }
    region.center.latitude     = (maxLat + minLat) / 2;
    region.center.longitude    = (maxLon + minLon) / 2;
    region.span.latitudeDelta  = maxLat - minLat;
    region.span.longitudeDelta = maxLon - minLon;
    
   [self.map setRegion:region];
}

@end
