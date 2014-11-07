//
//  MapViewController.m
//  SOTGApp
//
//  Created by Dmitriy Nasyrov on 3/12/11.
//  Copyright 2011 Netroad Group(info@netroad.com.ua). All rights reserved.
//

#import "VIMapViewController.h"

@interface VIMapViewController(Private)

-(void)showStorePins;
-(void)backToPre:(id)sender;
-(void)shoFilterView:(id)sender;

-(void)getCateLogeOk:(NSArray *)list;
-(void)getCateLogeFail:(id)value;

@end

@implementation VIMapViewController
@synthesize map=map;

-(void)viewDidLoad{
    [super viewDidLoad];
    self.mappoints = [NSMutableArray array];
    
    self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0,self.view.w,self.view.h)];
    map.scrollEnabled = YES;
    map.zoomEnabled = YES;
    map.delegate = self;
    map.showsUserLocation = YES;
    map.userInteractionEnabled = YES;
    [self.view addSubview:map];
    
    [self addNav:nil left:BACK right:NONE];
 
    [self setDropPinWithDetailInfo];
}

- (void)getAddresses
{
    
}

//show store pin point
-(void)setDropPinWithDetailInfo {
    
    [map removeAnnotations:map.annotations];
    [self.mappoints removeAllObjects];
    
    for (NSInteger i = 0; i < _deals.count; i++)
    {
		MobiPromoExt *ext	= [_deals objectAtIndex:i];
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = ext.Lat;
        coordinate.longitude = ext.Lon;
        
        PlaceMark *point = [[PlaceMark alloc] initWithCoordinate:coordinate];
        point.inputTitle = ext.StoreName;
        point.inputSubtitle = ext.Offer;
        point.extinfo = ext;
       
        [self.mappoints addObject:point];
        
        [self.map addAnnotation:point];
        
    }
    
    [self fitToPinsRegion];
}

//-(void)shoFilterView:(id)sender{
//    UIView *fv = [self.view viewWithTag:10000];
//    if (fv!=nil) {
//        [self.view bringSubviewToFront:fv];
//        return;
//    }
//    WLPopGridView *grid = [[WLPopGridView alloc] initWithArray:_pointList cates:cateloges showAt:CGRectMake(20, 20, 280,300)];
//    grid.tag = 10000;
//    grid.vdelegate = self;
//    [self.view addSubview:grid];
//    [grid release];
//}

//had filter done do
//-(void)hasDoneFilter:(NSArray *)_points{
//    
//    self.map.delegate = nil;
//    [self.map removeFromSuperview];
//    
//    self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 420.0)];
//    map.scrollEnabled = YES;
//    map.zoomEnabled = YES;
//    map.delegate = self;
//    map.showsUserLocation = YES;
//    map.userInteractionEnabled = YES;
//    [self.map removeAnnotations:map.annotations];
//
//    [self.view insertSubview:map belowSubview:[self.view viewWithTag:10000]];
//    
//	for (NSInteger i = 0; i < self.mappin.count; i++) {
//        POI *point = [self.mappin objectAtIndex:i];
//        NSLog(@"%@",point);
//        if ([_points indexOfObject:@"-1"]!=NSNotFound || [_points indexOfObject:point.promos.CategoryId]!=NSNotFound) {
//            CLLocationCoordinate2D coordinate = point.coordinate;
//            [self addingPins:coordinate andTag:i];
//        }
//	}
//   [self fitToPinsRegion];
//}

-(void)getCateLogeOk:(NSDictionary *)values{
    self.cateloges = [values objectForKey:@"Categories"];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

//-(void)getCateLogeFail:(id)value{
//    [WuliUtil showErrorMessage:[@"cantGetCategory" lang]];
//    self.navigationItem.rightBarButtonItem.enabled = NO;
//}
//
//-(void)showStorePins{
//    [map removeAnnotations:map.annotations];
//	for (NSInteger i = 0; i < self.mappin.count; i++) {
//		POI *point = [self.mappin objectAtIndex:i];
//        CLLocationCoordinate2D coordinate = point.coordinate;
//		[self addingPins:coordinate andTag:i];
//	}
//    [self fitToPinsRegion];
//}


//- (void)storesForCouponFetched:(NSString *)_response {
//    
//	[map removeAnnotations:map.annotations];
//	
//	for (NSInteger i = 0; i < self.mappin.count; i++) {
//		POI *point = [self.mappin objectAtIndex:i];
//        CLLocationCoordinate2D coordinate = point.coordinate;
//		[self addingPins:coordinate andTag:i];
//	}
//	
//    [self fitToPinsRegion];
//    
//}

//- (void)aroundstoreFetched:(NSString *)_response {
//    
//	[map removeAnnotations:map.annotations];
//	
//	for(NSInteger i = 0; i < self.mappin.count; i++) {
//		POI *point = [self.mappin objectAtIndex:i];
//        CLLocationCoordinate2D coordinate = point.coordinate;
//		[self addingPins:coordinate andTag:i];
//	}
//    [self fitToPinsRegion];
//}
//
//- (void)requestFinished:(NSDictionary *)request {}
//

- (void)fitToPinsRegion {
    
    CLLocationCoordinate2D topLeftCoord = CLLocationCoordinate2DMake([VINet currentLat], [VINet currentLon]);
    CLLocationCoordinate2D bottomRightCoord = CLLocationCoordinate2DMake([VINet currentLat], [VINet currentLon]);
   
    NSLog(@"%f %f",topLeftCoord.latitude,topLeftCoord.longitude);
    NSLog(@"%f %f",bottomRightCoord.latitude,bottomRightCoord.longitude);
    
	for(PlaceMark *item in self.map.annotations) {
        
		topLeftCoord.longitude = fmin(topLeftCoord.longitude, item.coordinate.longitude);
		topLeftCoord.latitude = fmax(topLeftCoord.latitude, item.coordinate.latitude);
		
		bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, item.coordinate.longitude);
		bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, item.coordinate.latitude);
	}
	
	MKCoordinateRegion region;
	region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
	region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    
	region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude)*1.25; // Add a little extra space on the sides
	region.span.longitudeDelta =fabs(bottomRightCoord.longitude - topLeftCoord.longitude)*1.25; // Add a little extra space on the sides
    
        if(region.span.latitudeDelta>=180){
            region.span.latitudeDelta = fabs(fabs(topLeftCoord.latitude) - abs(bottomRightCoord.latitude))*1.25;
         }
         if(region.span.longitudeDelta>=180){
	    region.span.longitudeDelta = fabs(fabs(bottomRightCoord.longitude) - fabs(topLeftCoord.longitude))*1.25;
         }
        
	if (isnan(region.center.latitude)) {
        // iOS 6 will result in nan. 2012-10-15
        region.center.latitude = region.center.latitude;
        region.center.longitude = region.center.longitude;
        region.span.latitudeDelta = 0;
        region.span.longitudeDelta = 0;
    }
	region = [self.map regionThatFits:region];
	[map setRegion:region];
}

- (void)infor:(UIButton *)sender{
    
    currentIndex = (sender.tag - 20000);    
    PlaceMark *mapint = [_mappoints objectAtIndex:currentIndex];
    
    [self showActionSheets:@"What You Want To Do ?" btns:@[@"Show More",@"Get Route",@"Cancel"] callbk:^(NSInteger btnIndex, NSString *text) {
        if (btnIndex == 0) {
            MobiPromoExt *pdata = mapint.extinfo;
            [self pushTo:@"VIDealsDetailViewController" data:[pdata toDictionary]];
        }
        if(btnIndex == 1) {
            
        }
    }];
}

////获得对应的线路
//-(void)getRoute:(WLMobiPromo *)coup index:(NSInteger)index{
//    
//    WLPlace *start = [[WLPlace alloc] init];
//
//    if (![WuliUtil isVaildLocation:map.userLocation.coordinate]) {
//        start.latitude =  [[VTLocation lastPoint] latVal];
//        start.longitude = [[VTLocation lastPoint] lonVal];
//    }else {
//        start.latitude = map.userLocation.coordinate.latitude;
//        start.longitude = map.userLocation.coordinate.longitude;
//    }
//    
//    start.name =  [@"curentLoc" lang];
//    WLPlace *end = [[WLPlace alloc] init];
// 
//    WLAddress *endPoint = [coup.Addresses objectAtIndex:index];
//    end.latitude = endPoint.Lat;
//    end.longitude = endPoint.Lon;
//    end.name = coup.StoreName;
//    end.subname = endPoint.addressString;
//
//    if (end.latitude==0.0 && end.longitude==0.0) {
//        [self showError:[@"LocationServicesFailedMessage" lang]];
//        return;
//    }
//    WLMapDirectionsViewController *dirc = [[WLMapDirectionsViewController alloc] initRoadFrom:start to:end];
//    [self.navigationController pushViewController:dirc animated:YES];
//    [dirc release],dirc=nil;
//    [start release];
//    [end release];
//}


-(void)viewWillDisappear:(BOOL)animated{
    map.delegate = nil;
    [super viewWillDisappear:animated];
}

#pragma mark MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    PlaceMark *pinAnnotation = nil;
    if(annotation != mapView.userLocation) {

        NSInteger	tagInt	= [(PlaceMark *)annotation displayIndex];
        NSString	*tag	= [NSString stringWithFormat:@"View_%ld", (long)tagInt];

        pinAnnotation = (PlaceMark *)[mapView dequeueReusableAnnotationViewWithIdentifier:tag];

        if(pinAnnotation == nil) {
            pinAnnotation = [[PlaceMark alloc] initWithAnnotation:annotation reuseIdentifier:tag];
			pinAnnotation.pinColor = MKPinAnnotationColorGreen;
			pinAnnotation.enabled = YES;
			pinAnnotation.animatesDrop = YES;	
            pinAnnotation.canShowCallout = YES;
            pinAnnotation.calloutOffset = CGPointMake(-5, 5);
        }
        
        //pinAnnotation.pinColor = [bean closed] ? MKPinAnnotationColorRed : MKPinAnnotationColorGreen;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure]; 
        [button addTarget:self action:@selector(infor:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 20000 + tagInt;
        [buttonArray addObject:button];
        pinAnnotation.rightCalloutAccessoryView = button;
    }
    return pinAnnotation;
}

@end


/////////////////////////////////////////////////////////////////////////////////////////////////

@implementation PlaceMark
@synthesize coordinate, tag, inputTitle, inputSubtitle;

- (NSString *)title {
    return self.inputTitle;
}

- (NSString *)subtitle {
    return self.inputSubtitle;
}
- (id)initWithCoordinate:(CLLocationCoordinate2D)_coordinate {
    self = [super initWithAnnotation:self reuseIdentifier:@"coreIDlistcompt"];
    if (self) {
        coordinate = _coordinate;
    }
    return self;
}
@end