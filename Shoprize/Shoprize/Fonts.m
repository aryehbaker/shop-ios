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
    if([@"he" isEqualToString:Lang(@"lang")]){
        return [UIFont fontWithName:@"Pekan-Black" size:size];
    }
    return [UIFont boldSystemFontOfSize:size];
}

+ (UIFont *)PekanBold:(int)size
{
    if([@"he" isEqualToString:Lang(@"lang")]){
        return [UIFont fontWithName:@"Pekan-Bold" size:size];
    }
    return [UIFont boldSystemFontOfSize:size];
}

+ (UIFont *)PekanLight:(int)size
{
    if([@"he" isEqualToString:Lang(@"lang")]){
        return [UIFont fontWithName:@"Pekan-Light" size:size];
    }
    return [UIFont systemFontOfSize:size];
}

+ (UIFont *)PekanRegular:(int)size
{
    if([@"he" isEqualToString:Lang(@"lang")]){
        return [UIFont fontWithName:@"Pekan-Regular" size:size];
    }
    return [UIFont systemFontOfSize:size];
}

@end
