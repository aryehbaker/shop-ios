//
//  VITabView.h
//  Demo
//
//  Created by mk on 13-4-7.
//  Copyright (c) 2013年 com.mobiconsumers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VICore/VICore.h>

@protocol VITabBarItemDelegate <NSObject>

-(void)tabSelectedAtIndex:(NSInteger)atIndex isReClick:(BOOL)reclick;

@end

@interface VITabBar : UIView<AKTabBarDelegate>

@property(nonatomic,assign) id<VITabBarItemDelegate> delegate;

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles icons:(NSArray *)icons;

- (void)setTabSelectedAtIndex:(NSInteger)index;

- (AKTab*)getTabSelectedAtIndex:(NSInteger)index;

@end
