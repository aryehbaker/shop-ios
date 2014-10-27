// AKTabBar.h
//
// Copyright (c) 2012 Ali Karagoz (http://alikaragoz.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AKTab.h"

@class AKTabBar;

@protocol AKTabBarDelegate <NSObject>

@required

// Used by the TabBarController to be notified when a tab is pressed
- (void)tabBar:(AKTabBar *)AKTabBarDelegate didSelectTabAtIndex:(NSInteger)index;

@end

@interface AKTabBar : UIView

@property(nonatomic, retain) NSArray *tabs;
@property(nonatomic, retain) AKTab *selectedTab;
@property(nonatomic, retain) id <AKTabBarDelegate> delegate;

// Tab top embos Color
@property(nonatomic, retain) UIColor *edgeColor;

// Tabs selected colors.
@property(nonatomic, retain) NSArray *tabColors;

// Tab background image
@property(nonatomic, retain) NSString *backgroundImageName;

- (void)tabSelected:(AKTab *)sender;

@end