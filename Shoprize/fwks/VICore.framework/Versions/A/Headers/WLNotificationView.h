#import <UIKit/UIKit.h>
/**
 *定义通知的类型
 */
typedef enum {
	CINotificationTypeDefault,	/** 默认样式 */
	CINotificationTypeBlue,		/** 蓝色背景 */
	CINotificationTypeRed,		/** 红色背景 */
	CINotificationTypeGreen,	/** 绿色背景 */
	CINotificationTypeOrange	/** 橙色背景 */
} CINotificationType;

typedef enum {
	CILinedBackgroundTypeDisabled,	/** 背景的默认 */
	CILinedBackgroundTypeStatic,	/** 静态的背景 */
	CILinedBackgroundTypeAnimated	/** 动态的背景 */
} CILinedBackgroundType;

/**
 *    通知栏的样式
 *    @author mk
 */
@interface WLNotificationView : UIView

/**
 *    Show default notification (gray), hide after 2.5 seg
 *    @param view 在哪个视图中显示
 *    @param title 标题
 */
+ (void)showNoticeInView:(UIView *)view title:(NSString *)title;

/**
 *    Show default notification (gray)
 *    @param view 视图容器
 *    @param title 标题
 *    @param hideInterval 在多少秒后消失
 */
+ (void)showNoticeInView:(UIView *)view title:(NSString *)title hideAfter:(NSTimeInterval)hideInterval;

/**
 *    显示消息
 *    @param view 视图容器
 *    @param type 类型
 *    @param title 标题
 *    @param hideInterval 多少秒后消失
 */
+ (void)showNoticeInView:(UIView *)view type:(CINotificationType)type title:(NSString *)title hideAfter:(NSTimeInterval)hideInterval;

/**
 *    全函数
 *    @param view 视图容器
 *    @param type 类型
 *    @param title 标题
 *    @param backgroundType 背景
 *    @param hideInterval 多少秒后消失
 */
+ (void)showNoticeInView:(UIView *)view type:(CINotificationType)type title:(NSString *)title linedBackground:(CILinedBackgroundType)backgroundType hideAfter:(NSTimeInterval)hideInterval;

+ (void)showNoticeInView:(UIView *)view type:(CINotificationType)type title:(NSString *)title linedBackground:(CILinedBackgroundType)backgroundType hideAfter:(NSTimeInterval)hideInterval txtAlign:(NSTextAlignment)align;
@end

