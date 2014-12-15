//
//  Ext.m
//  Shoprize_EN
//
//  Created by vniapp on 11/20/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ext.h"

@implementation Ext

+ (NSMutableArray *)doEach:(NSArray *)input with:(id (^)(id itm))func {
    NSMutableArray *mtb = [NSMutableArray array];
    for (id each in input) {
        id val = func(each);
        if (val != nil) {
            [mtb addObject:val];
        }
    }
    return mtb;
}

+ (NSArray *)fontNames {
    NSMutableArray *fonts = [NSMutableArray array];
    for (NSString *ff in [UIFont familyNames]) {
        [fonts addObjectsFromArray:[UIFont fontNamesForFamilyName:ff]];
    }
    return fonts;
}

@end
