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
#import "Fonts.h"

typedef NS_ENUM(NSInteger, BarItem) {
    NONE,
    BACK,
    HOME,
    MENU,
    SEARCH,
    Around,
    MapIt,
    Route,
    Done
};

#define _NOTIFY_MALL_CHANGED        @"NOTIFY_MALL_CHNAGED_KEY"


#define CURRENT_MALL_USER_IN                @"CUREENT_MALL_USER_IN"
#define CURRENT_MALL_USER_SELECTED          @"CUREENT_MALL_USER_SELECTED"


#define _NS_NOTIFY_SHOW_MENU    @"_NS_NOTIFY_SHOW_MENU_"

#define Space(start) (self.view.h - start)
#define def_IS_HE YES

#define RED  (isHe ? @"#FF4745" : @"#FF1500")

@interface ShopriseViewController : VIBaseViewController

@property(nonatomic,strong) UIView *nav;
@property(nonatomic,strong) UILabel *nav_title;
@property(nonatomic,strong) UIButton *leftOne;
@property(nonatomic,strong) UIButton *rightOne;

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

- (BOOL)isEmpty:(id)value;

- (void)redeemDeail:(NSString *)dealId complete:(SEL)complete;

@end

@interface VILabel : UILabel

+(UILabel *)createLableWithFrame:(CGRect)frm color:(NSString *)color font:(UIFont *)ft align:(TxtOpt)opt;

+(UILabel *)createManyLines:(CGRect)frm color:(NSString *)color ft:(UIFont *)ft text:(NSString *)text;

@end

