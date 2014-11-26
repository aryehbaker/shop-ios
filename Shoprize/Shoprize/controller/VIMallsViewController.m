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

@interface VIMallsViewController ()
{
    NSMutableArray *allCity;
    NSMutableArray *curentCity;
    VICfgTableView *cfg;
    
    VIMapView *mapview;
}

@end

@implementation VIMallsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    allCity = [NSMutableArray array];
    curentCity = [NSMutableArray array];
    
    [self addNav:Lang(@"list_of_malls") left:SEARCH right:MENU];
    
    cfg = [[VICfgTableView alloc] initWithFrame:Frm(0, self.nav.endY, self.view.w, Space(self.nav.endY)) cfg:@"tbcfg.json#list_of_malls"];
    
    if (isHe) {
        mapview = [[VIMapView alloc] initWithFrame:Frm(0, 0, self.view.w, 180) showLocation:YES];
        mapview.mapKitView.showsUserLocation = YES;
        cfg.cfgTable.tableHeaderView = mapview;
    }
    
    NSMutableArray *citys = [[iSQLiteHelper getDefaultHelper] searchAllModel:[MallInfo class]];
    
    for (MallInfo *d in citys) {
        double lat = [VINet currentLat],lon = [VINet currentLon];
        double doub = [VINet distancOfTwolat1:lat lon1:lon lat2:d.Lat lon2:d.Lon];
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
    cfg.delegate = self;
    [self.view addSubview:cfg];
    
    if (isHe) {
        for (MallInfo *mall in allCity) {
            VIPinAnnotationView *pin = [[VIPinAnnotationView alloc] initWithTitle:mall.Name sub:mall.Address lat:mall.Lat lon:mall.Lon];
            [mapview addAnnotation:pin];
        }
        [self displayNear];
    }
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
        if (mif.distance > 20) {
            lat = [VINet currentLat];
            lon = [VINet currentLon];
        }
        topLeftCoord.longitude		= fmin(topLeftCoord.longitude, lon);
        topLeftCoord.latitude		= fmax(topLeftCoord.latitude, lat);
        bottomRightCoord.longitude	= fmax(bottomRightCoord.longitude, lon);
        bottomRightCoord.latitude	= fmin(bottomRightCoord.latitude, lat);
    }
    MKCoordinateRegion region;
    region.center.latitude		= topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude		= topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta	= fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
        
        // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
        
    region = [mapview.mapKitView regionThatFits:region];
    [mapview.mapKitView setRegion:region animated:YES];
    
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
    BOOL hasInited = NO;
    
    for (UIViewController *ctl in [self.navigationController viewControllers]) {
        
        if ([NSStringFromClass([ctl class]) isEqualToString:@"VINearByViewController"]) {
            hasInited = YES;
            break;
        }
    }
    
    if (hasInited) {
         [self popTo:@"VINearByViewController"];
    }else{
        Class clzz = NSClassFromString(@"VINearByViewController");
        UIViewController *ctrl = [[clzz alloc] init];
        [self push:ctrl];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:_NOTIFY_MALL_CHANGED object:[data toDictionary]];
}

- (void)repaintCell:(UITableViewCell *)cell atPath:(NSIndexPath *)path onTable:(VICfgTableView *)cfgTableview withValue:(id)value
{
    UILabel *distance = [cell label4Tag:6001];
    UILabel *name     = [cell label4Tag:6002];
    MallInfo *mf = (MallInfo *)value;
    distance.font = Bold(18);
    if (isHe) {
       distance.text = [NSString stringWithFormat:@"\u200F %0.2f ק\"מ",mf.distance];
    }else{
       distance.text = [NSString stringWithFormat:@"%0.2f km",mf.distance];
    }
    name.text = mf.Name;
    name.font = Regular(18);
}

@end
