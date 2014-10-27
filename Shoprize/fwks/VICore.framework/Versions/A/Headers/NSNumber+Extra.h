//
//  NSNumber+Extra.h
//  VTCore
//
//  Created by mk on 13-2-20.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <Foundation/Foundation.h>

// 首页
#define PAGE_ONE  [NSNumber numberWithInt:1]
#define PAGE_ZERO [NSNumber numberWithInt:0]
// 加一页
#define PAGE_ADD(page) (page = [NSNumber numberWithInt:[page intValue] + 1])

@interface NSNumber (Extra)

//是否为第一页
- (BOOL)isFirstPage;

//是否为第0页
- (BOOL)isZeroPage;


+ (NSNumber *)firstPage;

+ (NSNumber *)zeroPage;


@end
