//
//  VIAppDelegate.h
//  Shoprise_EN
//
//  Created by mk on 4/1/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIBigSuprise.h"
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>
#import <Shoprize/Shoprize.h>

@interface VIAppDelegate : UIResponder <UIApplicationDelegate,OpenSuprise,CLLocationManagerDelegate,MFMailComposeViewControllerDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>

//check the app is Active
@property(nonatomic,assign) BOOL isActive;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) CLLocationManager *locationManager;

@property (strong, nonatomic) FBSession *session;

@property (strong, nonatomic) NSMutableDictionary *beancons;
@property (strong, nonatomic) MallInfo *currentMall;

@property (nonatomic,assign) NSInteger backTaskId;

/* get navigation view controllsers */
- (UINavigationController *)pushStack;

- (void)faceBookLogon:(id)value;

- (void)shareText:(NSNotification *)shareInfo;

/** Push a local notifycation */
- (void)pushNotification:(NSString *)text withObj:(id)obj;
- (void)cancelNotifyCation:(UILocalNotification *)notify;

//扩展的Beacon
@property(nonatomic,strong) NSMutableDictionary *rangedRegions;

- (void)loadNearestMallInBackGround:(NSString *)mallId;

@end


@interface VIAppDelegate(iBeacon)

- (void)addUUID:(NSString *)uuid;
- (void)addUUIDs:(NSArray *)uuids;

- (void)startScan;
- (void)stopScan;
- (BOOL)isScaning;

- (void)resetIbeaonScan;

- (void)locationManagerFindRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region;

@end