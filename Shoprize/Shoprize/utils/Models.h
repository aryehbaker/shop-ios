//
//  Modles.h
//  Shoprose
//
//  Created by vnidev on 10/11/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <iSQlite/iSQlite.h>

#define _NEAREST_PLACE_KM_   0.6

@protocol Store         @end
@protocol Beacon        @end
@protocol MobiPromo     @end
@protocol Picture       @end
@protocol UserSurprise  @end
@protocol Address       @end

@class Beacon;
@class Store;
@class MobiPromo;
@class Picture;
@class UserSurprise;
@class Mall;
@class Address;

@interface Models : NSObject

+ (void)saveModel2DB:(Mall *)mall;

@end

@interface Mall : JSONModel
    @property(nonatomic,copy) NSString *MallAddressId;
    @property(nonatomic,assign) double Lat;
    @property(nonatomic,assign) double Lon;
    @property(nonatomic,copy) NSString *OpenHours;
    @property(nonatomic,copy) NSString *Phone;
    @property(nonatomic,copy) NSString *Name;
    @property(nonatomic,copy) NSString *Logo;
    @property(nonatomic,copy) NSString *Description;
    @property(nonatomic,copy) NSString *Address;
    @property(nonatomic,strong) NSArray<Store,ConvertOnDemand> *Stores;

- (BOOL)saveMallToDatabase;
+ (void)clearRelateData;

-(NSArray *)getAllStores;
-(NSMutableArray *)getAllMobis;
-(NSMutableArray *)getAllBeacons;
-(NSMutableArray *)getAllUserSurprises;

@end


@interface Store : JSONModel
    @property(nonatomic,copy) NSString *StoreUrl;
    @property(nonatomic,assign) double Lat;
    @property(nonatomic,assign) double Lon;
    @property(nonatomic,copy) NSString *OpenHours;
    @property(nonatomic,assign) BOOL IsMarked;
    @property(nonatomic,copy) NSString *Address;
    @property(nonatomic,copy) NSString *StoreName;
    @property(nonatomic,copy) NSString *Logo;
    @property(nonatomic,copy) NSString *Phone;
    @property(nonatomic,copy) NSString *StoreId;
    @property(nonatomic,copy) NSString *AddressId;
    @property(nonatomic,strong) NSArray<Beacon,ConvertOnDemand> *Beacons;
    @property(nonatomic,strong) NSArray<MobiPromo,ConvertOnDemand> *MobiPromos;
    @property(nonatomic,strong) NSArray<UserSurprise,ConvertOnDemand> *UserSurprises;
@end


@interface Beacon : JSONModel

    @property(nonatomic,copy) NSString *AddressId;
    @property(nonatomic,copy) NSString *BeaconId;
    @property(nonatomic,copy) NSString *AssignedId;
    @property(nonatomic,copy) NSString *SignalRadius;
    @property(nonatomic,copy) NSString *Type;

    - (NSString *)getBcUpCase;
    - (BOOL)isIbeacon;

@end


@interface MobiPromo : JSONModel
    @property(nonatomic,copy) NSString *Offer;
    @property(nonatomic,copy) NSString *StoreUrl;
    @property(nonatomic,copy) NSString *CategoryName;
    @property(nonatomic,copy) NSString *Prerequisite;
    @property(nonatomic,strong) NSDate *StartDate;
    @property(nonatomic,strong) NSDate *CreateDate;
    @property(nonatomic,strong) NSArray<Picture,ConvertOnDemand> *Pictures;
    @property(nonatomic,assign) BOOL IsMarked;
    @property(nonatomic,copy) NSString *CategoryId;
    @property(nonatomic,copy) NSString *StoreName;
    @property(nonatomic,copy) NSString *Description;
    @property(nonatomic,copy) NSString *Type;
    @property(nonatomic,strong) NSDate *ExpireDate;
    @property(nonatomic,assign) int MarkedCount;
    @property(nonatomic,copy) NSString *MobiPromoUrl;
    @property(nonatomic,copy) NSString *MobiPromoId;
    @property(nonatomic,copy) NSString *StoreImageUrl;
    @property(nonatomic,copy) NSString *AddressId;
    @property(nonatomic,assign) BOOL StoreHasSuprise;
    @property(nonatomic,copy) NSString *defPicture;

    - (BOOL)isSuprise;

@end

@interface Picture : JSONModel
    @property(nonatomic,copy) NSString *PictureUrl;
    @property(nonatomic,copy) NSString *OriginalName;
    @property(nonatomic,copy) NSString *Description;
    @property(nonatomic,copy) NSString *MobiPromoId;
@end


@interface UserSurprise : JSONModel
    @property(nonatomic,copy) NSString *RedemptionCode;
    @property(nonatomic,assign) BOOL    Redeemed;
    @property(nonatomic,copy) NSString *MobiPromoId;
    @property(nonatomic,strong) NSDate *ExpireTime;
    @property(nonatomic,strong) NSDate *RewardTime;
    @property(nonatomic,strong) NSDate *StartTime;
    @property(nonatomic,copy) NSString * UserSurpriseId;

@end

@interface MallInfo : JSONModel

    @property(nonatomic,copy) NSString *MallAddressId;
    @property(nonatomic,assign) double Lat;
    @property(nonatomic,assign) double Lon;
    @property(nonatomic,copy) NSString *OpenHours;
    @property(nonatomic,copy) NSString *Phone;
    @property(nonatomic,copy) NSString *Name;
    @property(nonatomic,copy) NSString *Logo;
    @property(nonatomic,copy) NSString *Description;
    @property(nonatomic,copy) NSString *Address;

    @property(nonatomic,assign) double distance;

    + (MallInfo *)nearestMall;

@end

//时间戳
@interface Timestamps : JSONModel

    @property(nonatomic,copy) NSString *stampId;
    @property(nonatomic,assign) double    time;

+(void)setMallRefrshTime:(NSString *)mallid;

@end

@interface VisitStep : JSONModel

@property(nonatomic,copy) NSString *Type;
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,assign) int time;

+ (VisitStep *)insertStep:(NSString *)type value:(NSString *)value;

@end

@interface MobiPromoExt : MobiPromo

@property(nonatomic,copy) NSString *Address;
@property(nonatomic,assign) double Lat;
@property(nonatomic,assign) double Lon;
@property(nonatomic,assign) double Distance;

@end

@interface MobiPromoAR : MobiPromo

@property(nonatomic,copy) NSString *Offer;
@property(nonatomic,copy) NSString *StoreUrl;
@property(nonatomic,copy) NSString *CategoryName;
@property(nonatomic,copy) NSString *Prerequisite;
@property(nonatomic,strong) NSDate *StartDate;
@property(nonatomic,strong) NSDate *CreateDate;
@property(nonatomic,assign) BOOL IsMarked;
@property(nonatomic,copy) NSString *CategoryId;
@property(nonatomic,copy) NSString *StoreName;
@property(nonatomic,copy) NSString *Description;
@property(nonatomic,copy) NSString *Type;
@property(nonatomic,strong) NSDate *ExpireDate;
@property(nonatomic,assign) int MarkedCount;
@property(nonatomic,copy) NSString *MobiPromoUrl;
@property(nonatomic,copy) NSString *MobiPromoId;
@property(nonatomic,copy) NSString *StoreImageUrl;
@property(nonatomic,copy) NSString *AddressId;
@property(nonatomic,assign) BOOL StoreHasSuprise;

@property(nonatomic,copy) NSString *defPicture;
@property(nonatomic,strong) NSString *StoreId;
@property(nonatomic,assign) double Lat;
@property(nonatomic,assign) double Lon;
@property(nonatomic,strong) NSString *MallId;
@property(nonatomic,strong) NSString *MallName;
@property(nonatomic,strong) NSString *Phone;
@property(nonatomic,strong) NSString *Address;
@property(nonatomic,strong) NSString *Logo;
@property(nonatomic,strong) NSString *OpenHours;

@property(nonatomic,strong) NSArray<Picture,ConvertOnDemand> *Pictures;
@property(nonatomic,strong) NSArray<Beacon,ConvertOnDemand> *Beacons;

@end
