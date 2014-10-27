//
//  Fonts.h
//  Shoprize
//
//  Created by ShawFung Chao on 10/27/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define Black(sz) ([Fonts PekanBlack:sz])
#define Bold(sz) ([Fonts PekanBold:sz])
#define Light(sz) ([Fonts PekanLight:sz])
#define Regular(sz) ([Fonts PekanRegular:sz])

@interface Fonts : NSObject

+ (UIFont *)PekanBlack:(int)size;
+ (UIFont *)PekanBold:(int)size;
+ (UIFont *)PekanLight:(int)size;
+ (UIFont *)PekanRegular:(int)size;

@end
