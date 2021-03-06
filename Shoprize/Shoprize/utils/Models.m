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
    
    [Mall clearMallWithId:_MallAddressId];

    //创建用户需要的表。后面会用到起
    [helper makeTable:[UserSurprise class]];
    
    [helper insertOrUpdateUsingObj:self];
    [helper insertOrUpdateUsingAry:[self getAllStores]];
    [helper insertOrUpdateUsingAry:[self getAllMobis]];
    [helper insertOrUpdateUsingAry:[self getAllBeacons]];
    [helper insertOrUpdateUsingAry:[self getAllUserSurprises]];
    
    return YES;
}

+(void)clearMallWithId:(NSString *)mallid {
    LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
    NSString *_MallAddressId = mallid;
    [helper executeDB:^(FMDatabase *db) {
        
        NSString *sql = Fmt(@"delete from Picture where MobiPromoId in (select t.MobiPromoId from MobiPromo t where exists(select * from Store s where s.AddressId=t.AddressId and s.MallId='%@'))",_MallAddressId);
    
        BOOL ok =  [db executeUpdate:sql];
        
        NSLog(@"Delete Mall[%@] Picture :%d",_MallAddressId,ok);
        
        sql = Fmt(@"delete from UserSurprise where MobiPromoId in (select t.MobiPromoId from MobiPromo t where exists(select * from Store s where s.AddressId=t.AddressId and s.MallId='%@'))" ,_MallAddressId);
        
        ok = [db executeUpdate:sql];
        NSLog(@"Delete Mall[%@] UserSurprise:%d",_MallAddressId,ok);
        
        sql =  Fmt(@"delete from Beacon where AddressId in (select s.AddressId from Store s where s.MallId='%@')",_MallAddressId);
        ok = [db executeUpdate:sql];
        
        NSLog(@"Delete Mall[%@] Beacon:%d",_MallAddressId,ok);
        
        sql = Fmt(@"delete from MobiPromo where AddressId in (select s.AddressId from Store s where s.MallId='%@')",_MallAddressId);
        ok = [db executeUpdate:sql];
        
        NSLog(@"Delete Mall[%@] MobiPromo:%d",_MallAddressId,ok);
        
        sql = Fmt(@"delete from Store where MallId ='%@'",_MallAddressId);
        ok = [db executeUpdate:sql];
        NSLog(@"Delete Mall[%@] Store:%d",_MallAddressId,ok);
        
        sql = Fmt(@"delete from Mall where MallAddressId='%@'",_MallAddressId);
        ok = [db executeUpdate:sql];
        NSLog(@"Delete Mall[%@] Mall:%d",_MallAddressId,ok);
        
    }];
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
    NSMutableArray *mtb = [NSMutableArray array];
    for (Store *s in [array toObjectArray]) {
        [s setMallId:_MallAddressId];
        [mtb addObject:s];
    }
    return mtb;
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
            [d setStoreId:s.StoreId];
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

@implementation AllStore
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
+ (id)initWithDictionary:(id)dict
{
    MobiPromo *promo = [[MobiPromo alloc] initWithDictionary:dict error:nil];
    promo.defPicture = [dict stringValueForKey:@"Pictures/0/PictureUrl"];
    return promo;
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

 + (NSArray *)allmall {
    return  [[iSQLiteHelper getDefaultHelper] searchAllModel:[MallInfo class]];
}
+ (MallInfo *)getMallById:(NSString *)mid
{
   return [[iSQLiteHelper getDefaultHelper]  searchSingle:[MallInfo class] where:@{@"MallAddressId":mid} orderBy:@"MallAddressId"];
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
    return [string toLocalDate];
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

@implementation MobiPromoAR

+(void)initialize{
    [self removePropertyWithColumnNameArray:@[@"Beacons",@"Pictures"]];
}

@end
@implementation MallVisit
+(NSString*)getPrimaryKey{
    return @"mallid";
}

+(void)addVisit:(NSString *)mallId lat:(double)lat lon:(double)lon
{
   LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
    NSMutableArray *value = [[iSQLiteHelper getDefaultHelper] searchModels:[MallVisit class] where:@{@"mallid":mallId}];
    MallVisit *mallviist;
    if (value.count == 0) {
        mallviist = [[MallVisit alloc] init];
    }else{
        mallviist = [value objectAtIndex:0];
    }
    mallviist.mallid = mallId;
    mallviist.lat = lat;
    mallviist.lon = lon;
    [helper insertOrUpdateUsingObj:mallviist];
}

+(void)removeVisit:(NSString *)mallId{
    [[iSQLiteHelper getDefaultHelper] deleteWithClass:[MallVisit class] where:@{@"mallid":mallId}];
}
+(void)clearAll{
   // [[iSQLiteHelper getDefaultHelper] clearTableData:[MallVisit class]];
}
+(NSString *)nearestMall {
    NSMutableArray *list = [[iSQLiteHelper getDefaultHelper] searchAllModel:[MallVisit class]];
    if (list.count == 0) {
        return nil;
    }
    double min_distance = MAXFLOAT;
    MallVisit *nearest = nil;
    for (MallVisit *m in list) {
        double distance = [VINet distanceTo:m.lat lon:m.lon];
        if (distance < min_distance) {
            min_distance = distance;
            nearest = m;
        }
    }
    return nearest.mallid;
}

@end
@implementation MallWelcome
+(NSString*)getPrimaryKey{
    return @"MallId";
}

+(BOOL)isNewMall:(NSString *)mallid {
    MallWelcome *welcome = [[iSQLiteHelper getDefaultHelper] searchSingle:[MallWelcome class] where:@{@"MallId":mallid} orderBy:@"MallId"];
    NSTimeInterval v = [[NSDate date] timeIntervalSince1970];
    BOOL isNew = NO;
    if (welcome == nil) {
        isNew = YES;
        welcome = [[MallWelcome alloc] init];
        welcome.MallId = mallid;
    }else{
        NSDate *old = [NSDate dateWithTimeIntervalSince1970:welcome.visitTime];
        int oldInt  = [[old format:@"yyyyMMdd"] integerValue];
        int newInt  = [[[NSDate now] format:@"yyyyMMdd"] integerValue];

        if (newInt > oldInt) {
            isNew = YES;
        }
    }
    welcome.visitTime = v;
    [[iSQLiteHelper getDefaultHelper] insertOrUpdateUsingObj:welcome];
    return isNew;
}

@end
