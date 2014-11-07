//
//  Modles.m
//  Shoprose
//
//  Created by vnidev on 10/11/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "Models.h"
#import <iSQLite/LKDBProperty.h>
#import "VINet.h"
#import "KUtils.h"

@implementation Models

+ (void)saveModel2DB:(Mall *)mall {
    

    
}

@end

@implementation Mall

- (BOOL)saveMallToDatabase
{
    LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
    [Mall clearRelateData];
    //创建用户需要的表。后面会用到起
    [helper makeTable:[UserSurprise class]];
    [helper insertOrUpdateUsingObj:self];
    [helper insertOrUpdateUsingAry:[self getAllStores]];
    [helper insertOrUpdateUsingAry:[self getAllMobis]];
    [helper insertOrUpdateUsingAry:[self getAllBeacons]];
    [helper insertOrUpdateUsingAry:[self getAllUserSurprises]];
    
    return YES;
}

+(void)clearRelateData {
    LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
    [helper clearTableData:[Mall class]];
    [helper clearTableData:[Store class]];
    [helper clearTableData:[MobiPromo class]];
    [helper clearTableData:[Beacon class]];
    [helper clearTableData:[UserSurprise class]];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return YES;
}
+(void)initialize{
    [self removePropertyWithColumnName:@"Stores"];
}

+(NSString*)getPrimaryKey{
    return @"MallAddressId";
}

-(NSArray*)getAllStores{
    JSONModelArray *array = (JSONModelArray*)[self Stores];
    NSMutableArray *mta = [array toObjectArray];
    return mta;
}
-(NSMutableArray*)getAllMobis{
    NSMutableArray *data = [NSMutableArray array];
    LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
    
    for (Store *s in [self getAllStores]) {
        NSMutableArray *mobis = [((JSONModelArray *)[s MobiPromos] ) toObjectArray];

        NSMutableArray *sups = [NSMutableArray array];
        NSMutableArray *deals = [NSMutableArray array];
        
        for (MobiPromo *d in mobis) {
            NSArray *pics = [((JSONModelArray *)[d Pictures]) toObjectArray];
            //保存图片内容
            for (Picture *p2 in pics) {
                [p2 setMobiPromoId:d.MobiPromoId];
                [helper insertOrUpdateUsingObj:p2];
            }
            
            if (pics.count > 0 )
                [d setDefPicture:((Picture*)pics[0]).PictureUrl];
            
            if ([d isSuprise]) {
                [sups addObject:d];
            }else{
                [deals addObject:d]; //只显示Deal的内容
            }
        }
        if (mobis.count != deals.count && deals.count > 0) {
            int x = arc4random() % deals.count;
            MobiPromo *dct = [deals objectAtIndex:x];
            [dct setStoreHasSuprise:YES];
            [deals replaceObjectAtIndex:x withObject:dct];
        }
        [data addObjectsFromArray:sups];
        [data addObjectsFromArray:deals];
    }
    return data;
}

-(NSMutableArray*)getAllBeacons{
    NSMutableArray *data = [NSMutableArray array];
    for (Store *s in [self getAllStores]) {
        NSMutableArray *bcs = [((JSONModelArray *)[s Beacons]) toObjectArray];
        for (Beacon * bc in bcs) {
            [bc setAddressId:s.AddressId];
            [data addObject:bc];
        }
    }
    return data;
}

-(NSMutableArray*)getAllUserSurprises{
    NSMutableArray *data = [NSMutableArray array];
    for (Store *s in [self getAllStores]) {
        NSMutableArray *bcs = [((JSONModelArray *)[s UserSurprises]) toObjectArray];
        for (UserSurprise * bc in bcs) {
            [data addObject:bc];
        }
    }
    return data;
}
@end

@implementation Store
+(void)initialize{
    [self removePropertyWithColumnNameArray:@[@"Beacons",@"MobiPromos",@"UserSurprises"]];
}
+(NSString*)getPrimaryKey{
    return @"StoreId";
}
+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return YES;
}
@end

@implementation Beacon
- (BOOL)isIbeacon {
    return [[[self Type] lowercaseString] isEqualToString:@"ibeacon"];
}
- (NSString *)getBcUpCase {
     return [[self AssignedId] uppercaseString];
}
+(NSString*)getPrimaryKey{
    return @"BeaconId";
}
+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return ![propertyName isEqualToString:@"BeaconId"];
}
@end

@implementation MobiPromo

-(BOOL)isSuprise {
    return [[self.Type lowercaseString] isEqualToString:@"surprise"];
}
+(void)initialize{
    [self removePropertyWithColumnNameArray:@[@"Pictures",@"usersup"]];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return ![propertyName isEqualToString:@"MobiPromoId"];
}
+(NSString*)getPrimaryKey{
    return @"MobiPromoId";
}
@end

@implementation Picture
+(NSArray*)getPrimaryKeyUnionArray{
    return @[@"PictureUrl",@"MobiPromoId"];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return YES;
}
@end

@implementation UserSurprise

+(NSString*)getPrimaryKey{
    return @"UserSurpriseId";
}
+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return YES;
}
@end

@implementation MallInfo
+(NSString*)getPrimaryKey{
    return @"MallAddressId";
}

+(void)initialize{
    [self removePropertyWithColumnName:@"distance"];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName{
    return ![propertyName isEqualToString:@"MallAddressId"];
}

+ (MallInfo *)nearestMall
{
    double min_distance = MAXFLOAT;
    NSMutableArray *malls = [[iSQLiteHelper getDefaultHelper] searchAllModel:[MallInfo class]];
    MallInfo *nearest = nil;
    for (MallInfo *m in malls) {
        double distance = [VINet distancOfTwolat1:[VINet currentLat] lon1:[VINet currentLon] lat2:m.Lat lon2:m.Lon];
        if (distance < min_distance) {
            min_distance = distance;
            [m setDistance:distance];
            nearest = m;
        }
    }
    return nearest;
}
@end

@implementation Timestamps
+(NSString*)getPrimaryKey{
    return @"stampId";
}

+(void)setMallRefrshTime:(NSString *)mallid{
    NSNumber *v = [NSNumber numberWithFloat:[[NSDate date] timeIntervalSince1970]];
    NSDictionary *value = @{@"stampId": mallid,@"time":v};
    [[iSQLiteHelper getDefaultHelper] insertOrUpdateDB:[Timestamps class] value:value];
}

@end

@implementation JSONValueTransformer (CustomTransformer)

- (NSDate *)NSDateFromNSString:(NSString*)string {
    NSDate *time =  [string toLocalDate];
    return time;
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:date];
}

@end

@implementation VisitStep
+(NSArray*)getPrimaryKeyUnionArray{
    return @[@"Type",@"ID"];
}

+ (VisitStep *)insertStep:(NSString *)type value:(NSString *)value{
    VisitStep *v = [[VisitStep alloc] init];
    [v setType:type];
    [v setID:value];
    [v setTime:[[NSDate now] timeIntervalSince1970]];
    LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
    BOOL exist = [helper isExistsModel:v];
    if (exist) {
        NSMutableArray *dates = [helper searchModels:[VisitStep class] where:@{@"Type":type,@"ID":value}];
        return [dates objectAtIndex:0];
    }
    [helper insertOrUpdateUsingObj:v];
    return nil;
}
@end

@implementation MobiPromoExt

@end