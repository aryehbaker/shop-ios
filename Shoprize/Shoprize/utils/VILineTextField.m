//
//  VITextField.m
//  Shoprose
//
//  Created by vnidev on 5/21/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "VILineTextField.h"
#import <VICore/VICore.h>
#import "Fonts.h"

@implementation VILineTextField

- (id)initWithFrame:(CGRect)frame holder:(NSString *)holder
{
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = holder;
        self.textColor = [@"#C2C2C3" hexColor];
        if ([Lang(@"lang") isEqual:@"he"]) {
            self.textAlignment = Align;
        }
        [self setValue:[@"#C2C2C3" hexColor] forKeyPath:@"_placeholderLabel.textColor"];
        [self addLeftPadding:10];
        
        UIView *left = [[UIView alloc] initWithFrame:Frm(0,self.h-3, 1, 8)];
        left.backgroundColor = [@"#A7A8AA" hexColor];
        [self addSubview:left];
        
        UIView *btm = [[UIView alloc] initWithFrame:Frm(0,self.h-1, self.w,1)];
        btm.backgroundColor = [@"#A7A8AA" hexColor];
        [self addSubview:btm];
        
        UIView *right = [[UIView alloc] initWithFrame:Frm(self.w-1,self.h-3, 1, 8)];
        right.backgroundColor = [@"#A7A8AA" hexColor];
        [self addSubview:right];
    }
    return self;
}


@end
