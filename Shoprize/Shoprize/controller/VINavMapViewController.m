//
//  VINavMapViewController.m
//  Shoprose
//
//  Created by vnidev on 5/21/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "VINavMapViewController.h"
#import <VICore/VICore.h>

@interface VINavMapViewController ()

@end

@implementation VINavMapViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef __IPHONE_7_0
    if ([UIDevice isGe:7]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
#endif
    VIMapView *mapkit = [[VIMapView alloc] initWithFrame:Frm(0, 0, self.view.w, self.view.h) showLocation:YES];

    [self.view addSubview:mapkit];
    
    VIPinAnnotationView *an = [[VIPinAnnotationView alloc] initWithTitle:self.subtitle sub:self.title lat:self.destination.latVal lon:self.destination.lonVal];
    [mapkit addAnnotation:an];
    
    [self addNav:nil left:BACK right:NONE];
    
    [mapkit zoomToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
