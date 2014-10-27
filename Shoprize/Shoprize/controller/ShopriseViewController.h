//
//  ShopriseViewController.h
//  ShopriseComm
//
//  Created by mk on 4/1/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VICore/VICore.h>
#import "VINet.h"
#import <iSQLite/iSQLite.h>
#import "Models.h"

typedef NS_ENUM(NSInteger, BarItem) {
    NONE,
    BACK,
    HOME,
    MENU,
    SEARCH
};

#define _USER_SELECTED_MALL_INFO    @"USER_SELECTED_MALL_INFO_KEY"
#define _NOTIFY_MALL_CHANGED        @"NOTIFY_MALL_CHNAGED_KEY"

#define FontPekanBlack(sz)    ([UIFont fontWithName:@"Pekan-Black" size:sz])
#define FontPekanBold(sz)     ([UIFont fontWithName:@"Pekan-Bold" size:sz])
#define FontPekanLight(sz)    ([UIFont fontWithName:@"Pekan-Light" size:sz])
#define FontPekanRegular(sz)  ([UIFont fontWithName:@"Pekan-Regular" size:sz])

//#define FontPekanBlack(sz)    ([UIFont boldSystemFontOfSize:sz])
//#define FontPekanBold(sz)     ([UIFont boldSystemFontOfSize:sz])
//#define FontPekanLight(sz)    ([UIFont systemFontOfSize:sz])
//#define FontPekanRegular(sz)  ([UIFont systemFontOfSize:sz])


#define _NS_NOTIFY_SHOW_MENU    @"_NS_NOTIFY_SHOW_MENU_"

#define Space(start) (self.view.h - start)
#define def_IS_HE YES

@interface ShopriseViewController : VIBaseViewController<CLLocationManagerDelegate>
@property(nonatomic,strong) UIView *nav;
@property(nonatomic,strong) UILabel *nav_title;
@property(nonatomic,strong) UIButton *leftOne;

- (void)addNav:(NSString *)title left:(BarItem)left right:(BarItem)right;

- (void)setLightContent;

- (void)showAlertError:(id)value;

- (void)addCommentPage:(float)alpha;

- (void)doLeftClick:(id)sender;
- (void)doCenterIconClick:(id)sender;

- (void)showSearchFiled:(UIButton *)sender;
- (void)hideSearchFiled:(UIButton *)sender;
- (BOOL)isSearchFiledShow;

- (id)AppDelegate;

- (void)whenSearchKey:(NSString *)search;

- (void)showInfoMessage:(UITapGestureRecognizer *)tap;

@end