//
//  VTHttpBase.h
//  VTCore
//
//  Created by mk on 13-3-31.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//
//  网络实现类的基础类
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class VTMBProgressHUD;
@class MKNetworkOperation;
@class MKNetworkEngine;

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

//get html data at background
+ (void)lookUpHttpData:(NSString *)url target:(id)_trget succ:(SEL)succ error:(SEL)error inV:(UIView *)waitview;

//add media to file
- (void)setMediaToRequest:(MKNetworkOperation *)operation params:(NSMutableDictionary *)params;

//Find the host and the path
- (NSArray *)findHostAndPath:(NSString *)url;

//http type string
- (NSString *)httpTypeString:(HTTP_METHOD_TYPE)type;

//添加数据
- (NSDictionary *)headers;

@end
