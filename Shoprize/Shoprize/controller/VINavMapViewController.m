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
{
    VIMapView *mapkit;
    VIPinAnnotationView *target;
}

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
    
    mapkit = [[VIMapView alloc] initWithFrame:Frm(0, 0, self.view.w, self.view.h) showLocation:YES];
    [mapkit.mapKitView setShowsUserLocation:YES];
    [self.view addSubview:mapkit];
    
    target = [[VIPinAnnotationView alloc] initWithTitle:self.subtitle sub:self.title lat:self.destination.latVal lon:self.destination.lonVal];
    [mapkit addAnnotation:target];
    
    [self addNav:nil left:BACK right:Route];
    [self.rightOne addTarget:self action:@selector(showMapRouting:)];
    
    @try {
        [mapkit zoomToFit];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    
    if ([self onlyShowRoute]) {
        [self.rightOne setHidden:YES];
        [self performSelector:@selector(showMapRouting:) withObject:nil afterDelay:1];
    }
}

-(void)showMapRouting:(UIButton *)sender {
        [self startLoading];
        VIPinAnnotationView *anno =  [[VIPinAnnotationView alloc]initAnnotationWithCoordinate:CLLocationCoordinate2DMake([VINet currentLat], [VINet currentLon]) andColor:MKPinAnnotationColorRed];
    
        if(mapkit.mapKitView.userLocation != nil){
            anno.coordinate = mapkit.mapKitView.userLocation.coordinate;
        }
        
        [mapkit showWayFrom:anno to:target lineColor:@"#FF0000"];
        [self stopLoading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
