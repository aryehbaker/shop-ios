//
//  Fonts.m
//  Shoprize
//
//  Created by ShawFung Chao on 10/27/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import "Fonts.h"
#import <VICore/VICore.h>

@implementation Fonts

+ (UIFont *)PekanBlack:(int)size
{
    if([Fonts isHebrew]){
        return [UIFont fontWithName:@"Pekan-Black" size:size];
    }
    return [UIFont boldSystemFontOfSize:size-2];
}

+ (UIFont *)PekanBold:(int)size
{
    if([Fonts isHebrew]){
        return [UIFont fontWithName:@"Pekan-Bold" size:size];
    }
    return [UIFont boldSystemFontOfSize:size-2];
}

+ (UIFont *)PekanLight:(int)size
{
    if([Fonts isHebrew]){
        return [UIFont fontWithName:@"Pekan-Light" size:size];
    }
    return [UIFont systemFontOfSize:size-2];
}

+ (UIFont *)PekanRegular:(int)size
{
    if([Fonts isHebrew]){
        return [UIFont fontWithName:@"Pekan-Regular" size:size];
    }
    return [UIFont systemFontOfSize:size-2];
}

+ (BOOL)isEnglish {
    return [@"en" isEqualToString:Lang(@"lang")];
}
+ (BOOL)isHebrew {
    return [@"he" isEqualToString:Lang(@"lang")];
}

+ (NSTextAlignment)align {
    return [Fonts isHebrew] ? NSTextAlignmentRight : NSTextAlignmentLeft;
}

@end
