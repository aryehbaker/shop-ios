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
}

@end

@implementation VIMallsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    allCity = [NSMutableArray array];
    curentCity = [NSMutableArray array];
    
    [self addNav:Lang(@"list_of_malls") left:SEARCH right:MENU];
    
    cfg = [[VICfgTableView alloc] initWithFrame:Frm(0, self.nav.endY, 320, Space(self.nav.endY)) cfg:@"tbcfg.json#list_of_malls"];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:_NOTIFY_MALL_CHANGED object:[data toDictionary]];
    [self popTo:@"VINearByViewController"];
}

- (void)repaintCell:(UITableViewCell *)cell atPath:(NSIndexPath *)path onTable:(VICfgTableView *)cfgTableview withValue:(id)value
{
    UILabel *distance = [cell label4Tag:6001];
    UILabel *name     = [cell label4Tag:6002];
    MallInfo *mf = (MallInfo *)value;
    distance.font = Bold(18);
    distance.text = [NSString stringWithFormat:@"\u200F %0.2f ק\"מ",mf.distance];
    name.text = mf.Name;
    name.font = Regular(18);
}

@end
