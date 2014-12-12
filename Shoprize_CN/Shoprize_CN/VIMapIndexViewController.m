//
//  VIMapIndexViewController.m
//  Shoprize_EN
//
//  Created by vniapp on 11/11/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import "VIMapIndexViewController.h"
#import "VINearByViewController.h"
#import <Shoprize/CMPopTipView.h>
#import "OpenMobiView.h"
#import <Shoprize/VINavMapViewController.h>

@interface VIMapIndexViewController ()
{
    MKMapView   *displayMapView;
    BOOL        isLoading;
}
@property(nonatomic,retain) NSMutableArray   *all_store_item_val;
@end

@implementation VIMapIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLoading = NO;
    
    self.all_store_item_val = [NSMutableArray array];
    
    //change the left button
    
    displayMapView = [[MKMapView alloc] initWithFrame:Frm(0, 0, self.view.w,self.view.h)];
    displayMapView.showsUserLocation	= YES;
    displayMapView.zoomEnabled			= YES;
    displayMapView.scrollEnabled		= YES;
    displayMapView.delegate				= self;
    
    [self.view addSubview:displayMapView];
    [self addNav:@"地图标记" left:BACK right:NONE];
    
    [self setCenterCoordinate:CLLocationCoordinate2DMake([VINet currentLat], [VINet currentLon]) zoomLevel:15 animated:YES];
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated
{
    if (isLoading) {
        return;
    }
    
    isLoading = YES;
    
    self.leftOne.enabled = NO;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0, 360/pow(2, zoomLevel)*displayMapView.frame.size.width/256);
    [displayMapView setRegion:MKCoordinateRegionMake(centerCoordinate, span)];
    
    //延迟0.5秒加载
    [self performSelector:@selector(startLoadAroundMeData) withObject:nil afterDelay:.5];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (!isLoading) {
        [self performSelector:@selector(startLoadAroundMeData) withObject:nil afterDelay:.6];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    VIPinAnnotationView *annotion = nil;
    
    if (annotation != displayMapView.userLocation) {
        VIPinAnnotationView *anno			= (VIPinAnnotationView *)annotation;
        VIPinAnnotationView *pinAnnotation	= (VIPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:anno.identiy];
        
        if (pinAnnotation == nil) {
            pinAnnotation					= [[VIPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:anno.identiy];
            pinAnnotation.enabled			= YES;
            pinAnnotation.animatesDrop		= YES;
            pinAnnotation.canShowCallout	= YES;
            pinAnnotation.calloutOffset		= CGPointMake(-5, 5);
        } else {
            pinAnnotation.annotation = annotation;
        }
        
        pinAnnotation.tag = anno.tag;
        
        long tagindex = anno.tag;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [button addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 0 - tagindex;
        pinAnnotation.rightCalloutAccessoryView = button;
        
        //pinAnnotation.pinColor = [bean isClosed] ? MKPinAnnotationColorRed : MKPinAnnotationColorGreen;
        
        return pinAnnotation;
    }
    return annotion;
}

static id lastselectd;

-(void)showMore:(UIButton *)button
{
    long target = 0 - button.tag;
    lastselectd = [self.all_store_item_val objectAtIndex:target];
    if ([[[lastselectd stringValueForKey:@"Type"] lowercaseString] isEqualToString:@"mall"]) {
       
        UIView *fullview = [self loadXib:@"EngExt.xib" withTag:100];
        fullview.backgroundColor = [@"#F7F7F7" hexColor];
        VIRTLabel *rtlabel = [[VIRTLabel alloc] initWithFrame:Frm(100,8,175, 0)];
        NSString *logo = [lastselectd stringValueForKey:@"Logo"];
        if(logo!= nil){
            [fullview egoimageView4Tag:101].imageURL = [logo netImageURL];
        }else{
            UIView *logoImg = [fullview egoimageView4Tag:101];
            [rtlabel setX:logoImg.x];
            [rtlabel addW:logoImg.w];
            [logoImg setHidden:YES];
        }

        [rtlabel setText:Fmt(@"<b>名称</b>:%@\n<b>营业时间</b>:%@\n<b>电话</b>:%@\n<b>地址</b>:%@",
                             [lastselectd stringValueForKey:@"Name" defaultValue:@""],
                             [lastselectd stringValueForKey:@"OpenHours" defaultValue:@""],
                             [lastselectd stringValueForKey:@"Phone" defaultValue:@""],
                             [lastselectd stringValueForKey:@"Address" defaultValue:@""])];
        [rtlabel setH:rtlabel.optimumSize.height];
        [fullview addSubview:rtlabel];
        fullview.layer.cornerRadius = 4;
        [fullview button4Tag:104].layer.cornerRadius = 4;
        [[fullview button4Tag:104] setTitle:@"详情" selected:@"详情"];
        [[fullview button4Tag:104] addTarget:self action:@selector(goToDetail:)];
        
        [fullview button4Tag:105].layer.cornerRadius = 4;
        [[fullview button4Tag:105] addTarget:self action:@selector(showRoute:)];
        [[fullview button4Tag:105] setTitle:@"去这里" selected:@"去这里"];
        
        CMPopTipView *pop = [[CMPopTipView alloc] initWithCustomView:fullview];
        [pop presentPointingAtView:button inView:self.view animated:YES];
        
    }
    if ([[[lastselectd stringValueForKey:@"Type"] lowercaseString] isEqualToString:@"store"]) {
        [OpenMobiView showMobisIn:self.view info:lastselectd];
    }
}

-(void)showRoute:(UIButton *)sender
{
    VINavMapViewController *near = [[VINavMapViewController alloc] init];
    near.onlyShowRoute = YES;
    NSMutableDictionary *pm = [lastselectd mutableCopy];
    near.title = [pm stringValueForKey:@"Name"];
    near.destination = [[CLLocation alloc] initWithLatitude:[pm doubleValueForKey:@"Lat"] longitude:[pm doubleValueForKey:@"Lon"] ];
    
    [self push:near];
}

-(void)goToDetail:(UIButton *)sender
{
    VINearByViewController *near = [[VINearByViewController alloc] init];
    NSMutableDictionary *pm = [lastselectd mutableCopy];
    [pm setValue:[pm stringValueForKey:@"AddressId"] forKey:@"MallAddressId"];
    near.mallInfo = pm;
    [self push:near];
}

-(void)startLoadAroundMeData {
    
    MKMapRect mRect = displayMapView.visibleMapRect;
    MKMapPoint neMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), mRect.origin.y);
    MKMapPoint swMapPoint = MKMapPointMake(mRect.origin.x, MKMapRectGetMaxY(mRect));
    CLLocationCoordinate2D neCoord = MKCoordinateForMapPoint(neMapPoint);
    CLLocationCoordinate2D swCoord = MKCoordinateForMapPoint(swMapPoint);
    
    NSDictionary *args = @{
                           @"pageIndex" : @"0",
                           @"pageSize" : @"100",
                           @"maxLat" : FORMAT(@"%.6f",neCoord.latitude),
                           @"maxLon" : FORMAT(@"%.6f",neCoord.longitude),
                           @"minLat" : FORMAT(@"%.6f",swCoord.latitude),
                           @"minLon" : FORMAT(@"%.6f",swCoord.longitude)
                           };
    [VINet get:@"/api/addresses/byrange" args:args target:self succ:@selector(loadAroundMeDataOk:) error:@selector(loadAroundMeDataFail:) inv:nil];
}
- (void)dealloc
{
    [VINet viewDidDisAappear:self];
}

-(void)loadAroundMeDataOk:(NSDictionary *)data{
    isLoading = NO;
     self.leftOne.enabled = YES;
    if (data.count == 0) {
        return;
    }
    
   NSMutableArray *tmpStore = [NSMutableArray array];
   for (NSDictionary *add in data) {
      if ([self.all_store_item_val indexOfObject:add] == NSNotFound) {
          [tmpStore addObject:add];
      }
    }
    
    long indexFlag= self.all_store_item_val.count;
    for (NSDictionary *wlAdress in tmpStore) {
       [self.all_store_item_val addObject:wlAdress];
        double lat = [wlAdress doubleValueForKey:@"Lat"];
        double lon = [wlAdress doubleValueForKey:@"Lon"];
        CLLocationCoordinate2D c2d = CLLocationCoordinate2DMake(lat, lon);
        VIPinAnnotationView *anno = [[VIPinAnnotationView alloc] initAnnotationWithCoordinate:c2d andColor:MKPinAnnotationColorGreen];
            anno.title = [wlAdress stringValueForKey:@"Name"];
            anno.tag = indexFlag;
            [displayMapView addAnnotation:anno];
            indexFlag++;
        }
}

-(void)loadAroundMeDataFail:(NSDictionary *)data{
    isLoading = NO;
     self.leftOne.enabled = YES;
    NSLog(@"%@",data);
}


/*
 -(void)showRoutViewOnMap:(id)mobi{
 
 WLPlace *start = [[WLPlace alloc] init];
 
 if (![WuliUtil isVaildLocation:displayMapView.userLocation.coordinate]) {
 start.latitude	= VTLocation.lastPoint.latVal;
 start.longitude = VTLocation.lastPoint.lonVal;
 } else {
 start.latitude	= displayMapView.userLocation.coordinate.latitude;
 start.longitude = displayMapView.userLocation.coordinate.longitude;
 }
 
 start.name = [@"curentLoc" lang];
 WLPlace *end = [[WLPlace alloc] init];
 end.latitude	= mobi.Lat;
 end.longitude	= mobi.Lon;
 end.name		= mobi.Name;
 end.subname		= [mobi addressString];
 
 WLMapDirectionsViewController *dirc = [[WLMapDirectionsViewController alloc] initRoadFrom:start to:end];
 [self push:dirc];
 [dirc release], dirc = nil;
 [start release];
 [end release];
 
 }
 */

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
       
}


@end
