//
//  App.h
//  VICore
//
//  Created by vnidev on 8/28/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef NS_Ext
#define NS_Ext
#define Map     NSMutableDictionary *
#define E_Map   [NSMutableDictionary dictionary]
#define List    NSMutableArray *
#define E_List  [NSMutableArray array]
#endif

typedef NS_ENUM(NSInteger, HttpType) {
    JSON = 1UL << 1,
    TEXT = 1UL << 2,
    DATA = 1UL << 3,
    
    And   = 1UL << 6, /* & */
    Slash = 1UL << 7  /* / */
};

@interface App : NSObject

+ (NSString *)imageUrl;
+ (NSString *)baseURL;

/**
 * files NSArray<VIHttpFile>
 */
+ (void)request:(NSString *)fullurl post:(BOOL)post
           args:(id)args header:(id)header files:(NSArray*)files call:(void(^)(BOOL succ,id resp))call;

+ (BOOL)can_reach_baidu;
+ (BOOL)can_reach_google;

@end

@interface HttpCfg : NSObject

@property  (nonatomic,retain) Map       header;
@property  HttpType                     split;          //   "&"  "/"
@property  HttpType                     resptype;
@property  (nonatomic,copy)   NSString  *baseURL;

- (HttpCfg *)addHeader:(Map)head;
- (HttpCfg *)respType:(HttpType)type;
- (HttpCfg *)split:(HttpType)split;
+ (HttpCfg *)defCfg;

@end

////////////////////定义文件级别内容//////////////////////
typedef NS_ENUM(NSInteger, HttpFileType) {
    HttpImage = 1UL << 1,
    HttpFile  = 1UL << 2,
    HttpJSON  = 1UL << 3
};

@interface VIHttpFile : NSObject

@property(nonatomic,copy)   NSString *postKey;
@property(nonatomic,copy)   NSString *mineType;
@property(nonatomic,copy)   NSString *fileName;
@property(nonatomic,retain) NSData *postData;
@property(assign) HttpFileType postType;

-(VIHttpFile *)postKey:(NSString *)key;
-(VIHttpFile *)mineType:(NSString *)type;
-(VIHttpFile *)postData:(NSData *)data;
-(VIHttpFile *)postType:(HttpFileType)type;
-(VIHttpFile *)fileName:(NSString *)fileName;

+(VIHttpFile*)newFile:(NSData *)data type:(HttpFileType)type mineType:(NSString *)mineType;
+(VIHttpFile*)newImage:(UIImage *)image name:(NSString *)name;
+(VIHttpFile*)newFile:(NSString *)path mineType:(NSString *)mineType;
+(VIHttpFile*)newJson:(NSString *)json;

@end