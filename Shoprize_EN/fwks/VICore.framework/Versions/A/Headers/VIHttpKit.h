//
//  HttpReq.h
//
//  Created by mk on 12-10-26.
//
//


#import "VIHttpBase.h"
#import <VICore/VIParts.h>

typedef NS_ENUM(NSInteger, ARGS_TYPE) {
    ARGS_QUESTION,     /* 参数类似于 ?arg1=1&arg2=2 */
    ARGS_SLANT         /* 参数类似于 /arg1/1/arg2/2 */
};

@interface VIHttpKit : VIHttpBase

@property(nonatomic,copy) MKNKProgressBlock mkblock; //用于回调的函数

//取消设置对应的上下文
+(void)viewDidload:(UIViewController *)ctrl;
+(void)viewWillAappear:(UIViewController *)ctrl;
+(void)viewDidDisAappear:(UIViewController *)ctrl;

+(void)stopAllRequest;

//在程序初始化的时候调用一次
+(void)setPlatform:(ARGS_TYPE)platform;

/**
 *  接口调用处理方法
 *
 *  api     (NSString)      API的名字或者URL连接
 *  args    (NSDictionary)  > 参数信息
 *  _target  (id)  > 等待处理的函数类
 *  succ    SEL  > 调用成功处理的函数
 *  error    SEL  > 调用失败的处理的函数
 */
+ (void)invokeApi:(NSString *)api
             args:(id)args
           target:(id)_target
             succ:(SEL)success
            error:(SEL)error;

// 这个是同上
+ (void)invokeApi:(NSString *)api
             args:(id)args
           target:(id)_target
             succ:(SEL)success
            error:(SEL)error
              inv:(UIView *)view;

//这个同上
+ (void)invokeGetApi:(NSString *)api
                args:(id)args
              target:(id)_target
                succ:(SEL)success
               error:(SEL)error;

//这个是同上
+ (void)invokeGetApi:(NSString *)api
                args:(id)args
              target:(id)_target
                succ:(SEL)success
               error:(SEL)error
                 inv:(UIView *)waitView;

/**
 *  接口调用处理方法
 *
 *  fullUrl    全路径，带Http请求的
 *  args    (NSDictionary)  > 参数信息
 *  _target  (id)  > 等待处理的函数类
 *  succ    SEL  > 调用成功处理的函数
 *  error    SEL  > 调用失败的处理的函数
 */
+ (void)invokeHttp:(NSString *)fullUrl
              args:(id)args
            target:(id)_target
              succ:(SEL)success
             error:(SEL)error;

/**
 * @param url     下载的包的地址
 * @param toDir   下载后下载的地址
 * @param showin  是否显示下载的进度
 *
 */
+(VIHttpKit *)downloadUrl:(NSString *)url args:(id)args toFile:(NSString *)file callbk:(MKNKProgressBlock)callbk;

/*
 *  返回图片的URL地址
 */
+ (NSString *)imageUrl;

/**
 *  返回基础路径URL
 */
+ (NSString *)baseURL;

/**
 * 获取程序的APPkey
 */
+ (NSString *)appKey;


@end
