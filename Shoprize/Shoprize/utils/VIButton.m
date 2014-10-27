//
//  VIButton.m
//  ShopriseComm
//
//  Created by mk on 4/9/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIButton.h"
#import <VICore/VICore.h>

@implementation VIButton

- (void)setIcon:(NSString *)icon
{
    UIImageView *iconView = [icon imageView];
    iconView.frame = Frm(5, 5, FrmH(self) - 10, FrmH(self) - 10);
    [self addSubview:iconView];
    self.titleEdgeInsets = UIEdgeInsetsMake(0, iconView.endX+5, 0, 0);
    self.titleLabel.font = VI_FONT_14;
    self.layer.cornerRadius = 3;
}

@end
