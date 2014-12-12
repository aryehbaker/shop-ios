//  Created by mk on 13-7-19.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

/**
  {
    "cell": {
        "class": "VTBaseCell",
        "xibtag"  : "xibName#Tag"  //当这个xib只有xib组成的时候，请配合
    },
    "view": {
        "group": false | true, [是否为分组]
        "separator": "SingleLine || SingleLine || SingleLineEtched || tablebg.png || #000000",
        "separatorInCell" : false,
        "background" : "none || tablebg.png || #000000 ",
        "backview" : "none || 图片名字 || #颜色",
        "refreshStyle" : "text | auto"
    },
    "datasource": {
        "url": "http://192.168.2.137/test/index.php",
        "post": false,
        "pageable": false,
        "datakey": "show_data",
        "pageCfg": {
        "itemskey" : "data",
 
        "pagenumkey": "pageNo",
        "pagenum" : 1,
        "pagesizekey": "pageSize",
        "pagesize" : 20,
 
        "totalpagekey": "pagetotal"
    }
 }
 
 */


#import <UIKit/UIKit.h>

@protocol VICfgTableProto;
@protocol VICellCfg;
@class    VICfgCellBtn;

@interface VICfgTableView : UIView <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, retain) UITableView	*cfgTable;
@property(nonatomic, assign) id<VICfgTableProto>   delegate;

@property(nonatomic, retain) NSMutableDictionary	*baseArgs;
@property(nonatomic, retain) NSMutableArray			*listData;	// 所有的数据存储
@property(nonatomic, retain) NSMutableDictionary	*groupData;	// 分组数据的存放

- (id)initWithFrame:(CGRect)frame cfg:(NSString *)_confg;

/**
 *    设置显示的数据
 *    @param data 数据
 */
- (void)setData:(id)data;

/**
 * 获得索引对应的内容
 */
- (UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexpath;

/**
 * 在加载完数据之后要调用的操作
 * tabledata 所有的数据
 * loaddata  加载的数据
 */
- (void)afterFinishLoadData:(void (^)(id tabledata,id loaddata))finished;

/**
 * 加载获得数据完之后做的操作
 * httpdata 所有的数据
 */
- (void)doAfterDataGeted:(void(^)(id httpdata))callbk;

/**
 * 设置特殊的标记内容,有些按钮层次较深，无法迭代循环获得。
 * 通过这个方法去设置内容
 */
- (void)setSpecialCellBtnTags:(NSArray *)tags;

/*!
 * 删除某一行的数据信息，数据包括了表格和内容信息
 */
- (void)removeViewAndDataAtIndex:(NSIndexPath *)indexpath;

/*!
 * add the Info to Each itemValue
 */
- (void)extForItem:(NSDictionary *)ext;
/**
 *    设置基础的请求参数，比如用户名等
 *    @param baseArgs (NSDictionary) 基础参数
 */
- (void)startLoad;
- (void)startLoadUse:(id)_baseArgs;

@end


/***************************************************************************************/
/*************************************单元格上的Cell的类**********************************/
/***************************************************************************************/

@interface VICfgCellBtn : UIButton
// 用于存储当前btn所在行列的位置
@property(nonatomic,retain) NSIndexPath *indexPath;
  // 用于存储对应的在Cell上的位置
@property(nonatomic,assign) NSInteger index;

@end

/***************************************************************************************/
/*************************************定义的协议******************************************/
/***************************************************************************************/

@protocol VICfgTableProto <NSObject>

@optional

/**
 *    单元格选中的操作
 *    @param index 索引
 *    @param data 数据信息
 */
- (void)rowSelectedAt:(NSIndexPath *)index data:(id)data;

/**
 * 返回总页数
 */
- (int)totalPage:(NSDictionary *)returnInfo;

/**
 * 当数据刷新完之后需要调用的处理操作
 */
- (void)willCallAfterTableReload:(VICfgTableView *)tableview;

/**
 *    单元格上的button点击产生的事件
 *    @param path 路径
 *    @param data 数据
 */
- (void)rowBtnsClick:(NSIndexPath *)path data:(id)data btn:(VICfgCellBtn *)btn;


/**
 * 当 xibTag不为空的时候才会调用这个方法
 */
- (void)repaintCell:(UITableViewCell *)cell atPath:(NSIndexPath *)path onTable:(VICfgTableView *)cfgTableview withValue:(id)value;

@end


/***************************************************************************************/
/*************************************单元格的协议****************************************/
/***************************************************************************************/

@protocol VICellCfg <NSObject>

@optional
/**
 *    初始化表格单元格德内容
 *    @param cellId 单元格ID
 *    @returns 返回初始化的对象
 */
- (id)initClassWithId:(NSString *)reuseIdentifier;

/**
 *    获得单元格的高度
 *    @param value 单元格的值
 *    @param path 第几排的内容
 *    @param tableview 所属表格
 *    @returns 获得对应的高度
 */
- (CGFloat)heightForValue:(id)value path:(NSIndexPath *)path tableview:(VICfgTableView *)cfgTableview;

/**
 *    获得单元格的高度
 *    @param value 单元格的值
 *    @param path 第几排的内容
 *    @param tableview 所属表格
 */
- (void)repaintCellForValue:(id)value path:(NSIndexPath *)path tableView:(VICfgTableView *)cfgTableview;


@end

/***************************************************************************************/
/*************************************  单元格上基础类  **********************************/
/***************************************************************************************/

@interface VIBaseCell : UITableViewCell<VICellCfg>

- (void)initContentViewWithXib:(NSString *)xib andTag:(int)tag;

@end
