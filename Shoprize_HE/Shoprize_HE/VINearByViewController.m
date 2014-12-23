//
//  VINearByViewController.m
//  Shoprise_EN
//
//  Created by mk on 4/2/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VINearByViewController.h"
#import <Shoprize/Shoprize.h>
#import "VIAppDelegate.h"
#import <Shoprize/KUtils.h>
#import <iSQLite/iSQLite.h>
#import <Shoprize/VITimeDownCell.h>
#import <Shoprize/Ext.h>

typedef enum {Deals = 1,Suprises = 2,Stores = 3} ListType ;

static ListType currentType;

@interface VINearByViewController ()
{
    VITableView *_tableView;
    
    UIButton *section1,*section2,*section3;
    NSMutableArray *deals,*suprises,*stores;
    NSMutableArray *allStore;
}

@end

@implementation VINearByViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    deals = [NSMutableArray array];
    suprises = [NSMutableArray array];
    stores = [NSMutableArray array];
    
    [self addNav:@"" left:SEARCH right:MENU];
    [self.leftOne setHidden:YES];
    
    [self.nav_title addTapTarget:self action:@selector(showOpenHour:)];
    
    UIView *top1 = [[UIView alloc] initWithFrame:Frm(0, self.nav.endY, self.view.w, 35)];
    
    section1 = [[UIButton alloc] initWithFrame:Frm(0, 0, 106, 35)];
    [section1 setTitle:Lang(@"main_suprises") selected:Lang(@"main_suprises")];
    [section1 setBackgroundcolorByHex:@"#ff4747"];
    section1.tag = Suprises;
    [section1 setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    section1.titleLabel.font = Bold(17);
    [section1 addTarget:self action:@selector(changeType:)];
    [top1 addSubview:section1];
    UIImageView *icon = [@"supriset_w.png" imageViewForImgSizeAtX:section1.w-27 Y:6];
    icon.tag = 100;
    [section1 addSubview:icon];
    
    section2 = [[UIButton alloc] initWithFrame:Frm(section1.endX, section1.y, 106, 35)];
    [section2 setTitle:Lang(@"main_deals") selected:Lang(@"main_deals")];
    [section2 setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    [section2 setBackgroundcolorByHex:@"#ff4747"];
    section2.titleLabel.font = Bold(17);
    section2.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
    section2.tag = Deals;
    [section2 addTarget:self action:@selector(changeType:)];
    [top1 addSubview:section2];
    icon = [@"deal_w.png" imageViewForImgSizeAtX:section1.w-28 Y:6];
    icon.tag = 100;
    [section2 addSubview:icon];
    
    section3 = [[UIButton alloc] initWithFrame:Frm(section2.endX, section1.y, 108, 35)];
    [section3 setTitle:Lang(@"main_stores") selected:Lang(@"main_stores") ];
    [section3 setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    [section3 addTarget:self action:@selector(changeType:)];
    [section3 setBackgroundcolorByHex:@"#ff4747"];
    section3.titleLabel.font = Bold(17);
    section3.tag = Stores;
    icon = [@"store_w.png" imageViewForImgSizeAtX:section1.w-27 Y:7];
    icon.tag = 100;
    [section3 addSubview:icon];
    
    [top1 addSubview:section3];
    [self.view addSubview:top1];
    
    _tableView = [[VITableView alloc] initWithFrame:Frm(0, top1.endY, self.view.w, Space(top1.endY)) style:UITableViewStylePlain];
    _tableView.delegate = _tableView;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.viewDelegate = self;
    _tableView.dataSource = self;

    [self.view addSubview:_tableView];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"hadVisited"]) {
        UIWindow *w = ((VIAppDelegate *)[UIApplication sharedApplication].delegate).window;
        UIView *al = [[UIView alloc] initWithFrame:w.bounds];
        al.tag = -10002;
        UIImageView *guid = [@"howtoshow.png" imageViewForImgSizeAtX:0 Y:0];
        guid.userInteractionEnabled = NO;
        [al addSubview:guid];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = Frm(50, w.h - 60, self.view.w-100, 40);
        btn.backgroundColor = [@"#ff4747" hexColor];
        [btn setTitle:Lang(@"i_see_close_it") selected:Lang(@"i_see_close_it")];
        btn.layer.cornerRadius = 20;
        btn.titleLabel.font = Bold(18);
        [btn addTarget:self action:@selector(closeThem:)];
        [al addSubview:btn];
        
        [w addSubview:al];
    }
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadTheNearMallDetail:) name:_NOTIFY_MALL_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(reloadSurpiseShow:) name:@"reloadSurpiseShow" object:nil];
    
    
    //NSString *mall_select = [NSUserDefaults getValue:CURRENT_MALL_USER_SELECTED];
    
    //只要到这里就从新加载最近的Mall
    [VINet get:@"/api/malls/nearby?radius=0" args:nil target:self succ:@selector(getMalls:) error:@selector(getMallsFail:) inv: deals.count> 0 ? nil : self.view];
    
    /*
    if (mall_select == nil) {
        [VINet get:@"/api/malls/nearby?radius=0" args:nil target:self succ:@selector(getMalls:) error:@selector(getMallsFail:) inv: deals.count> 0 ? nil : self.view];
    }else{
        //恢复回原来的值
       MallInfo *selectedOne = [[iSQLiteHelper getDefaultHelper] searchSingle:[MallInfo class] where:@{@"MallAddressId" : mall_select} orderBy:@"Name"];

        ((VIAppDelegate *)[UIApplication sharedApplication].delegate).currentMall = selectedOne;
        [VINet get:@"/api/malls/nearby?radius=0" args:nil target:self succ:@selector(rebulidMall:) error:@selector(getMallsFail:) inv:nil];
        self.nav_title.text = selectedOne.Name;
        [self refreshToShowTheTable];
    }
    */
    
    [VINet regPushToken];
}

//获得所有的deal
- (NSMutableArray *)findDeals:(NSString *)key{
    
    LKDBHelper *helper  = [iSQLiteHelper getDefaultHelper];
    NSString *mallid    = [NSUserDefaults getValue:CURRENT_MALL_USER_SELECTED];
    NSString *like = @"";
    if (key!=nil)
        like = Fmt(@" and (Offer like '%%%@%%' or StoreName like '%%%@%%')",key,key);
    
    NSString *sql = Fmt(@"select * from MobiPromo where Type = 'Deal' and StoreId in (select s.StoreId from Store s where s.MallId='%@') %@ order by CreateDate desc",mallid, like);
    
    return [helper searchWithSQL:sql toClass:[MobiPromo class]];
}

- (void)refreshToShowTheTable
{
    LKDBHelper *helper  = [iSQLiteHelper getDefaultHelper];
    NSString *mallid    = [NSUserDefaults getValue:CURRENT_MALL_USER_SELECTED];
    
    deals = [self findDeals:nil];
    
    NSString *sql = Fmt(@"select * from MobiPromo where Type = 'Surprise' and  StoreId in(select StoreId from Store s where s.MallId='%@') order by CreateDate desc",mallid);
    suprises = [helper searchWithSQL:sql toClass:[MobiPromo class]];
    
    sql = Fmt(@"select * from Store where MallId='%@' ",mallid);
    stores   =  [helper searchWithSQL:sql toClass:[Store class]];
    
    allStore  = [stores copy];
    
    [self changeType:section2];
}

-(void)reloadSurpiseShow:(NSNotification *)noti
{
     [_tableView reloadData];
}

-(void)rebulidMall:(NSArray *)values {
    [self saveMall2DB:values];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:_NOTIFY_MALL_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadSurpiseShow" object:nil];
}

- (void)reloadTheNearMallDetail:(NSNotification *)notify {
    NSDictionary *notifyObj = notify.object;
    MallInfo *mall = [[MallInfo alloc] initWithDictionary:notifyObj error:nil];
    ((VIAppDelegate *)[UIApplication sharedApplication].delegate).currentMall = mall;
    
    [self notifyChange:self.view];
}

- (void)closeThem:(UIButton *)sneder
{
    UIWindow *w = ((VIAppDelegate *)[UIApplication sharedApplication].delegate).window;
    UIView *v = [w viewWithTag:-10002];
    [UIView animateWithDuration:.38 animations:^{
        v.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hadVisited"];
            [v removeFromSuperview];
        }
    }];
    
}

- (void)showLog:(id)val{
    DEBUGS(@"%@",val);
}

- (void)notifyChange:(UIView *)loadView{
    
    MallInfo *currentMall = ((VIAppDelegate *)[UIApplication sharedApplication].delegate).currentMall;
    
    //用户选择的MallId
    [NSUserDefaults setValue:currentMall.MallAddressId forKey:CURRENT_MALL_USER_SELECTED];
    
    [deals removeAllObjects],[suprises removeAllObjects],[stores removeAllObjects];
    [_tableView reloadData];
    
    self.nav_title.text =  currentMall.Name;
    [VINet get:Fmt(@"/api/malls/%@/detail",currentMall.MallAddressId) args:nil target:self succ:@selector(getMallProms:) error:@selector(getMallsFail:) inv:loadView];
}

- (void)getMallProms:(id)value
{
    
    JSONModelError *jsonerr;
    Mall *mall = [[Mall alloc] initWithDictionary:value error:&jsonerr];
    [mall saveMallToDatabase];
    
    VIAppDelegate *dele = (VIAppDelegate *)[self AppDelegate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_add_current_track_" object:
     @{@"Type": @"Mall",@"ReferenceId": [dele.currentMall MallAddressId]}];
    
    //数据组装完成之后进行刷新 @"F62D3F65-2FCB-AB76-00AB-68186B10300D"/*
    [self refreshToShowTheTable];
}

//存储到数据库中
- (void)saveMall2DB:(NSArray *)values {
    [[iSQLiteHelper getDefaultHelper] deleteWithClass:[MallInfo class] where:@"1=1"];
    [[iSQLiteHelper getDefaultHelper] insertOrUpdateDB:[MallInfo class] values:values];
    //通知重新建立地理围墙
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_rebuild_geo_wall" object:nil];
}

-(void)getMalls:(NSArray *)values
{
    if (values == nil || values.count == 0) {
        [VIAlertView showErrorMsg:Lang(@"no_mall_founded")];
        return;
    }
    [self saveMall2DB:values];
    MallInfo *nearest =  [MallInfo nearestMall];
    if (nearest!=nil ) {
        ((VIAppDelegate *)[UIApplication sharedApplication].delegate).currentMall = nearest;
        [NSUserDefaults setValue:nearest.MallAddressId forKey:CURRENT_MALL_USER_SELECTED];
    }
    [self notifyChange:nil];
}

-(void)getMallsFail:(id)values
{
    [_tableView reloadAndHideLoadMore:YES];
    [self showAlertError:values];
}

- (void)showOpenHour:(id)evt
{
    MallInfo *currentMall = ((VIAppDelegate *)[UIApplication sharedApplication].delegate).currentMall;
    
    if (currentMall==nil || [self.view viewWithTag:-100]!=nil) {
        return;
    }
    // TODO 显示数组信息的第一个
    NSString *oh = [currentMall OpenHours];
    NSString *add = [currentMall Address];
    NSString *tel = [currentMall Phone];
    
    UIView *load = [KUtils makeDialog:oh addr:add tel:tel];
    
    load.backgroundColor = [UIColor clearColor];
    
    CMPopTipView *pop = [[CMPopTipView alloc] initWithCustomView:load];
    pop.backgroundColor =[@"#ffffff" hexColorAlpha:.9];
    pop.tag = -100;
    pop.hasShadow = YES;
    pop.has3DStyle = NO;
    pop.borderColor = [@"#B1B1B1" hexColor];
    pop.cornerRadius = 1;
    pop.topMargin = -10;
    
    [pop presentPointingAtView:self.nav_title inView:self.view animated:YES];
    
    UIButton *nav = [load button4Tag:4010];
    nav.layer.cornerRadius = nav.w /2 ;
    [nav setTitle:Lang(@"navi_title") selected:Lang(@"navi_title")];
    [nav setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    nav.titleLabel.font = Black(16);
    [nav addTarget:self action:@selector(goToMap:)];
}

- (void)goToMap:(id)sender
{
    MallInfo *currentMall = ((VIAppDelegate *)[UIApplication sharedApplication].delegate).currentMall;
    
    VINavMapViewController *map = [[VINavMapViewController alloc] init];
    map.destination = [[CLLocation alloc] initWithLatitude:[currentMall Lat] longitude:[currentMall Lon]];
    map.title = currentMall.Name;
    map.subtitle = currentMall.Address;
    [self push:map];
}

- (void)loadMoreStarted:(VITableView *)t
{
    
}

-(void)pullDownRefrshStart:(VITableView *)t
{
    if (currentType == Deals) {
        [self notifyChange:self.view];
    }else{
        [_tableView reloadAndHideLoadMore:YES];
    }
}

- (void)changeType:(UIButton *)btn
{
    [section1 setBackgroundcolorByHex:@"#ff4747"];
    [section1 imageView4Tag:100].image = [@"supriset_w.png" image];
    [section1 setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    
    [section2 setBackgroundcolorByHex:@"#ff4747"];
    [section2 imageView4Tag:100].image = [@"deal_w.png" image];
    [section2 setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];

    [section3 setBackgroundcolorByHex:@"#ff4747"];
    [section3 imageView4Tag:100].image = [@"store_w.png" image];
    [section3 setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    
    [btn setBackgroundcolorByHex:@"#ffffff"];
    [btn setTitleColor:[@"#ff4747" hexColor] forState:UIControlStateNormal];
    
    [btn imageView4Tag:100].image = [[@[@"",@"deal_r.png",@"supriset_r.png",@"store_r.png"] objectAtIndex:btn.tag] image];
    
    [self.leftOne setHidden:btn.tag==2];
    if (btn.tag!=2 && [self isSearchFiledShow]) {
        [self hideSearchFiled:self.leftOne];
    }
    
    currentType = (int) btn.tag;
    
    switch (btn.tag) {
        case Deals:  {
            for (UIView *v in [_tableView subviews]) { if (v.h == 65) { [v setHidden:NO]; break;}}
             _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableView.tableHeaderView = nil;
            [_tableView reloadAndHideLoadMore:YES];
        } break;
        case Suprises:  {
            for (UIView *v in [_tableView subviews]) { if (v.h == 65) { [v setHidden:YES]; break;}}
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _tableView.tableHeaderView = ({
                UIView *headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.w, 70)];
                NSString *t = [@"about_surprise" lang];
                UILabel *titleLabel = [VILabel createManyLines:Frm(10, 10, 300, 50) color:@"#464646" ft:Regular(19)  text:t];
                titleLabel.text = [t rtlTxt];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [headerView setH:titleLabel.endY+10];
                [headerView addSubview:titleLabel];
                headerView;
            });
             [_tableView reloadAndHideLoadMore:YES];
        } break;
        case Stores:  {
            for (UIView *v in [_tableView subviews]) { if (v.h == 65) { [v setHidden:YES]; break;}}
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
           _tableView.tableHeaderView = nil;
           [_tableView reloadAndHideLoadMore:YES];
        }break;
        default: break;
    }
}

-(CGFloat)heightAtRow:(NSIndexPath *)indexPath{
    switch (currentType)
    {
        case Deals:return 222; break;
        case Suprises:  return 123; break;
        case Stores:  return 112; break;
        default: return 44;
    }
}

- (void)showInfoMessage:(UIButton *)tap
{
    UIView *inms = [[UIView alloc] initWithFrame:Frm(0, 0, 200, 90)];
    UILabel *lab = [VILabel createLableWithFrame:Frm(15, 15, 170, 60) color:@"#000000" font:Bold(14) align:CENTER];
    lab.text = Lang(@"store_has_sup");
    lab.numberOfLines = 0;
    [lab autoHeight];
    [inms addSubview:lab];
    
    CMPopTipView *pop = [[CMPopTipView alloc] initWithCustomView:inms];
    pop.backgroundColor =[@"#ffffff" hexColorAlpha:.9];
    pop.borderColor = [@"#B1B1B1" hexColor];
    pop.topMargin = -10;
    pop.cornerRadius = 3;
    
    [pop presentPointingAtView:tap inView:self.view animated:YES];
}

- (void)whenSearchKey:(NSString *)search
{
    if (currentType == Stores)
    {
        if (search != nil) {
            [stores removeAllObjects];
            for (Store *d in allStore) {
                if ([d.StoreName like:search]) {
                    [stores addObject:d];
                }
            }
        }else{
            stores = [allStore mutableCopy];
        }
        [_tableView reloadData]  ;
    }
    if (currentType == Deals) {
        if (search != nil) {
            deals = [self findDeals:search];
        }else{
            deals = [self findDeals:nil];
        }
        [_tableView reloadData];
    }
}

- (void)rowSelectedAtIndexPath:(NSIndexPath *)indexPath{
//    if (typeview == Stores) {
//    }
//    [self doClickEvent:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentType == Deals) {
        static NSString *cellId = @"statci_view";
        UITableViewCell *cellview = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cellview == nil) {
            cellview = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cellview.selectionStyle = UITableViewCellSelectionStyleNone;
            [cellview.contentView addSubview:[VIBaseViewController loadXibView:@"UI.xib" withTag:1000]];
            cellview.backgroundColor = [UIColor clearColor];
            [cellview egoimageView4Tag:1001].placeholderImage = [@"no_pic.png" image];
            [cellview egoimageView4Tag:1101].placeholderImage = [@"no_pic.png" image];
        }
        
        MobiPromo *left =   [deals objectAtIndex:2 * indexPath.row];
        
        [cellview egoimageView4Tag:1001].imageURL = [NSURL URLWithString:left.defPicture];
   
        [cellview egoimageView4Tag:1002].imageURL = [NSURL URLWithString:left.StoreImageUrl];
        [cellview label4Tag:1003].text = [left.Offer killQute];
        [[cellview label4Tag:1003] setRTL];
        [cellview label4Tag:1003].font = Bold(13);
        
        BOOL isSup = left.StoreHasSuprise;
        [[cellview viewWithTag:1004] setHidden:!isSup];
        if (isSup) {
            [[cellview button4Tag:1004] addTarget:self action:@selector(showInfoMessage:)];
        }
        
        [[cellview viewWithTag:1104] setHidden:YES];
        
        MobiPromo *right =  nil;
        if ((2 * indexPath.row + 1) < deals.count) {
            right = [deals objectAtIndex:(2 * indexPath.row + 1)];
            [cellview egoimageView4Tag:1101].imageURL = [NSURL URLWithString:right.defPicture];
            [cellview egoimageView4Tag:1102].imageURL = [NSURL URLWithString:right.StoreImageUrl];
            [cellview label4Tag:1103].text = [right.Offer killQute];
            [[cellview label4Tag:1103] setRTL];
            [cellview label4Tag:1103].font = Bold(13);
            
            isSup = right.StoreHasSuprise;
            [[cellview viewWithTag:1104] setHidden:!isSup];
            if (isSup) {
                [[cellview button4Tag:1104] addTarget:self action:@selector(showInfoMessage:)];
            }
        }
        
        [[cellview viewWithTag:1105] setHidden:right == nil];
        
        int i = 0;
        for (UIView *view in [cellview.contentView subviews]) {
            for (UIView *view2 in [view subviews]) {
                if ([view2 isKindOfClass:[VICfgCellBtn class]]) {
                    long tag = indexPath.row * 10 + i;
                    VICfgCellBtn *btns =  (VICfgCellBtn*) view2;
                    [btns setTag:tag];
                    [btns addTarget:self action:@selector(doClickEvent:) forControlEvents:UIControlEventTouchUpInside];
                    i++;
                }
            }
        }
        return cellview;
    }
    
    if (currentType == Stores) {
        static NSString *cellId = @"statci_store_view";
        UITableViewCell *cellview = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cellview == nil) {
            cellview = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cellview.selectionStyle = UITableViewCellSelectionStyleNone;
            [cellview.contentView addSubview:[VIBaseViewController loadXibView:@"UI.xib" withTag:3000]];
            [cellview egoimageView4Tag:3001].placeholderImage = [@"no_pic.png" image];
            [cellview egoimageView4Tag:3002].placeholderImage = [@"no_pic.png" image];
            cellview.backgroundColor = [UIColor clearColor];
        }
        
        Store *left = [stores objectAtIndex:2 * indexPath.row];
        [cellview egoimageView4Tag:3001].imageURL = [NSURL URLWithString:left.Logo];
        [cellview viewWithTag:3100].backgroundColor = [UIColor whiteColor];
        
        Store  *right =  nil;
        if ((2 * indexPath.row + 1) < stores.count) {
            right = [stores objectAtIndex:(2 * indexPath.row + 1)];
            [cellview egoimageView4Tag:3002].imageURL = [NSURL URLWithString:right.Logo];
        }
        [cellview viewWithTag:3200].backgroundColor = right == nil ? [UIColor clearColor] : [UIColor whiteColor];
        [[cellview egoimageView4Tag:3002] setHidden:right==nil];
        int i = 0;
        for (UIView *view in [cellview.contentView subviews]) {
            for (UIView *view2 in [view subviews]) {
                if ([view2 isKindOfClass:[VICfgCellBtn class]]) {
                    long tag = indexPath.row * 10 + i;
                    VICfgCellBtn *btns =  (VICfgCellBtn*) view2;
                    [btns setTag:tag];
                    [btns addTarget:self action:@selector(doShowStore:) forControlEvents:UIControlEventTouchUpInside];
                    i++;
                }
            }
        }
        
        return cellview;
    }
    
    if (currentType == Suprises) {
        NSString *cellId = Fmt(@"CellId_%ld_%ld",(long)indexPath.section,(long)indexPath.row);
        VITimeDownCell *cellview = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cellview == nil) {
            cellview = [[VITimeDownCell alloc] initWithInfo:cellId];
        }
        MobiPromo *left     =   [suprises objectAtIndex:2 * indexPath.row];
        MobiPromo *right =  nil;
        
        if ((2 * indexPath.row + 1) < suprises.count) {
            right = [suprises objectAtIndex:(2 * indexPath.row + 1)];
        }
        
        [cellview repaintInfo:left rightinfo:right path:indexPath];
        
        [[cellview viewWithTag:200] removeFromSuperview];
        [[cellview viewWithTag:201] removeFromSuperview];
        
        UIButton *lf = [[UIButton alloc]initWithFrame:Frm(0, 0, self.view.w/2, cellview.h)];
        lf.tag = 200;
        [lf addTarget:self action:@selector(showInfoMessage:)];
        [cellview.contentView addSubview:lf];
        
        if(right!=nil){
            UIButton *rg = [[UIButton alloc]initWithFrame:Frm(self.view.w/2, 0, self.view.w/2, cellview.h)];
            rg.tag = 201;
            [rg addTarget:self action:@selector(showInfoMessage:)];
            [cellview.contentView addSubview:rg];
        }
        return cellview;
    }
    return nil;
}

- (void)doSupriseShow:(VICfgCellBtn *)clickBtn
{
//    long index = 2 * (clickBtn.tag / 10) + clickBtn.tag % 2;
//    if(index == supriseStores.count) {
//        return;
//    }
//    NSDictionary *pdata = [supriseStores objectAtIndex:index];
//    NSDictionary *mobi = [promIndex objectForKey:[pdata stringValueForKey:@"MobiPromoId"]];
//    NSMutableDictionary *mtc = [mobi mutableCopy];
//    [mtc setValue:pdata forKey:@"_extra_"];
//    [self pushTo:@"VIReedemViewController" data:mtc];
}

- (void)doClickEvent:(VICfgCellBtn *)clickBtn
{
    long index = 2 * (clickBtn.tag / 10) + clickBtn.tag % 2;
    if(index == deals.count)
        return;
    MobiPromo *pdata = [deals objectAtIndex:index];
    
    VIDealsDetailViewController *deal = [[VIDealsDetailViewController alloc] init];
    deal.mobipromo = pdata;
    [self push:deal];
    
}

- (void)doShowStore:(VICfgCellBtn *)clickBtn
{
    long index = 2 * (clickBtn.tag / 10) + clickBtn.tag % 2;
    if(index == stores.count)
        return;
    
    Store *pdata = [stores objectAtIndex:index];
    [self pushTo:@"VIStoreDetailViewController" data:[pdata toDictionary]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (currentType) {
        case Suprises:return  (int) ceilf(suprises.count / 2.0);
        case Stores: return   (int) ceilf(stores.count / 2.0);
        case Deals: return    (int) ceilf(deals.count / 2.0);
        default: return 0; break;
    }
}


@end
