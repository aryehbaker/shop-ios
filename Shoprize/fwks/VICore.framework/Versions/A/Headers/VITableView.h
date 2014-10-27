//
//  WLTableView.h
//  Test
//
//  Created by Hong on 12-11-4.
//  Copyright (c) 2012年 Hong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <VICore/VICore.h>

@class VITableView;

/**
 *    TableView的协议
 *    @author mk
 */
@protocol VITableViewDelegate <NSObject>

// ---------- Load more ----------
@required

/**
 *    获得更多
 *    @param t 参数
 */
- (void)loadMoreStarted:(VITableView *)t;

/**
 *    下拉刷新
 *    @param t 表格
 */
- (void)pullDownRefrshStart:(VITableView *)t;

@optional

/**
 *    tableView的高度
 *    @param indexPath 高度
 *    @returns 获得单元格的高度
 */
- (CGFloat)heightAtRow:(NSIndexPath *)indexPath;

/**
 *    选择事件
 *    @param indexPath
 */
- (void)rowSelectedAtIndexPath:(NSIndexPath *)indexPath;

/**
 *    删除按钮
 *    @param indexPath
 *    @returns
 */
- (NSString *)titleForDeleteBtn:(NSIndexPath *)indexPath;
/**
 * 编辑列表的样式
 */
- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 *    Header的View
 *    @param section
 *    @returns
 */
- (UIView *)viewForHeaderInSection:(NSInteger)section;

/**
 *    Header的图片
 *    @param section
 *    @returns
 */
- (CGFloat)heightForHeader:(NSInteger)section;

@end

/**
 *    图片
 *    @author mk
 */
@interface VITableView : UITableView <UITableViewDelegate>{}

/**
 *    最后更新时间
 */

@property(nonatomic, retain) NSDate *lastUpdate;

@property(nonatomic, assign) id <VITableViewDelegate> viewDelegate;

-(void)addRefrshViewHeader;

/**
 *    是否在加载中
 *    @returns
 */
- (BOOL)isLoading;

/**
 *    加载更多
 */
- (void)reloadDataAndFixMore;

/**
 *    加载状态
 *    @param hide
 */
- (void)setLoadMoreStatus:(BOOL)hide;	// set loadMore view hide

/**
 *    停止加载
 */
- (void)stopLoadMoreAction;				// when you finish get data you will call this method

/**
 *    刷新表格，并且显示和影藏加载更多
 *    @param hide 影藏显示
 *    自行加入扩展内容进行覆盖对应的函数
 */
- (void)reloadAndHideLoadMore:(BOOL)hide;

/**
 * 设置下拉刷新的背景颜色,
 * 如果想全局的设置，
 * #define _Ref_Cfg_Top_Color
 * #define _Ref_Cfg_But_Color
 */

- (void)setRefreshBackColorAsTop:(NSString *)color buttom:(NSString *)buttom;


/**
 * 当加载失败的时候处理的草组
 */
- (void)VItableWhenLoadDataFail:(NSNumber *)pageNum isFisrtPage:(BOOL)fisrt errInfo:(NSString *)errInfo;

@end

