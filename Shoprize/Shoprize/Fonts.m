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


+(NSString *)openHourValue:(NSString *)value
{
    if (value == nil || [[NSNull null] isEqual:value]) {
        return @"";
    }
    
    NSArray				*days			= [value  componentsSeparatedByString:@"|"];
    NSMutableDictionary *work			= [NSMutableDictionary dictionary];
    NSArray				*weekDaylist	= [[@"weekDayList" lang] componentsSeparatedByString:@"|"];
    
    if (days==nil || days.count < 7) {
        return value;
    }
    
    for (int i = 0; i < days.count; i++) {
        NSString	*day	= [days objectAtIndex:i];
        [work setValue:day forKey:[NSString stringWithFormat:@"%d", i]];
    }
    
    NSMutableString *display = [NSMutableString string];
    NSMutableArray *afterThat = [[work alphaAscKeys] mutableCopy];
    [afterThat insertObject:[afterThat objectAtIndex:6] atIndex:0];
    [afterThat removeObjectAtIndex:7];
    
    for (NSString *key in afterThat) {
        NSString *wk = key;
        wk	= [wk stringByReplacingOccurrencesOfString:@"0" withString:[weekDaylist objectAtIndex:0]];
        wk	= [wk stringByReplacingOccurrencesOfString:@"1" withString:[weekDaylist objectAtIndex:1]];
        wk	= [wk stringByReplacingOccurrencesOfString:@"2" withString:[weekDaylist objectAtIndex:2]];
        wk	= [wk stringByReplacingOccurrencesOfString:@"3" withString:[weekDaylist objectAtIndex:3]];
        wk	= [wk stringByReplacingOccurrencesOfString:@"4" withString:[weekDaylist objectAtIndex:4]];
        wk	= [wk stringByReplacingOccurrencesOfString:@"5" withString:[weekDaylist objectAtIndex:5]];
        wk	= [wk stringByReplacingOccurrencesOfString:@"6" withString:[weekDaylist objectAtIndex:6]];
        NSArray		*vals	= [[work objectForKey:key] componentsSeparatedByString:@","];
        NSString	*bt		= [self toTime:vals[0]];
        NSString	*et		= [self toTime:vals[1]];
        
        NSString *wkt = [NSString stringWithFormat:@"%@-%@",et,bt];
        if ([wkt isEqualToString:@"00:00-00:00"]) {
            wkt = [@"closedTitleLabel" lang];
        }
        [display appendFormat:@"%@: %@ \n", wk, wkt];
    }
    return display;
}

+ (NSString *)toTime:(NSString *)timemin
{
    int hour	= (int)[timemin intValue] / 60;
    int min		= (int)[timemin intValue] % 60;
    
    if (min == 0) {
        return [NSString stringWithFormat:@"%02d:00",hour];
    } else {
        return [NSString stringWithFormat:@"%02d:%02d", hour,min];
    }
}

@end
