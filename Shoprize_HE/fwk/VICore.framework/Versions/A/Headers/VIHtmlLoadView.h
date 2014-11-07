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

typedef NS_ENUM(NSInteger, JsScript) {
	HideKeyBoard = 1<<1
};

@class VIHtmlLoadView;

@protocol VIHtmlLoadViewDelegate <NSObject>
@optional

/*!
 *  开始加载对应的Html
 *  请使用 loadHtmlStart!html 代替
 */
- (void)loadHtmlStart:(VIHtmlLoadView *)htmlView;
- (void)loadHtml:(BOOL)complete htmlView:(VIHtmlLoadView*)htmlView error:(NSError *)error;
- (void)callObjcInWebview:(VIHtmlLoadView*)webview func:(NSString *)funName args:(id)args;

@end


@interface VIHtmlLoadView : UIView <UIWebViewDelegate> {
    UIWebView *displayview;
}
@property(nonatomic,retain) UIWebView *content;
@property(nonatomic,copy) NSString *htmlFileName;
@property(nonatomic, assign) id <VIHtmlLoadViewDelegate> delegate;

/* 初始化整个加载解构 */
- (id)initWithFrame:(CGRect)frame;
- (id)initWithFrame:(CGRect)frame withHtmlName:(NSString *)htmlName;

- (void)loadHtml:(NSString *)htmlFile;          /**  加载具体的某个Html文件 */
/**再加载完成之后的回调操作 */
- (void)loadHtml:(NSString *)htmlFile afterload:(void(^)(VIHtmlLoadView *htmlloadView))callback ;
- (void)loadHtmlString:(NSString *)htmlContent; /** 加载Html的文字内容，然后显示到对应的视图中 */
- (void)loadWYSIWYGString:(NSString *)htmCtx;

/**  调用JS 文件信息 */
- (NSString *)invokeJS:(NSString *)funName args:(NSDictionary *)args;
- (NSString *)invokeJS:(NSString *)funName,... ;
- (NSString *)invokeJScript:(JsScript)script;

- (void)setFormValue:(NSMutableDictionary *)values;
- (void)setValue:(NSString *)value toFiled:(NSString *)field;

/**获取表单的全部值 */
- (NSMutableDictionary *)getFormValus;
- (void)setFiled:(NSString *)field readonly:(BOOL)ready;

@end
