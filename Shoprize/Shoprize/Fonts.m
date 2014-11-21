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
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+ (UIFont *)PekanBold:(int)size
{
    if([Fonts isHebrew]){
        return [UIFont fontWithName:@"Pekan-Bold" size:size];
    }
    return  [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+ (UIFont *)PekanLight:(int)size
{
    if([Fonts isHebrew]){
        return [UIFont fontWithName:@"Pekan-Light" size:size];
    }
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+ (UIFont *)PekanRegular:(int)size
{
    if([Fonts isHebrew]){
        return [UIFont fontWithName:@"Pekan-Regular" size:size];
    }
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
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
