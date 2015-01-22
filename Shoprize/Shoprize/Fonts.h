//
//  Fonts.h
//  Shoprize
//
//  Created by ShawFung Chao on 10/27/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define Black(sz) ([Fonts PekanBlack:sz])
#define Bold(sz) ([Fonts PekanBold:sz])
#define Light(sz) ([Fonts PekanLight:sz])
#define Regular(sz) ([Fonts PekanRegular:sz])

#define isEn  ([Fonts isEnglish])
#define isHe  ([Fonts isHebrew])
#define Align ([Fonts align])

#define _Track @"_Track_Event"

#define _TK_Sign_Up             @"SignUp"
#define _TK_Click_Deal          @"ClickDeal"
#define _TK_View_Store          @"ViewStore"
#define _TK_Add_Fav_Store       @"AddFavStore"
#define _TK_View_Suprise        @"ViewSurprise"
#define _TK_Like_Deal           @"LikeDeal"
#define _TK_Share_Deal          @"ShareDeal"
#define _TK_Collecte_Suprise    @"CollectedSurprise"
#define _TK_Redeem_Surprise     @"RedeemSurprise"
#define _TK_View_Malls          @"ViewMallList"
#define _TK_Invite              @"InviteFriends"
#define _TK_Contact_Us          @"ContactUs"
#define _TK_Turen_Off_Noti      @"TurnOffNotify"
#define _TK_Click_Mall_Noti     @"ClickMallNotify"
#define _TK_Click_Market_Noti   @"ClickMarketNotify"

#define Eng

@interface Fonts : NSObject

+ (UIFont *)PekanBlack:(int)size;
+ (UIFont *)PekanBold:(int)size;
+ (UIFont *)PekanLight:(int)size;
+ (UIFont *)PekanRegular:(int)size;

+ (BOOL)isEnglish;
+ (BOOL)isHebrew;

+ (NSTextAlignment)align;

+(NSString *)openHourValue:(NSString *)value;

@end
