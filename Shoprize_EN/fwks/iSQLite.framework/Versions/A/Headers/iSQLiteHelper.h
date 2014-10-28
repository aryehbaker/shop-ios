//
//  iSQLiteHelper.h
//  iSQLite
//
//  Created by vnidev on 10/9/14.
//  Copyright (c) 2014 vniapp.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LKDBHelper.h"
#import "JSONModel.h"

@interface iSQLiteHelper : NSObject

+(LKDBHelper *)getUsingLKDBHelper:(NSString *)name;
+(LKDBHelper *)getDefaultHelper;

@end

/**
  {
     "name" : "demo",
     "numbers" : 2,
     "children" : [
          {
             "pro1" : "value",
             "pro2" : "value2"
          },
          {
            "pro1" : "value",
            "pro2" : "value2"
          },
          {
            "pro1" : "value",
            "pro2" : "value2"
          }
     ]
  }
 
 */


@interface LKDBHelper (iSQLLite)

/* 默认是看是否为存在rowid 字段作为主键 */
- (void)insertOrUpdateUsingObj:(NSObject *)model;
- (void)insertOrUpdateUsingAry:(NSArray *)values;

- (BOOL)insertOrUpdateDB:(Class)model value:(NSDictionary *)value;
- (BOOL)insertOrUpdateDB:(Class)model values:(NSArray *)values;

- (BOOL)deleteModel:(Class)model byId:(id)rowid;

- (id)searchModel:(Class)model byId:(id)rowid;

- (NSMutableArray *)searchAllModel:(Class)model;
- (NSMutableArray *)searchModels:(Class)model where:(id)where;

- (void)makeTable:(Class)model;

@end

@interface NSSet (iSQLLite)
- (NSString *)join:(NSString *)speator;
@end