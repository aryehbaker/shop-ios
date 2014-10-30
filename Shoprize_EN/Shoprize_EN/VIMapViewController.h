
//
//  MapViewController.h
//  SOTGApp
//
//  Created by Dmitriy Nasyrov on 3/12/11.
//  Copyright 2011 Netroad Group(info@netroad.com.ua). All rights reserved.
//

#import <Shoprize/ShopriseViewController.h>

@interface VIMapViewController : ShopriseViewController <MKMapViewDelegate,UIActionSheetDelegate>
{
	NSMutableArray *buttonArray;
    
	NSInteger loadedPins;
    
    BOOL calledDirections;
    
    MKMapView *map;
    
    int currentIndex;
    
}

@property(nonatomic,strong) NSArray *cateloges; //cache the cateloge list

@property(nonatomic,strong) NSMutableArray *deals;
@property(nonatomic,strong) NSMutableArray *mappoints;

@property(nonatomic, strong) MKMapView *map;

- (void)fitToPinsRegion;

@end

/**
  PlaceMark
 
 **/

@interface PlaceMark : MKPinAnnotationView <MKAnnotation> {
    CLLocationCoordinate2D coordinate;
    NSString *inputTitle, *inputSubtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) NSInteger displayIndex;
@property (nonatomic, strong) NSString *inputTitle, *inputSubtitle;
@property (nonatomic, strong) MobiPromoExt *extinfo;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
