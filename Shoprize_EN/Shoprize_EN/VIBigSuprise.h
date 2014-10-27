//
//  VIBigSuprise.h
//  Shoprise_EN
//
//  Created by vnidev on 5/29/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OpenSuprise <NSObject>

- (void)openIt:(NSDictionary *)info;

@end

@interface VIBigSuprise : UIView
{
    CGSize velocity;
    CGRect initFrame;
    CGPoint frmCenter;
}

@property(nonatomic,strong) id<OpenSuprise> delegate;

- (void)boomAnnimation:(CADisplayLink *)displayLink;

- (id)initWithFrame:(CGRect)frame dict:(id)value;

- (void)openSuprise;

@end
