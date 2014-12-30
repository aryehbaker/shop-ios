//
//  VIMallsViewController.m
//  Shoprose
//
//  Created by vnidev on 5/21/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "VIMallsViewController.h"
#import "KUtils.h"
#import "Models.h"
#import <iSQLite/iSQLite.h>
#import "VINavMapViewController.h"

@interface VIMallsViewController ()<VIMapViewDelegate,CLLocationManagerDelegate>
{
    NSMutableArray *allCity;
    NSMutableArray *curentCity;
    VICfgTableView *cfg;
    
    VIMapView *mapview;
}
@property(nonatomic,strong) CLLocationManager *_locmgr;

@end

@implementation VIMallsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    allCity = [NSMutableArray array];
    curentCity = [NSMutableArray array];
    
    [self addNav:Lang(@"list_of_malls") left:SEARCH right:MENU];
    
    int endY = self.nav.endY;

    mapview = [[VIMapView alloc] initWithFrame:Frm(0, endY, self.view.w, 180) showLocation:YES];
    mapview.mapKitView.showsUserLocation = YES;
    mapview.delegate = self;
    [self.view addSubview:mapview];
    endY += 180;
    
    cfg = [[VICfgTableView alloc] initWithFrame:Frm(0, endY, self.view.w, Space(endY)) cfg:@"tbcfg.json#list_of_malls"];
    
    cfg.delegate = self;
    [self.view addSubview:cfg];
    
    [self startShowMalls:[VINet currentLat] lon:[VINet currentLon]];
}

- (void)startShowMalls:(double)_lat lon:(double)_lon
{
    NSMutableArray *citys = [[iSQLiteHelper getDefaultHelper] searchAllModel:[MallInfo class]];
    for (MallInfo *d in citys) {
        double doub = [VINet distancOfTwolat1:_lat lon1:_lon lat2:d.Lat lon2:d.Lon];
        [d setDistance:doub];
        [allCity addObject:d];
    }
    
    NSArray *afterThat = [allCity sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
        double obj1d = [((MallInfo*)obj1) distance];
        double obj2d = [((MallInfo*)obj2) distance];
        if (obj1d > obj2d)
            return NSOrderedDescending;
        if (obj1d < obj2d)
            return NSOrderedAscending;
        return NSOrderedSame;
    }];
    
    [allCity removeAllObjects];
    [allCity addObjectsFromArray:afterThat];
    
    [curentCity addObjectsFromArray:allCity];
    [cfg setData:curentCity];
    
    int i = 0;
    for (MallInfo *mall in allCity) {
        VIPinAnnotationView *pin = [[VIPinAnnotationView alloc] initWithTitle:mall.Name sub:mall.Address lat:mall.Lat lon:mall.Lon];
        pin.tag = i;
        [mapview addAnnotation:pin];
        i++;
    }
    [self displayNear];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    VIPinAnnotationView *annotion = nil;
    
    if (annotation != mapView.userLocation) {
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
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:@"showrote.png" selectd:@"showrote.png"];
        [button setFrame:Frm(0, 0, 40, 40)];
        [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        [button addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 0 - tagindex;
        pinAnnotation.rightCalloutAccessoryView = button;
        
        return pinAnnotation;
    }
    return annotion;
}

-(void)showMore:(UIButton*)sender
{
    MallInfo *mall = allCity[0-sender.tag];
    
    VINavMapViewController *map = [[VINavMapViewController alloc] init];
    map.destination = [[CLLocation alloc] initWithLatitude:mall.Lat longitude:mall.Lon];
    map.title = mall.Name;
    map.subtitle = mall.Address;
    map.onlyShowRoute =  YES;

    [self push:map];
    
}

- (void)displayNear{
        
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude	= -90;
    topLeftCoord.longitude	= 180;
        
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude	= 90;
    bottomRightCoord.longitude	= -180;
        
    for (MallInfo *mif in allCity) {
        double lat = mif.Lat,lon = mif.Lon;
        topLeftCoord.longitude		= fmin(topLeftCoord.longitude, lon);
        topLeftCoord.latitude		= fmax(topLeftCoord.latitude, lat);
        bottomRightCoord.longitude	= fmax(bottomRightCoord.longitude, lon);
        bottomRightCoord.latitude	= fmin(bottomRightCoord.latitude, lat);
    }
    double lat = [VINet currentLat];
    double  lon = [VINet currentLon];
    topLeftCoord.longitude		= fmin(topLeftCoord.longitude, lon);
    topLeftCoord.latitude		= fmax(topLeftCoord.latitude, lat);
    bottomRightCoord.longitude	= fmax(bottomRightCoord.longitude, lon);
    bottomRightCoord.latitude	= fmin(bottomRightCoord.latitude, lat);
    
    MKCoordinateRegion region;
    region.center.latitude		= topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude		= topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta	= fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
        
        // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
        
    region = [mapview.mapKitView regionThatFits:region];
    @try {
        [mapview.mapKitView setRegion:region];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}

- (int)totalPage:(NSDictionary *)returnInfo {
    return 1;
}

- (void)whenSearchKey:(NSString *)search {
    if (search!=nil && ![search isEqualToString:@""]) {
        [curentCity removeAllObjects];
        for (MallInfo *d in allCity) {
            if ([d.Name like:search]) {
                [curentCity addObject:d];
            }
        }
        [cfg setData:curentCity];
        [cfg.cfgTable reloadData];
        return;
    }
    [cfg setData:allCity];
    [cfg.cfgTable reloadData];
}

- (void)rowSelectedAt:(NSIndexPath *)index data:(id)data
{
    MallInfo *mallinfo = (MallInfo *)data;
    [ShopriseViewController gotoMallWithId:mallinfo.MallAddressId inNav:self.navigationController];
}

- (void)repaintCell:(UITableViewCell *)cell atPath:(NSIndexPath *)path onTable:(VICfgTableView *)cfgTableview withValue:(id)value
{
    UILabel *distance = [cell label4Tag:6001];
    UILabel *name     = [cell label4Tag:6002];
    MallInfo *mf = (MallInfo *)value;
    distance.font = Bold(18);
    if (isHe) {
       distance.text = [NSString stringWithFormat:@"\u200F %0.2f ק\"מ",mf.distance];
        NSLog(@"%@",mf);
    }else{
       distance.text = [NSString stringWithFormat:@"%0.2f km",mf.distance];
    }
    name.text = mf.Name;
    name.font = Regular(18);
}

@end
