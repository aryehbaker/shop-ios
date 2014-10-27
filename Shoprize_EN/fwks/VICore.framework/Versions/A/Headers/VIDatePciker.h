//
//  VIDatePciker.h
//  BossE_V1
//
//  Created by mk on 12-11-2.
//
//

#import <UIKit/UIKit.h>
#import <VICore/VICore.h>

typedef NS_ENUM(NSInteger, VIDatePcikerModel) {
    VIDatePcikerModelWeek,
    VIDatePcikerModelMonth,
    VIDatePcikerModelYear,
    VIDatePcikerModelYMD,
    VIDatePcikerModelYMDHM
};

//导航页面的样式
typedef NS_ENUM(NSInteger,TAB_NAV_STYLE ){
    TAB_NO_NAV_NO,  //无Tab无NAV
    TAB_YES_NAV_NO, //有Tab无NAV
    TAB_NO_NAV_YES, //无Tab有NAV
    TAB_YES_NAV_YES //有Tab有NAV
};

/** 日期选择完毕之后操作 */
typedef void (^DatePickEnd )(NSString *start, NSString *end, UIViewController *inv);

@interface VIDatePciker : UIView <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIView *pickAndBar;
}

/**
 *  初始化选择模式，需要操作的类
 */
- (id)initWithDateModel:(VIDatePcikerModel)model style:(TAB_NAV_STYLE)style inc:(UIViewController *)inc afterChoose:(DatePickEnd)pickend;

- (void)setValueAt:(NSInteger)at1 at2:(NSInteger)at2;

- (void)setMinDate:(NSDate *)date;

- (void)setMaxDate:(NSDate *)date;

+ (NSInteger)weekOfYear;

@end
