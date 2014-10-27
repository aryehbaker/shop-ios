//
//  VIUncaughtExceptionHandler.h
//  Shoprise_HE
//
//  Created by vnidev on 8/16/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VIUncaughtExceptionHandler : NSObject

+ (void)setDefaultHandler;

+ (NSUncaughtExceptionHandler*)getHandler;

+ (instancetype)instace;

- (void)checkAndSendMail:(void (^)(NSString *path))checker;

@end