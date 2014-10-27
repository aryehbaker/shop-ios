//
//  VIAutoScrollLabel.h
//  VICore
//
//  Created by mk on 13-5-7.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIAutoScrollLabel : UILabel

@property (nonatomic, assign) int		stepWidth; //每一步走多宽
@property (nonatomic, assign) NSTimeInterval timeRun;

- (void)startRun;

- (void)setText:(NSString *)text font:(UIFont *)font;

@end