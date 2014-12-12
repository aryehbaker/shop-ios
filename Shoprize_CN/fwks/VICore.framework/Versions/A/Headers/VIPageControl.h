//
//  VIPageControl.h
//  VICore
//
//  Created by mk on 13-3-13.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VICore/VICore.h>

@interface VIPageControl : UIPageControl

@property (VI_STRONG, nonatomic) UIImage *normalImage;
@property (VI_STRONG, nonatomic) UIImage *highlightedImage;

- (id)initWithFrame:(CGRect)frame nomarl:(NSString *)normal highlighted:(NSString *)highlighted;

@end
