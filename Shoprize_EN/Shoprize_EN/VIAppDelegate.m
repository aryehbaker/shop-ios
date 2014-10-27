//
//  VIAppDelegate.m
//  Shoprise_EN
//
//  Created by mk on 4/1/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIAppDelegate.h"
#import "VIViewController.h"
#import "VINavigationController.h"
#import "VIMenusViewController.h"
#import <Shoprize/VIWelcomeViewController.h>
#import <Shoprize/REFrostedViewController.h>
#import <Shoprize/REFrostedContainerViewController.h>
#import <Shoprize/VITutorialViewController.h>
#import <Shoprize/VIReedemViewController.h>
#import <Shoprize/KUtils.h>

#import <QuartzCore/QuartzCore.h>
#import <iSQLite/iSQLite.h>

#import "VINearByViewController.h"
#import "VILocalNotify.h"
#import "VIUncaughtExceptionHandler.h"

@interface VIAppDelegate() {
     REFrostedViewController *frostedViewController;
}

@end

@implementation VIAppDelegate


- (void)openIt:(NSDictionary *)info
{
    if(info != nil)
    {
        VIReedemViewController *dm = [[VIReedemViewController alloc] init];
        [dm setValueToContent:info forKey:@"VIReedemViewController"] ;
        [[self pushStack] pushViewController:dm animated:YES];
    }
    
    [self startScan];
    
    DEBUGS(@"已经划开");
}

- (void)openPopSuprise:(NSNotification *)noti
{
    //显示弹出数据框，后台进程
    VIBigSuprise *sp = [[VIBigSuprise alloc] initWithFrame:self.window.bounds dict:noti.object];
    sp.delegate = self;
    [self.window addSubview:sp];
    [sp openSuprise];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:^{
        [VIFile deleteFile:logpath];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
         [VIFile deleteFile:logpath];
    }else{
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        picker.mailComposeDelegate = self;
        [picker setSubject:Fmt(@"[Shoprize][App Crash] %@ ",[NSDate now])];
        [picker setToRecipients:@[@"xianhong@techwuli.com"]];
        NSData *data = [NSData dataWithContentsOfFile:logpath];
        [picker addAttachmentData:data mimeType:@"application/octet-stream" fileName:@"crashfile.crash"];
        
        UINavigationController *v = (UINavigationController*) ((REFrostedViewController *)[self.window rootViewController]).contentViewController;
        [[v topViewController] presentViewController:picker animated:NO completion:^{
            
        }];
    }
}

static NSString *logpath;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [VIUncaughtExceptionHandler setDefaultHandler];
    [[VIUncaughtExceptionHandler instace] checkAndSendMail:^(NSString *path) {
        logpath = path;
        if ([MFMailComposeViewController canSendMail]) {
            [[[UIAlertView alloc] initWithTitle:@"Report" message:@"a crash file found, can you send it to me for fix it ? Thx" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show ];
        }else{
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"Report" message:@"a crash log found, but your device can't send mail please set it first" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alt show];
            [VIFile deleteFile:logpath];
        }
        
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.beancons     = [NSMutableDictionary dictionary];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceBookLogon:) name:@"_facebook_logon_" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNavBarMenu:) name:_NS_NOTIFY_SHOW_MENU object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetIbeancon:) name:@"_ibeancon_reset_" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareText:) name:@"_share_to_facebook_" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPopSuprise:) name:@"_get_a_bigsuprise_" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(add_current_track:) name:@"_add_current_track_" object:nil];

    [[VILogger getLogger] setLogLevelSetting:SLLS_ALL];
    
    VIWelcomeViewController *welcome = [[VIWelcomeViewController alloc] init];
    [self checkToShowGuide:welcome]; //check first page loading
    NSMutableArray *navp = [NSMutableArray arrayWithObject:welcome];
    
    if (![[VINet info:Token] isEqualToString:@""]) {
        [navp addObject:[[VINearByViewController alloc] init]];
    }
    
    VINavigationController *nav = [[VINavigationController alloc] init];
    [nav setViewControllers:navp animated:YES];
    nav.navigationBar.hidden = YES;
    
    VIMenusViewController   *menu = [[VIMenusViewController alloc] init];
    
    frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:nav menuViewController:menu];
    frostedViewController.direction = REFrostedViewControllerDirectionRight;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.menuViewController.view.backgroundColor = [@"#000000" hexColorAlpha:.4];
    
    self.window.rootViewController = frostedViewController;
    [self.window makeKeyAndVisible];
    
    //Location Manager start motion
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 1; //精度1m
    
    DEBUGS(@"DEBUG %d",[CLLocationManager locationServicesEnabled]);
    
    // ios 8的情况
#ifdef __IPHONE_8_0
    if([[self locationManager] respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    if ([self.locationManager respondsToSelector:@selector(activityType)]) {
        self.locationManager.activityType = CLActivityTypeFitness;
    }
#endif
    
    // 注释掉每周六的周期性提醒
    //[self pushWeekNotifycation];
    
    self.isActive = YES;
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        if (![self localNotifyisOff]) {
            [self.locationManager startUpdatingLocation];
            [self startScan];
        }
    }else{
        #ifdef __IPHONE_8_0
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            [self.locationManager requestWhenInUseAuthorization];
        #endif
    }

//  TOOD CMMT
//  [self openPopSuprise:nil];
//  NSTimer *t = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(repaint) userInfo:nil repeats:YES];
//  NSRunLoop *runloop=[NSRunLoop currentRunLoop];
//  [runloop addTimer:t forMode:NSDefaultRunLoopMode];
    
    return YES;

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
#ifdef __IPHONE_8_0
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            [manager requestWhenInUseAuthorization];
    }
    else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSString *msg = [[[NSBundle mainBundle] infoDictionary] stringValueForKey:@"NSLocationWhenInUseDescription"];
        [VIAlertView showErrorMsg:msg];
    }
    else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
        if (![self localNotifyisOff]) {
            [self.locationManager startUpdatingLocation];
            [self startScan];
        }
    }
#endif

}

-(void)repaint
{
    [self locationManager:self.locationManager didUpdateLocations: @[[[CLLocation alloc] initWithLatitude:29.570809 longitude:106.5008184]]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if (locations!=nil && locations.count > 0) {
        //save user Info
        CLLocation *location = [locations objectAtIndex:0];
        [[NSUserDefaults standardUserDefaults] setValue:Fmt(@"%.7f,%.7f",location.coordinate.latitude,location.coordinate.longitude) forKey:@"location"];
        
        [self calcUserIsInMall:location];
        
        //[self calcUserNearStore:[locations objectAtIndex:0]];
        [self calcIfOpenNewMall:[locations objectAtIndex:0]];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    [self locationManagerFindRangeBeacons:beacons inRegion:region];
}

- (void)calcIfOpenNewMall:(CLLocation *)location {
    MallInfo *nearest = [MallInfo nearestMall];
    if (nearest!=nil) {
        if(nearest.distance < _NEAREST_PLACE_KM_){
            NSString *mid = [nearest MallAddressId];
            NSString *cid = [self.currentMall MallAddressId];
            if ([mid isEqualToString:cid]) {
                Timestamps *ts = [[iSQLiteHelper getDefaultHelper] searchSingle:[Timestamps class] where:Fmt(@" stampId = '%@'",cid) orderBy:@"time"];
                if (ts == nil || abs(ts.time - [[NSDate date] timeIntervalSince1970]) > 10 * 60) {
                    [Timestamps setMallRefrshTime:cid];
                }else{
                    return;
                }
            }
            [NSUserDefaults setValue:[nearest MallAddressId] forKey:@"_post_mall_id_"];
            [[NSNotificationCenter defaultCenter] postNotificationName:_NOTIFY_MALL_CHANGED object:[nearest toDictionary] userInfo:nil];
        }
    }else{
        [NSUserDefaults setValue:@"" forKey:@"_post_mall_id_"];
        [NSUserDefaults setValue:@"" forKey:@"_post_store_id_"];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    DEBUGS(@"%@",error.description);
}

//remove gps welcome
// 已经在上面注释掉了
//- (void)calcUserNearStore:(CLLocation *)location
//{
//    NSArray *stroes = [@"stores" cacheValue];
//    if (stroes.count !=0 )  { //if had load address
//        //这个值会在切换Mall之后清空掉
//        NSString *lastPlace = [[NSUserDefaults standardUserDefaults] stringForKey:@"storeview"];
//        NSMutableArray *vistedIds = [NSMutableArray array];
//        if (lastPlace != nil) {
//            vistedIds = [[lastPlace jsonVal] mutableCopy];
//        }
//        for (NSDictionary *dct in stroes) {
//            double lat = [dct doubleValueForKey:@"Lat"];
//            double lon = [dct doubleValueForKey:@"Lon"];
//            CLLocation *target = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
//            CLLocationDistance dis = [location distanceFromLocation:target];
//            
//            NSString *addressId = [dct stringValueForKey:@"AddressId"];
//            if (dis <= 10 && ![vistedIds containsObject:addressId]) {
//                NSString *mallName = [dct stringValueForKey:@"StoreName"];
//                NSString *uname    = [VINet info:KFull];
//                NSString *msg = Fmt(Lang(@"welcome_store"),uname,mallName);
//                
//                NSMutableDictionary *mt = [NSMutableDictionary dictionary];
//                [mt setValue:@"Store" forKey:@"NotifyType"];
//                [mt setValue:addressId forKey:@"Udid"];
//                
//                [self pushNotification:msg withObj:mt];
//                [vistedIds addObject:addressId];
//
//                [[NSUserDefaults standardUserDefaults]  setValue:[vistedIds jsonString] forKey:@"storeview"];
//
//                break;
//            }
//        }
//    }
//}

//已经在上面注释掉了调研
-(void)calcUserIsInMall:(CLLocation*)location
{
    MallInfo *nearest = [MallInfo nearestMall];
    if (nearest !=nil && nearest.distance< _NEAREST_PLACE_KM_ )  { //if had load address
        VisitStep *visted = [VisitStep insertStep:@"mall" value:nearest.MallAddressId];
        if (visted==nil || ([[NSDate date] timeIntervalSince1970] - visted.time) > 5 * 60) {
            VisitStep *v = [[VisitStep alloc] init];
            [v setType:@"mall"];
            [v setID:nearest.MallAddressId];
            [visted setTime:[[NSDate date] timeIntervalSince1970]];
            [[iSQLiteHelper getDefaultHelper] insertOrUpdateUsingObj:visted];
            
            NSString *mallName = nearest.Name;
            NSString *uname    = [VINet info:KFull];
            NSString *msg = Fmt(Lang(@"welcome_mall"),uname,mallName);
            
            NSMutableDictionary *mt = [NSMutableDictionary dictionary];
            [mt setValue:@"Mall" forKey:@"NotifyType"];
            [mt setValue:nearest.MallAddressId forKey:@"Udid"];
            // 禁止掉通知信息
            [self pushNotification:msg withObj:mt];
        }else if(visted!=nil){
            [visted setTime:[[NSDate date] timeIntervalSince1970]];
            [[iSQLiteHelper getDefaultHelper] insertOrUpdateUsingObj:visted];
            //NSLog(@"Update: %@",visted);
        }
    }
}

- (void)resetIbeancon:(NSNotification *)notify {
    
    NSMutableArray *mtb = [[iSQLiteHelper getDefaultHelper] searchAllModel:[Beacon class]];
    self.beancons = [NSMutableDictionary dictionary];
    for (Beacon *bc in mtb) {
        if ([bc isIbeacon])
            [self.beancons setValue:bc forKey:[bc getBcUpCase]];
     }
    [self resetIbeaonScan];
}


// If get a suprize from
- (void)rewardComplete:(id)values{
    
    UserSurprise *surp = [[UserSurprise alloc] initWithDictionary:values error:nil];
    
    LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
    [helper insertOrUpdateUsingObj:surp];
    
    MobiPromo *mobi  = [helper searchSingle:[MobiPromo class] where:@{@"MobiPromoId":surp.MobiPromoId} orderBy:@"MobiPromoId"];
    NSString *uname    = [VINet info:KFull];
    NSString *msg = Fmt(Lang(@"welcome_in"),uname,mobi.StoreName);
    NSMutableDictionary *mt = [NSMutableDictionary dictionary];
    
    [mt setValue:@"Promos" forKey:@"NotifyType"];
    [mt setValue:mobi.MobiPromoId forKey:@"Udid"];
    
    if ([self isActive]) {
        [self sendOpenSupriseNotify:[mobi toDictionary]];
    }else{
        [mt setValue:[mobi toDictionary] forKey:@"suprise"];
        [self startScan];
    }
    [self pushNotification:msg withObj:mt];
}


#pragma mark 激活失败

- (void)rewardFail:(id)values{
    [self startScan];
    DEBUGS(@"%@",values);
}

- (void)showNavBarMenu:(NSNotification *)notify{
    REFrostedViewController *re = ((REFrostedViewController *)self.window.rootViewController);
    
    [[re menuViewController].view label4Tag:-102].text = Fmt(@"%@ %@",[VINet info:FName],[VINet info:LName]);
    [[re menuViewController].view egoimageView4Tag:-2000].imageURL = [NSURL URLWithString:[VINet info:KHead]];
    
    int count = [[iSQLiteHelper getDefaultHelper] rowCount:[UserSurprise class] where:@" Redeemed = 0 and ExpireTime > datetime('now','localtime') "];
  
    [[re menuViewController].view label4Tag:-1000].text = Fmt(@"%d",count);
    [[[re menuViewController].view imageView4Tag:-1001] setHidden:count == 0];
    [[[re menuViewController].view label4Tag:-1000] setHidden:count == 0];
    
    [re presentMenuViewController];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)add_current_track:(NSNotification *)notfiy
{
    NSMutableDictionary *values = [notfiy.object mutableCopy];
    [values setValue:[_currentMall MallAddressId] forKey:@"MallAddressId"];
    [VINet post:Fmt(@"/api/tracks/%@/%@",[values stringValueForKey:@"Type"],[values stringValueForKey:@"ReferenceId"]) args:values target:self succ:@selector(sleepNow:) error:@selector(sleepNow:) inv:nil];
}

-(void)sleepNow:(id)value{
    DEBUGS(@"Nothing todo Resp:%@",value);
}

- (void)checkToShowGuide:(UIViewController *)first
{
    BOOL hadUserd = [[NSUserDefaults standardUserDefaults] boolForKey:@"userHasUsed"];
    if (!hadUserd) {
        VITutorialViewController *torle = [[VITutorialViewController alloc] initWithPath:@[@"tor_1.png",@"tor_2.png",@"tor_3.png",@"tor_4.png"]];
        
        UIImageView *t1 = [@"logo.png" imageViewForImgSizeAtX:0 Y:80];
        [torle addView:t1 page:0];
        UILabel *txt = [VILabel createLableWithFrame:Frm(36, t1.endY,t1.w - 72  , 40) color:@"#ffffff" font:FontPekanRegular(18) align:CENTER];
        txt.numberOfLines = 2;
        txt.text = Lang(@"index_welcome_01");
        [torle addView:txt page:0];
        int y = IS_RETINA_4 ? 220 : 180;
        UIImageView *t2 = [@"search.png" imageViewForImgSizeAtX:111.5 Y:y];
        [torle addView:t2 page:1];
        txt = [VILabel createLableWithFrame:Frm(36, t2.endY,t1.w - 72  , 40) color:@"#ffffff" font:FontPekanRegular(18) align:CENTER];
        txt.numberOfLines = 2;
        txt.text = Lang(@"index_welcome_02");
        [torle addView:txt page:1];
        
        t2 = [@"gift.png" imageViewForImgSizeAtX:111.5 Y:y];
        [torle addView:t2 page:2];
        txt = [VILabel createLableWithFrame:Frm(36, t2.endY,t1.w - 72  , 40) color:@"#ffffff" font:FontPekanRegular(18) align:CENTER];
        txt.numberOfLines = 2;
        txt.text = Lang(@"index_welcome_03");
        [torle addView:txt page:2];
        
        
        t2 = [@"heart.png" imageViewForImgSizeAtX:111.5 Y:y];
        [torle addView:t2 page:3];
        txt = [VILabel createLableWithFrame:Frm(30, t2.endY,t1.w - 60  , 60) color:@"#ffffff" font:FontPekanRegular(16) align:CENTER];
        txt.numberOfLines = 3;
        txt.text = Lang(@"index_welcome_04");
        [torle addView:txt page:3];
        
        [first addChildViewController:torle];
        [first.view addSubview:torle.view];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.isActive = NO;
    
    if ([CLLocationManager locationServicesEnabled] &&
        [CLLocationManager significantLocationChangeMonitoringAvailable])
    {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.isActive = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.isActive = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    self.isActive = NO;
    [self.locationManager stopUpdatingLocation];
    //clear all
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    [self.session close];
    self.session = nil;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:self.session];
}

- (void)initSesstion{
    if (!_session.isOpen) {
        self.session = [[FBSession alloc] initWithPermissions:@[@"public_profile",@"publish_actions",@"email", @"user_friends"]];
        if (_session.state == FBSessionStateCreatedTokenLoaded) {
                //如果已经加载了就不用了
        }
    }
}

- (void)sendOpenSupriseNotify:(NSDictionary*)pp
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_get_a_bigsuprise_" object:pp];
 }

- (UINavigationController *)pushStack
{
    return ((VINavigationController*) [frostedViewController contentViewController]);
}

- (void)faceBookLogon:(id)value
{
    if (_session.isOpen) {
        [_session closeAndClearTokenInformation];
    }
    self.session= nil;
    if (_session == nil) {
        self.session = [[FBSession alloc] initWithPermissions:@[@"public_profile",@"publish_actions",@"email", @"user_friends"]];
    }
    
    [_session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        [FBSession setActiveSession:session];
        if (FBSession.activeSession.isOpen) {
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,NSDictionary<FBGraphUser> *user,NSError *error) {
                 if (!error) {
                     NSString *firstName    =   user.first_name;
                     NSString *lastName     =   user.last_name;
                     NSString *facebookId   =   [user objectForKey:@"id"];
                     NSString *email        =   [user objectForKey:@"email"];
                     NSString *imageUrl     =   [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture?type=large",facebookId];
                     NSString *token = [FBSession activeSession].accessTokenData.accessToken;
                   
                     NSMutableDictionary *fb = [NSMutableDictionary dictionary];
                     [fb setValue:email forKey:@"UserName"];
                     [fb setValue:firstName forKey:@"FirstName"];
                     [fb setValue:lastName forKey:@"LastName"];
                     [fb setValue:imageUrl forKey:@"PictureUrl"];
                     [fb setValue:facebookId forKey:@"UserId"];
                     [fb setValue:token forKey:@"Token"];
                    
                     [VINet post:@"/api/Account/FacebookLogin" args:fb target:self succ:@selector(doSuccessReq:) error:@selector(doFailReq:) inv:self.window];
                 }else{
                     [VIAlertView showErrorMsg:error.description];
                 }
             }];
        }else{
            [[FBSession activeSession] closeAndClearTokenInformation];
        }
    }];
}

- (void)doSuccessReq:(id)values
{
    [[NSUserDefaults standardUserDefaults] setValue:[values jsonString] forKey:@"USER_INFO_MATION"];
    VINavigationController *nav = (VINavigationController*)[((REFrostedViewController *) self.window.rootViewController) contentViewController];
    [((VIBaseViewController *) [nav topViewController]) saveUserInfo:values];
    [((VIBaseViewController *) [nav topViewController]) pushTo:@"VINearByViewController"];
}

- (void)doFailReq:(id)values
{
    [VIAlertView showErrorDict:values];
}

- (BOOL)localNotifyisOff {
   return [[NSUserDefaults standardUserDefaults]  boolForKey:@"_close_notification_"];
}

- (void)shareText:(NSNotification *)notify
{
    NSDictionary *shareInfo = notify.object;
    if([FBSession activeSession].isOpen){
        [self doPostMessage2FaceBook:shareInfo];
    }else {
        NSArray *ps = [NSArray arrayWithObjects:@"publish_actions", nil];
        [FBSession openActiveSessionWithPublishPermissions:ps defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            if (error) {
                [VIAlertView showMessageWithTitle:@"" msg:error.localizedDescription];
            } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                [self doPostMessage2FaceBook:shareInfo];
            }
        }];
    }
}

- (void)pushWeekNotifycation
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *notifys = [app scheduledLocalNotifications];
    for (UILocalNotification *local in notifys) {
        if([[local.userInfo stringValueForKey:@"NotifyType"] isEqualToString:@"Week"])
        {
            [app cancelLocalNotification:local];
        }
    }
    
    int weekindex = [[NSDate date] weekValue];
    if (weekindex <= 5) {
        weekindex = 5 - weekindex;
    }else{
        weekindex = 5 - weekindex ;
    }
    
    NSDate *dte = [[NSDate now] addDay:weekindex];
    NSString *fmter = [[dte format:@"yyyy-MM-dd"] stringByAppendingString:@" 09:30:00"];
    NSDate *firdate = [fmter parse:@"yyyy-MM-dd HH:mm:ss"];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = firdate;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = NSWeekCalendarUnit; //每周重复
    notification.userInfo = @{@"NotifyType": @"Week"};

    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.alertBody = Lang(@"weekend_come");
    
    [app scheduleLocalNotification:notification];
    
    DEBUGS(@"启动通知：%@",notification);
}

-(void)pushNotification:(NSString *)text withObj:(id)obj
{
   DEBUGS(@"Start Push Local Message!!!");
    if (self.isActive){
        DEBUGS(@"%@",UILocalNotificationDefaultSoundName);
        [VILocalNotify showPopNotify:text obj:obj];
    }else{
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [[NSDate now] addSecond:2];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.repeatInterval = 0;
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody = text;
        notification.userInfo = obj;
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:notification];
    }
    
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber = 0;
    if (!self.isActive){
        DEBUGS(@"获得通知");
        [self cancelNotifyCation:notification];
        
        if ([[notification.userInfo stringValueForKey:@"NotifyType"] isEqualToString:@"Store"])
        {
            VIBaseViewController *b = [[NSClassFromString(@"VIStoreDetailViewController") alloc] init];
            [b setValueToContent:notification.userInfo forKey:@"push_in"];
            VIAppDelegate *app = (VIAppDelegate *)[UIApplication sharedApplication].delegate;
            [[app pushStack] pushViewController:b animated:YES];
        }
        
        if ([[notification.userInfo stringValueForKey:@"NotifyType"] isEqualToString:@"Promos"])
        {
            NSDictionary *allinfo = [notification.userInfo objectForKey:@"suprise"];
            if (allinfo!=nil) {
                [self performSelector:@selector(sendOpenSupriseNotify:) withObject:allinfo afterDelay:1.5];
                //[self sendOpenSupriseNotify:allinfo];
            }
        }
    }
    // When The App is Running ， when you click this you will goto the app
    else{
        [self cancelNotifyCation:notification];
    }
    //[self cancelNotifyCation:notification];
}


- (void)cancelNotifyCation:(UILocalNotification *)notify
{
    if (notify != nil) {
        [[UIApplication sharedApplication] cancelLocalNotification:notify];
    }else{
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

- (void)cancelShare:(UITapGestureRecognizer *)tap
{
    [self cancelShareAct:nil];
}

- (void)cancelShareAct:(UIButton *)btn
{
    UIView *tap = [self.window viewWithTag:-2000];
    UIView *target = [tap viewWithTag:18000];
    [UIView animateWithDuration:.2 animations:^{
        [target setY:- target.h];
    } completion:^(BOOL finished) {
        [tap removeFromSuperview];
    }];
}

static NSMutableDictionary *shareInfo;

-(void)doPostMessage2FaceBook:(NSDictionary *)msgs{
    
    shareInfo = [msgs mutableCopy];
    
    UIView *bd = [[UIView alloc] initWithFrame:self.window.bounds];
    bd.tag = -2000;
    bd.backgroundColor = [@"#000000" hexColorAlpha:.6];
    
    [bd addTapTarget:self action:@selector(cancelShare:)];
    UIView *v = [VIBaseViewController loadXibView:@"UI.xib" withTag:18000];
    [v setX:(self.window.w - v.w)/2];
    [v setY:-v.h];
    
    v.layer.borderWidth = 1.2;
    v.layer.shadowOffset = CGSizeMake(-1, 1);
    v.layer.shadowColor = [@"#FFFFFF" hexColor].CGColor;
    v.layer.borderColor = [@"#D1D1D1" hexColor].CGColor;
    v.layer.cornerRadius = 8;
    
    UITextView *t = ((UITextView *)[v viewWithTag:18003]);
    t.font = _FontPekanRegular(14);
    t.text = [msgs objectForKey:@"description"];
    t.textAlignment = NSTextAlignmentRight;
    [t becomeFirstResponder];
    
    [(UIButton *)[v viewWithTag:18001] setTitle:Lang(@"share_cancel") hightTitle:Lang(@"share_cancel")];
    ((UIButton *)[v viewWithTag:18001]).titleLabel.font = FontPekanBold(16);
    [((UIButton *)[v viewWithTag:18001]) addTapTarget:self action:@selector(cancelShareAct:)];
    [((UIButton *)[v viewWithTag:18002]) addTapTarget:self action:@selector(shareNow:)];
    [((UIButton *)[v viewWithTag:18002]) setTitle:Lang(@"share_ok") hightTitle:Lang(@"share_ok")];
    ((UIButton *)[v viewWithTag:18002]).titleLabel.font = FontPekanBold(16);
    id pic = [msgs objectForKey:@"picture"];
    if ([pic isKindOfClass:[NSString class]]) {
        pic = [NSURL URLWithString:pic];
    }
    
    [v egoimageView4Tag:18004].imageURL = pic;
    
    [bd addSubview:v];
    
    [self.window addSubview:bd];
    
    [UIView animateWithDuration:.3 animations:^{
        [v setY:20];
    }];
   
}

- (void)shareNow:(UIButton *)share
{
     NSString *viewt = ((UITextView *)[self.window viewWithTag:18003]).text;
    
     [shareInfo setValue:viewt forKey:@"description"];
    
     NSMutableDictionary *postInfo = [NSMutableDictionary dictionary];
     id pic = [shareInfo objectForKey:@"picture"];
     if ([pic isKindOfClass:[NSURL class]]) {
         pic = [pic absoluteString];
     }
     [postInfo setValue:pic forKey:@"picture"];
     [postInfo setValue:[shareInfo objectForKey:@"description"] forKey:@"description"];
     [postInfo setValue:[shareInfo objectForKey:@"name"] forKey:@"name"];
     
     NSString *stringUrl = [shareInfo objectForKey:@"link"];
     if (![[stringUrl stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
     [postInfo setValue:stringUrl forKey:@"link"];
     }
     
     [FBRequestConnection
     startWithGraphPath:@"me/feed" parameters:postInfo HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
     id result, NSError *error) {
     NSString *alertText;
     if (error) {
         ERROR(@"Facebook Share:%@",error.description);
         alertText  = [@"share2facebook_no" lang];
     } else {
         alertText  = [@"share2facebook_ok" lang];
         [self cancelShareAct:nil];
     }
         [VIAlertView showMessageWithTitle:@"" msg:alertText];
     }];
}

@end


@implementation VIAppDelegate(iBeacon)

- (void)addUUID:(NSString *)uuid{
    NSUUID *uid = [[NSUUID alloc] initWithUUIDString:uuid];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uid identifier:[uid UUIDString]];
    if (region!=nil) {
         self.rangedRegions[region] = [NSArray array];
    }
}

- (void)addUUIDs:(NSArray *)uuids {
    for (NSString *uuid in uuids) { [self addUUID:uuid]; }
}

static bool scaning = NO;
- (void)startScan
{
    if ([self localNotifyisOff]) {
        return;
    }
    for (CLBeaconRegion *region in self.rangedRegions) {
        [self.locationManager startRangingBeaconsInRegion:region];
    }
    scaning = YES;
}

- (void)stopScan{
    for (CLBeaconRegion *region in self.rangedRegions) {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
    scaning = NO;
}

- (BOOL)isScaning {
    return scaning;
}
- (void)locationManagerFindRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    NSMutableDictionary *allNearBeacons = [NSMutableDictionary dictionary];
    self.rangedRegions[region] = beacons;
    
    NSMutableArray *allBeacons = [NSMutableArray array];
    for (NSArray *regionResult in [self.rangedRegions allValues]) {
        [allBeacons addObjectsFromArray:regionResult];
    }
    for (NSNumber *range in @[@(CLProximityUnknown), @(CLProximityImmediate), @(CLProximityNear), @(CLProximityFar)])
    {
        NSArray *proximityBeacons = [allBeacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", [range intValue]]];
        if([proximityBeacons count]) {
            allNearBeacons[range] = proximityBeacons;
        }
    }
    NSArray *near = [allNearBeacons objectForKey:@(2)];
    
    have_stroe_around_me = NO;
    for (CLBeacon *bean in near) {
        [self cheackAndRedeem:bean];
    }
    if (!have_stroe_around_me)
        [NSUserDefaults setValue:@"" forKey:@"_post_store_id_"];
}
static BOOL have_stroe_around_me;
BOOL reading = NO;

- (void)cheackAndRedeem:(CLBeacon *)bean{
    
    NSString *uuid = [[bean proximityUUID] UUIDString];
    Beacon *infos = [[self beancons] objectForKey:uuid];
    if (bean.accuracy < [infos.SignalRadius doubleValue]) {
        
        if (!scaning) {
            return;
        }
        
        [NSUserDefaults setValue:infos.AddressId forKey:@"_post_store_id_"];
        have_stroe_around_me = YES;
        
        LKDBHelper *help = [iSQLiteHelper getDefaultHelper];
        
        //VisitStep *visted  = [VisitStep insertStep:@"viewstore" value:infos.AddressId];
        NSLog(@"You are round At:%@ ",infos.AddressId);
        
        NSString *sql = Fmt(@"select * from MobiPromo t where t.Type='Surprise' and t.AddressId ='%@' and t.Prerequisite like '%%InStore%%' and not EXISTS(select * from UserSurprise u where t.MobiPromoId = u.MobiPromoId )",infos.AddressId);
        NSMutableArray *proms = [help searchWithSQL:sql toClass:[MobiPromo class]];
        
//        进店欢迎@{@"Type":@"Surprise",@"AddressId":infos.AddressId}
//        if (NO && ![vistedIds containsObject:addressId] && !reading) {
//            reading = YES;
//            NSString *uname    = [VINet info:KFull];
//            NSString *msg = Fmt(Lang(@"welcome_store"),uname,[surpriseMobi stringValueForKey:@"StoreName"]);
//            NSMutableDictionary *mt = [NSMutableDictionary dictionary];
//            [mt setValue:@"Store" forKey:@"NotifyType"];
//            [mt setValue:addressId forKey:@"Udid"];
//            
//            [vistedIds addObject:addressId];
//            [NSUserDefaults setValue:[vistedIds jsonString] forKey:@"visit_store_list"];
//            [self pushNotification:msg withObj:mt];
//            reading = NO;
//        }
        
        //if not hvae return
        if (proms.count == 0) { return; }
        
        for(MobiPromo *curtMobi in proms)
        {
            id jsonValue = [[curtMobi Prerequisite] jsonVal];
            if(jsonValue == nil || [jsonValue allKeys].count == 0)
            continue;
            
            if([[jsonValue stringValueForKey:@"Type" defaultValue:@""] isEqualToString:@"InStore"])
            {
                NSString *starT = [jsonValue stringValueForKey:@"StartTime"];
                int mins = 0;
                if ([starT hasString:@":"]) {
                    NSArray *time = [[jsonValue stringValueForKey:@"StartTime"] componentsSeparatedByString:@":"];
                    mins = [[time objectAtIndex:0] intValue] * 60 + [[time objectAtIndex:1] intValue];
                }else{
                    mins = [starT intValue];
                }
                
                NSDate *now = [NSDate now];
                int nowval = [[now format:@"HH"] intValue] * 60 + [[now format:@"mm"] intValue];
                
                if (nowval>=mins && [self isScaning]) {
                    [self stopScan];
                    [VINet post:Fmt(@"/api/mobipromos/%@/at/%@/reward",curtMobi.MobiPromoId,curtMobi.AddressId) args:nil target:self succ:@selector(rewardComplete:) error:@selector(rewardFail:) inv:nil];
                }
            }
        }
        
    }
}

- (void)resetIbeaonScan
{
    [self stopScan];
    self.rangedRegions = [NSMutableDictionary dictionary];
    [self addUUIDs:[self.beancons allKeys]];
    [self startScan];
}

@end
