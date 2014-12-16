//
//  KUtils.h
//  Shoprose
//
//  Created by vnidev on 7/9/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KUtils : NSObject<UIAlertViewDelegate>

- (NSString *)rtlTxt:(id)input;

+ (UIView *)makeDialog:(NSString *)hour addr:(NSString *)addr tel:(NSString *)tel;

@end

@interface NSString(RTL)

- (NSString *) rtlTxt;

- (BOOL)like:(NSString *)input;

- (NSString *)killQute;

- (NSDate *)toLocalDate;

@end

@interface UILabel (RTL)
- (void)setRTL;
- (void)autoHeight;
@end

@interface UIView (Extra2)
- (UIButton *)button4Tag:(NSInteger)tag;
@end

@interface NSMutableDictionary (ExtraNotNull)

- (void)setNotNullKey:(NSString *)key value:(id)value;

@end

