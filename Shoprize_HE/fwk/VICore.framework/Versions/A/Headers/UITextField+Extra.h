//
//  UITextField+Extra.h
//  VTCore
//
//  Created by mk on 13-10-4.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extra)

/**!
 * add some space left of padding with leftView Model
 * @param px the padding left margin
 * this paramter can't used with "leftView" in same time
 */
- (void)addLeftPadding:(int)px;

- (BOOL)isEmptyValue;

- (BOOL)isSameTextWith:(UITextField *)other;

@end
