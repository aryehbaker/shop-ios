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

#define isEn  ([Fonts isEnglish])
#define isHe  ([Fonts isHebrew])
#define Align ([Fonts align])

#define Eng

@interface Fonts : NSObject

+ (UIFont *)PekanBlack:(int)size;
+ (UIFont *)PekanBold:(int)size;
+ (UIFont *)PekanLight:(int)size;
+ (UIFont *)PekanRegular:(int)size;

+ (BOOL)isEnglish;
+ (BOOL)isHebrew;

+ (NSTextAlignment)align;

+(NSString *)openHourValue:(NSString *)value;

@end
