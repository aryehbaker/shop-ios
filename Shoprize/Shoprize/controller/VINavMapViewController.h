//
//  VINavMapViewController.h
//  Shoprose
//
//  Created by vnidev on 5/21/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "ShopriseViewController.h"

@interface VINavMapViewController : ShopriseViewController

@property(nonatomic,strong) CLLocation *destination;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *subtitle;

@property(nonatomic,retain) NSArray *points;
@property(nonatomic,retain) UIImageView *routeView;

@property(nonatomic,assign) BOOL onlyShowRoute;

@end
