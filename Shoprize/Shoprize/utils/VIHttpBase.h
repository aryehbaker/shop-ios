//
//  VTHttpBase.h
//  Shoprize
//
//  Created by vniapp on 11/3/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <VICore/VICore.h>


//http type
typedef NS_ENUM(NSInteger, HTTP_METHOD_TYPE)
{
    HTTP_MD_POST,   //
    HTTP_MD_GET,
    HTTP_MD_PUT,
    HTTP_MD_DELETE,
    HTTP_MD_INPUT
};

@interface VIHttpBase : NSObject

@property(nonatomic, assign) SEL succ;
@property(nonatomic, assign) SEL fail;
@property(assign) id target;
@property(nonatomic, retain) UIView *waitInView;

@property(nonatomic, assign) HTTP_METHOD_TYPE method;
@property(nonatomic, assign) long hashVal;

@property(nonatomic, retain) MKNetworkOperation *operation;

//add media to file
- (void)setMediaToRequest:(MKNetworkOperation *)operation params:(NSMutableDictionary *)params;

//http type string
- (NSString *)httpTypeString:(HTTP_METHOD_TYPE)type;

//添加数据
- (NSDictionary *)headers;

@end
