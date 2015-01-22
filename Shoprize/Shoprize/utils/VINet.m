//
//  VINet.m
//  Shoprose
//
//  Created by vnidev on 4/29/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "VINet.h"
#import <VICore/VICore.h>
#import "Fonts.h"
#import "Models.h"

@implementation VINet

static long loadedViewID2;
static NSMutableArray *httpQueen2;

static NSMutableArray *beancons;
static NSMutableDictionary *stores;

+ (NSString *)info:(KInfo)info {
    id values = [[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_INFO_MATION"] jsonVal];
    if (values == nil)
        return @"";
    switch (info) {
        case Mail:
            return [values stringValueForKey:@"userName" defaultValue:@""];
        case FName:
            return [values stringValueForKey:@"firstName" defaultValue:@""];
        case LName:
            return [values stringValueForKey:@"lastName" defaultValue:@""];
        case Phone:
            return [values stringValueForKey:@"phone" defaultValue:@""];
        case userId:
            return Fmt(@"%d", [values intValueForKey:@"userId"]);
        case Expires:
            return [values stringValueForKey:@".expires" defaultValue:@""];
        case Token:
            return [values stringValueForKey:@"access_token" defaultValue:@""];
        case KHead:
            return [values stringValueForKey:@"pictureUrl" defaultValue:@""];
        case KUserId:
            return [values stringValueForKey:@"userId" defaultValue:@""];
        case Kbirth:
            return [values stringValueForKey:@"birthday" defaultValue:@""];
        case Sex:
            return [values stringValueForKey:@"gender" defaultValue:@""];
        case KFull :
            return Fmt(@"%@ %@", [VINet info:FName], [VINet info:LName]);
        default:
            break;
    }
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_INFO_MATION"];
}

+ (void)viewDidload:(UIViewController *)ctrl {
    loadedViewID2 = [ctrl hashLongValue];
}

+ (void)viewWillAappear:(UIViewController *)ctrl {
    long apper = [ctrl hashLongValue]; //用来处理返回的时候的操作
    if (apper != loadedViewID2) {
        [VINet stopHttpWithHash:loadedViewID2];
        loadedViewID2 = apper;
    }
}

+ (void)viewDidDisAappear:(UIViewController *)ctrl {
    [VINet stopHttpWithHash:[ctrl hashLongValue]];
}

+ (void)stopHttpWithHash:(long)httpHasId {
    NSMutableArray *nd = [NSMutableArray array];
    for (VINet *kit in httpQueen2) {
        if (kit.hashVal == httpHasId) {
            [kit.operation cancel];
            [kit hideHUDView];
            [nd addObject:kit];
        }
    }
    [httpQueen2 removeObjectsInArray:nd];
}

- (BOOL)isReachableNetwork {
    VTReachability *reachability = [VTReachability reachabilityWithHostname:@"www.bing.com"];
    return [reachability isReachable];
}

+ (VINet *)instance {
    if (httpQueen2 == nil) {
        httpQueen2 = [[NSMutableArray alloc] init];
    }
    VINet *req = [[VINet alloc] init];
    req.hashVal = loadedViewID2;
    [httpQueen2 addObject:req];
    return req;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
+ (void)invokeApi:(NSString *)api args:(id)args target:(id)_target succ:(SEL)succ error:(SEL)error method:(HTTP_METHOD_TYPE)method withWait:(UIView *)waitView {

    NSString *apiURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"baseURL"];
    if ([api hasPrefix:@"http://"] || [api hasPrefix:@"https://"]) {
        apiURL = @"";
    }
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    if (args != nil) {
        [mutableDict addEntriesFromDictionary:args];
    }

    if (method == HTTP_MD_GET) {
        NSMutableString *subArg = [NSMutableString string];
        for (NSString *key in [mutableDict allKeys]) {
            [subArg appendFormat:@"&%@=%@", key, [mutableDict objectForKey:key]];
        }
        if ([api rangeOfString:@"?"].location == NSNotFound) {
            if ([mutableDict allKeys].count > 0) {
                subArg = [NSMutableString stringWithString:[subArg substringFromIndex:1]];
            }
            api = [apiURL stringByAppendingFormat:@"%@?%@", api, subArg];
        }
        else {
            api = [apiURL stringByAppendingFormat:@"%@%@", api, subArg];
        }
        mutableDict = nil;
    }
    else {
        api = [apiURL stringByAppendingString:api];
    }

    if ([api hasSuffix:@"?"]) {
        api = [api substringToIndex:[api length] - 1];
    }

    NSDictionary *baseArgs = [NSDictionary dictionaryWithObjectsAndKeys:api, @"_Api_Keys", mutableDict, @"_Api_Vals", nil];

    VINet *req = [VINet instance];
    req.succ = succ;
    req.fail = error;
    req.target = _target;
    req.waitInView = waitView;
    req.extraArg = [baseArgs mutableCopy];
    req.method = method;

    if (![req isReachableNetwork]) {
        NSMutableDictionary *error = [NSMutableDictionary dictionary];
        [error setValue:@"-1004" forKey:@"status"];
        [error setValue:[@"00026" lang] forKey:@"message"];
        IMP imp = [req.target methodForSelector:req.fail];
        void (*func)(id, SEL, id e) = (void *) imp;
        func(req.target, req.fail, error);
        return;
    }

    //[req auth:NO];

    if (req.waitInView != nil) {
        VIMBProgressHUD *hd = [VIMBProgressHUD showHUDAddedTo:req.waitInView animated:YES];
        if (isHe) {
            UIImageView *imgv = [@"shoprise_extra.png" imageView];
            [imgv setW:imgv.w/2 andH:imgv.h/2];
            hd.customView = imgv;
            hd.color = [UIColor clearColor];
            hd.animationType = MBProgressHUDAnimationZoom;
            hd.mode = MBProgressHUDModeCustomView;
            hd.backgroundColor = [@"#000000" hexColorAlpha:.4];
                
            UIActivityIndicatorView *acti = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [acti setFrame:Frm((hd.w - 30) / 2, (hd.h - 30) / 2 + 35, 30, 30)];
            [acti startAnimating];
            [hd addSubview:acti];

        }

        hd.removeFromSuperViewOnHide = YES;
        hd.labelFont = [UIFont systemFontOfSize:12];

    }

    [req performSelectorInBackground:@selector(submitForm:) withObject:baseArgs];
}

+ (void)get:(NSString *)api args:(id)args target:(id)_target succ:(SEL)success error:(SEL)error inv:(UIView *)view {
    [VINet invokeApi:api args:args target:_target succ:success error:error method:HTTP_MD_GET withWait:view];
}

+ (void)post:(NSString *)api args:(id)args target:(id)_target succ:(SEL)success error:(SEL)error inv:(UIView *)view {
    [VINet invokeApi:api args:args target:_target succ:success error:error method:HTTP_MD_POST withWait:view];
}

+ (void)del:(NSString *)api target:(id)_target succ:(SEL)success error:(SEL)error inv:(UIView *)view {
    [VINet invokeApi:api args:nil target:_target succ:success error:error method:HTTP_MD_DELETE withWait:view];
}

- (void)auth:(BOOL)focuse {
    id token = [[NSUserDefaults standardUserDefaults] objectForKey:@"k4_ACCESS_TOKEN"];
    if (token == nil || focuse) {
        NSString *apptoken = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"apptoken"];
        NSString *authURL = Fmt(@"%@/api/auth?apptoken=%@", [App baseURL], apptoken);
        NSError *reqEr;
        NSString *resp = [NSString stringWithContentsOfURL:[NSURL URLWithString:authURL] encoding:NSUTF8StringEncoding error:&reqEr];
        id jsonValue = [resp jsonVal];
        if (reqEr == nil && jsonValue != nil) {
            NSString *act = [jsonValue objectForKey:@"AccessToken"];
            [[NSUserDefaults standardUserDefaults] setValue:act forKey:@"k4_ACCESS_TOKEN"];
        }
    }
}

+ (double)radians:(double)x {
    return x * M_PI / 180;
}

#define radius 6378.16;

+ (double)distancOfTwolat1:(double)lat1 lon1:(double)lon1 lat2:(double)lat2 lon2:(double)lon2 {
    
    CLLocation *l1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:lon1];
    CLLocation *l2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
    CLLocationDistance distance = [l1 distanceFromLocation:l2];
    return distance / 1000;
}

+ (double)currentLat {
    NSString *lct = [[NSUserDefaults standardUserDefaults] stringForKey:@"location"];
    if (lct != nil) {
        return [[[lct componentsSeparatedByString:@","] objectAtIndex:0] doubleValue];
    }
    return 0;
}

+ (double)currentLon {
    NSString *lct = [[NSUserDefaults standardUserDefaults] stringForKey:@"location"];
    if (lct != nil) {
        return [[[lct componentsSeparatedByString:@","] objectAtIndex:1] doubleValue];
    }
    return 0;
}

+ (void)regPushToken {
    NSString *tokenValue = [NSUserDefaults getValue:@"pushToken"];
    if (tokenValue != nil) {
        [VINet post:@"/api/devices" args:@{@"DeviceToken" : tokenValue, @"ApplicationType" : @"iPhone"} target:self succ:@selector(doNothing:) error:@selector(doNothing:) inv:nil];
    }
}

+ (void)doNothing:(id)val {
    DEBUGS(@"%@", val);
}

+ (double)distanceTo:(double)lat lon:(double)lon {
    return [VINet distancOfTwolat1:[VINet currentLat] lon1:[VINet currentLon] lat2:lat lon2:lon];
}

+ (BOOL)isDebug
{
    NSString *apiURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"baseURL"];
    if ([apiURL indexOf:@"-dev."]!=-1) {
        return YES;
    }
    return NO;
}

//提交表单
- (void)submitForm:(NSMutableDictionary *)baseArg {
    @autoreleasepool {
        NSString *apiName = [baseArg objectForKey:@"_Api_Keys"];
        NSMutableDictionary *queryArgs = [baseArg objectForKey:@"_Api_Vals"];

        MKNetworkEngine *engine = [[MKNetworkEngine alloc] initWithHostName:[apiName host]];
        MKNetworkOperation *op = [engine operationWithPath:[apiName path]
                                                    params:queryArgs
                                                httpMethod:[self httpTypeString:self.method]];

        DEBUGS(@"-----API------ %@", apiName);
        self.operation = op;
        [op addHeaders:[VINet headers]];

        //添加多媒体信息
        if (queryArgs != nil) {
            [self setMediaToRequest:op params:queryArgs];
        }

        [op addCompletionHandler:^(MKNetworkOperation *completed) {
                    NSString *respontStr = completed.responseString;
                    respontStr = [respontStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    respontStr = [respontStr stringByReplacingOccurrencesOfString:@"1.7976931348623157E+308" withString:@"0"];

                    DEBUGS(@"==========================================DEBUG INFO========================================");
                    DEBUGS(@"%@", respontStr);

                    NSData *jsonData = [respontStr dataUsingEncoding:NSUTF8StringEncoding];

                    NSError *jsonParseError = nil;
                    id requestResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&jsonParseError];
                    if (jsonParseError != nil) {
                        DEBUGS(@"%@", jsonParseError);
                    }

                    [self submitAfterResponsed:completed.HTTPStatusCode responseData:requestResult error:jsonParseError api:apiName];
                }

                    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                        id resjson = [completedOperation responseString];

                        DEBUGS(@"==========================================ERROR INFO========================================");
                        DEBUGS(@"%@", resjson);

                        [self submitAfterResponsed:completedOperation.HTTPStatusCode responseData:resjson error:error api:apiName];
                    }];

        [engine enqueueOperation:op];
    }
}

- (void)submitAfterResponsed:(NSInteger)statusCode responseData:(id)requestResult error:(NSError *)jsonParseError api:(NSString *)apiName {


    if (statusCode == Forbidden) {
        [self resubmitWith403Code];
        return;
    }
        //////////////////////////////////// HTTP 403 /////////////////////////////////////////////
    else if (statusCode >= 200 && statusCode <= 206) {
        if (requestResult == nil) {
            [self submitFormSuccess:@{@"status" : @"200", @"message" : @"complete but no result"}];
        } else if (requestResult != nil && jsonParseError != nil) {
            NSDictionary *error = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"-1", @"status",
                    [@"00003" lang:@"获取数据失败"], @"Message", nil];
            [self submitFormFail:nil cusmInfo:error];
        }
        else {
            [self submitFormSuccess:requestResult];
        }
    }
    else {
        NSMutableDictionary *reu = [NSMutableDictionary dictionary];
        [reu setValue:[NSNumber numberWithInteger:statusCode] forKey:@"status"];
        if (requestResult != nil && ((NSString *) requestResult).length > 0) {
            if ([requestResult intValue] > 0) {
                [reu setValue:Lang(Fmt(@"Http_%@", requestResult)) forKey:@"Message"];
            } else {
                id jsonv = [requestResult jsonVal]; //转化为JSON
                if (jsonv == nil) {
                    DEBUGS(@"%@", requestResult);
                    [reu setValue:Lang(@"Http_0") forKey:@"Message"];
                } else if ([jsonv intValueForKey:@"ErrorCode"] > 0) {
                    NSString *lange = Fmt(@"Http_%d", [jsonv intValueForKey:@"ErrorCode"]);
                    if ([[lange lang] hasPrefix:@"Http_"]) {
                        [reu setValue:[jsonv stringValueForKey:@"Message"] forKey:@"Message"];
                    } else {
                        [reu setValue:[lange lang] forKey:@"Message"];
                    }
                } else if ([jsonv stringValueForKey:@"Message"] != nil ) {
                    [reu setValue:[jsonv stringValueForKey:@"Message"] forKey:@"Message"];
                }
            }
        } else {
            [reu setValue:[@"00026" lang:@"数据异常"] forKey:@"Message"];
        }
        if ([VINet isDebug]) {
            NSString *fmt = Fmt(@"%@\n----Debug----\n%@",[reu stringValueForKey:@"Message"],requestResult);
            [reu setValue:fmt forKey:@"Message"];
        }
        [self submitFormFail:nil cusmInfo:reu];
    }
}

+ (NSDictionary *)headers {
    NSMutableDictionary *head = [NSMutableDictionary dictionary];
    [head setValue:@"Keep-Alive" forKey:@"Connection"];
    [head setValue:@"application/json; charset=utf-8" forKey:@"Accept"];
    [head setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"apptoken"] forKey:@"app_token"];

    //Facebook登陆之前需要先对token进行操作
    NSString *ft = [[NSUserDefaults standardUserDefaults] stringForKey:@"facebook_token"];
    if (ft != nil) {
        [head setValue:Fmt(@"%@ %@", @"Bearer", ft) forKey:@"Authorization"];
    } else if (![[VINet info:Token] isEqualToString:@""]) {
        [head setValue:Fmt(@"%@ %@", @"Bearer", [VINet info:Token]) forKey:@"Authorization"];
    }

    NSString *location = [NSUserDefaults getValue:@"location"];
    if (location != nil && ![location hasPrefix:@"0.0000"]) {
        [head setValue:location forKey:@"location"];
    }
    
    NSString *mallId =  [MallVisit nearestMall];
    
    if (mallId!=nil) {
        [head setValue:mallId forKey:@"MallAddressId"];
    }
    if ([NSUserDefaults getValue:@"_post_store_id_"] != nil && ![[NSUserDefaults getValue:@"_post_store_id_"] isEqualToString:@""]) {
        [head setValue:[NSUserDefaults getValue:@"_post_store_id_"] forKey:@"StoreAddressId"];
    }

    DEBUGS(@"--------------------------------------HEADER------------------------------------------\n%@",head);

    return head;
}

//重新提交表单
- (void)resubmitWith403Code {
    [self auth:YES];
    [self submitForm:self.extraArg];
}

- (void)hideHUDView {
    
    [VIMBProgressHUD hideHUDForView:self.waitInView animated:NO];
}

- (void)submitFormSuccess:(NSDictionary *)backInfo {
    if ([backInfo isKindOfClass:[NSDictionary class]] && [[backInfo objectForKey:@"status"] intValue] == -1) {
        [self submitFormFail:nil cusmInfo:backInfo];
    }
    else {
        [self hideHUDView];
        if (self.succ != nil && self.target!= nil) {
                [self.target performSelectorOnMainThread:self.succ withObject:backInfo waitUntilDone:YES];
        }
    }
}

- (void)submitFormFail:(NSError *)failError cusmInfo:(NSDictionary *)cutmer {
    NSMutableDictionary *eroinfo = nil;
    if (failError != nil) {
        eroinfo = [NSMutableDictionary dictionary];
        NSString *error = [failError.userInfo objectForKey:@"NSLocalizedDescription"];
        [eroinfo setValue:error forKey:@"Message"];
        [eroinfo setValue:[NSNumber numberWithInt:-1] forKey:@"status"];
    }
    else {
        eroinfo = [cutmer mutableCopy];
    }
    DEBUGS(@"Error MSG:%@", eroinfo);
    [self hideHUDView];
    if (self.fail != nil) {
        [self.target performSelectorOnMainThread:self.fail withObject:eroinfo waitUntilDone:YES];
    }
}

@end

@implementation NSDate (gtlt)

- (BOOL)earlyThan:(NSDate *)date {
    switch ([self compare:date]) {
        case NSOrderedSame:
            return NO;
        case NSOrderedAscending:
            return YES;
        case NSOrderedDescending:
            return NO;
        default:
            return NO;
            break;
    }
}

- (BOOL)laterThan:(NSDate *)date {
    switch ([self compare:date]) {
        case NSOrderedSame:
            return NO;
        case NSOrderedAscending:
            return NO;
        case NSOrderedDescending:
            return YES;
        default:
            return NO;
            break;
    }
}

@end