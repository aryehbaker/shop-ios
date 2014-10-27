//
//  VINet.h
//  Shoprose
//
//  Created by vnidev on 4/29/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <VICore/VICore.h>

typedef NS_ENUM (NSUInteger, HttpCode) {
	Continue = 100,
	SwitchingProtocols = 101,
	OK = 200,
	Created = 201,
	Accepted = 202,
	NonAuthoritativeInformation = 203,
	NoContent = 204,
	ResetContent = 205,
	PartialContent = 206,
	MultipleChoices = 300,
	Ambiguous = 300,
	MovedPermanently = 301,
	Moved = 301,
	Found = 302,
	Redirect = 302,
	SeeOther = 303,
	RedirectMethod = 303,
	NotModified = 304,
	UseProxy = 305,
	Unused = 306,
	TemporaryRedirect = 307,
	RedirectKeepVerb = 307,
	BadRequest = 400,
	Unauthorized = 401,
	PaymentRequired = 402,
	Forbidden = 403,
	NotFound = 404,
	MethodNotAllowed = 405,
	NotAcceptable = 406,
	ProxyAuthenticationRequired = 407,
	RequestTimeout = 408,
	Conflict = 409,
	Gone = 410,
	LengthRequired = 411,
	PreconditionFailed = 412,
	RequestEntityTooLarge = 413,
	RequestUriTooLong = 414,
	UnsupportedMediaType = 415,
	RequestedRangeNotSatisfiable = 416,
	ExpectationFailed = 417,
	UpgradeRequired = 426,
	InternalServerError = 500,
	NotImplemented = 501,
	BadGateway = 502,
	ServiceUnavailable = 503,
	GatewayTimeout = 504,
	HttpVersionNotSupported = 505
};

@interface VINet : VIHttpBase

@property(nonatomic,retain) NSMutableDictionary *extraArg;

typedef NS_ENUM(NSInteger, KInfo){ Sex,Mail,FName,LName,Phone,userId,Token,Expires,KHead,KUserId,Kbirth,KFull};

+(NSString *)info:(KInfo)info;

+(void)viewDidload:(UIViewController *)ctrl;
+(void)viewWillAappear:(UIViewController *)ctrl;
+(void)viewDidDisAappear:(UIViewController *)ctrl;

+ (void)get:(NSString *)api args:(id)args target:(id)_target succ:(SEL)success error:(SEL)error inv:(UIView *)view;

+ (void)post:(NSString *)api args:(id)args target:(id)_target succ:(SEL)success error:(SEL)error inv:(UIView *)view;

+ (void)del:(NSString *)api target:(id)_target succ:(SEL)success error:(SEL)error inv:(UIView *)view;

+ (NSDictionary *)headers;

- (void)auth:(BOOL)focuse;

+ (double)distancOfTwolat1:(double)lat1 lon1:(double)lon1 lat2:(double)lat2 lon2:(double)lon2;

+ (double)currentLat;
+ (double)currentLon;

@end

@interface NSDate (gtlt)

- (BOOL)earlyThan:(NSDate *)date;
- (BOOL)laterThan:(NSDate *)date;

@end