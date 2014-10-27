//
//  VIUncaughtExceptionHandler.m
//  Shoprise_HE
//
//  Created by vnidev on 8/16/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIUncaughtExceptionHandler.h"
#import <VICore/VICore.h>


#define Exp_Path [[VIFile getDocumentPath] stringByAppendingString:@"/Exception.txt"]

void def_UncaughtExceptionHandler(NSException *exception) {
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *url = [NSString stringWithFormat:@"=============Exception Report=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
                     name,reason,[arr componentsJoinedByString:@"\n"]];
    [url writeToFile:Exp_Path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
    //或者调用某个处理程序来处理这个信息
}


@implementation VIUncaughtExceptionHandler

-(NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler (&def_UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler*)getHandler
{
    return NSGetUncaughtExceptionHandler();
}
+(instancetype)instace
{
    return [[VIUncaughtExceptionHandler alloc] init];
}

- (void)checkAndSendMail:(void (^)(NSString *path))checker
{
    if ([VIFile isFileExists:Exp_Path]) {
        checker(Exp_Path);
    }
}
@end

