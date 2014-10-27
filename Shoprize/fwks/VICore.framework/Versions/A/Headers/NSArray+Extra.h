//
//  NSArray+Extra.h
//  VTCore
//
//  Created by Carrey.C on 8/15/13.
//  Copyright (c) 2013 app1580.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Extra.h"

@interface NSArray (Extra)

/**
 * 把 array 对象转化为 json 字符串
 */
- (NSString *)jsonString;

@end
