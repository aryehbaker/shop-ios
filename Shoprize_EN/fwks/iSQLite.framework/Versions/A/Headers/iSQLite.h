//
//  iSQLite.h
//  iSQLite
//
//  Created by vnidev on 10/9/14.
//  Copyright (c) 2014 vniapp.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for iSQLite.
FOUNDATION_EXPORT double iSQLiteVersionNumber;

//! Project version string for iSQLite.
FOUNDATION_EXPORT const unsigned char iSQLiteVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <iSQLite/PublicHeader.h>

#import <iSQLite/iSQLiteHelper.h>

//JSONModel transformations
#import <iSQLite/JSONValueTransformer.h>
#import <iSQLite/JSONKeyMapper.h>

//basic JSONModel classes
#import <iSQLite/JSONModelError.h>
#import <iSQLite/JSONModelClassProperty.h>
#import <iSQLite/JSONModel.h>


#import <iSQLite/LKDBHelper.h>
#import <iSQLite/LKDBProperty.h>
#import <iSQLite/LKDBUtils.h>
#import <iSQLite/NSObject+LKModel.h>
#import <iSQLite/NSObject+LKDBHelper.h>
