//
//  NSUserDefaults+Extra.h
//  VTCore
//
//  Created by mk on 14-1-10.
//  Copyright (c) 2014年 app1580.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Extra)
+ (void)setValue:(id)value forKey:(NSString *)key;
+ (NSString *)getValue:(NSString *)key;
@end
