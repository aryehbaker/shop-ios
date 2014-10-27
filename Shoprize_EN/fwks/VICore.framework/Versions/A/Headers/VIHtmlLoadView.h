//
//  HtmlLoadView.h
//  BossE_V1
//
//  Created by monlyu on 12-10-26.
//  用于加载以后的Html的专属类
//
//   程序的js依赖
//    > jquery-1.7.2.min.js 这个文件
//    > formAction.js
//

#import <UIKit/UIKit.h>
#import <VICore/VIMacro.h>


@class VIHtmlLoadView;

@protocol VIHtmlLoadViewDelegate <NSObject>
@optional

/*!
 *  开始加载对应的Html
 *  请使用 loadHtmlStart!html 代替
 */
- (void)loadHtmlStart VI_DEPRECATED;

/*!
 *  开始加载对应的Html
 *  \param htmlView 对应的视图内容
 */
- (void)loadHtmlStart:(VIHtmlLoadView *)htmlView;

/*!
 *  开始加载对应的Html
 *  \param htmlView 对应的视图内容
 */
- (void)loadhtmlSuccess:(NSString *)succ error:(NSError *)error VI_DEPRECATED;

/*!
 *  开始加载对应的Html
 *  \param htmlView 对应的视图内容
 */
- (void)loadHtml:(BOOL)complete htmlView:(VIHtmlLoadView*)htmlView error:(NSError *)error;

/*!
 * javascript 的函数回调
 */
- (void)callObjcFunc:(NSString *)funName args:(id)args;

@end


@interface VIHtmlLoadView : UIView <UIWebViewDelegate> {
    UIWebView *displayview;
}
@property(nonatomic,retain) UIWebView *content;
@property(nonatomic,copy) NSString *htmlFileName;
@property(nonatomic, assign) id <VIHtmlLoadViewDelegate> delegate;

/*
 * 初始化整个加载解构
 */
- (id)initWithFrame:(CGRect)frame withHtmlName:(NSString *)htmlName;

/**
 * 加载具体的某个Html文件
 */
- (void)loadHtml:(NSString *)htmlFile;

/**
 *  加载Html的文字内容，然后显示到对应的视图中
 */
- (void)loadHtmlString:(NSString *)htmlContent;

/**
 * 再加载完成之后的回调操作
 */
- (void)loadHtml:(NSString *)htmlFile afterload:(void(^)(VIHtmlLoadView *htmlloadView))callback ;
/**
 * 调用JS 文件信息
 */
- (NSString *)invokeJS:(NSString *)script;

/*!
 * 调用JS的函数
 * @param funName 函数名称
 * @param args    参数名字
 */
- (NSString *)invokeJS:(NSString *)funName args:(NSDictionary *)args;

/*!
 * 调用JS的函数
 * @param funName 函数名称
 * @param ...     函数参数
 */
- (NSString *)invokeFun:(NSString *)funName,...;

/**
 * 设置表单的值
 */
- (void)setFormValue:(NSMutableDictionary *)values;

/**
 * 设置表单的值
 */
- (void)setFormValue:(NSMutableDictionary *)values withFilter:(NSString *)filter;

/**
 * 设置某个字段的值
 */
- (void)setValue:(NSString *)value toFiled:(NSString *)field;

/**
 * 获取表单的全部值
 */
- (NSMutableDictionary *)getFormValus;

/**
 * 设置某个字段为只读
 */
- (void)setReadonly2Filed:(NSString *)field onlyRead:(BOOL)ready;

@end
