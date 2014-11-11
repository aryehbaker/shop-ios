//
//  VIMapDirectionsViewController.h
//  Shoprize_EN
//
//  Created by vniapp on 11/10/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import <Shoprize/ShopriseViewController.h>

@interface VIMapDirectionsViewController : ShopriseViewController<MKMapViewDelegate>
{
    NSArray *_points;
    UIImageView* _routeView;    //显示路径
}

@property(nonatomic,retain) id from;
@property(nonatomic,retain) id to;

@property(nonatomic,retain) MKMapView *map;
@property(nonatomic,retain) NSArray *points;
@property(nonatomic,retain) UIImageView *routeView;

-(id)initRoadFrom:(id)from  to:(id)to;

@end
