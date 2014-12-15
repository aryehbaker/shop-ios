//
//  Ext.h
//  Shoprize_EN
//
//  Created by vniapp on 11/20/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define structs

@interface Ext : NSObject

/**
*   Each in the array if return nil
*   the return array not contain the value
*/
+ (NSMutableArray *)doEach:(NSArray *)input with:(id (^)(id itm))func;

/**
*  Get All fonts name in the system
*/
+ (NSArray *)fontNames;

@end
