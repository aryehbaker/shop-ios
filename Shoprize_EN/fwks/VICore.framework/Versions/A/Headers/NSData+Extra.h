//
//  NSData+Extra.h
//  VTCore
//
//  Created by mk on 13-2-20.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Extra)

/**
 * 把 NSData 对象转化为 String 字符串
 */
- (NSString *)stringValue;

- (id)jsonVal:(NSError **)error;

@end
