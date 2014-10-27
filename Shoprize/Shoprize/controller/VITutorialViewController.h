//
//  VITutorialViewController.h
//  ShopriseComm
//
//  Created by mk on 4/3/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "ShopriseViewController.h"

@interface VITutorialViewController : ShopriseViewController<UIScrollViewDelegate>

- (id)initWithPath:(NSArray *)paths;

- (void)addView:(UIView *)view page:(int)page;

@end

