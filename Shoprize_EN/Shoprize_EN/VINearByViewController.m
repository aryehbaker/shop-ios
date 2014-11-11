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

@interface VINearByViewController ()
{
    VITableView *_tableView;
    NSMutableArray *deals;
    NSMutableArray *allStore;
}

@end

@implementation VINearByViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    deals = [NSMutableArray array];
    
    [self addNav:@"" left:Around right:MENU];
    
    [self.leftOne addTarget:self action:@selector(showAroundMe:)];
    [self.nav_title addTapTarget:self action:@selector(showOpenHour:)];
    
    _tableView = [[VITableView alloc] initWithFrame:Frm(0, self.nav.endY, self.view.w, Space(self.nav.endY)) style:UITableViewStylePlain];
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
    
    NSDictionary *mallSaved = [[NSUserDefaults getValue:_USER_SELECTED_MALL_INFO] jsonVal];
    MallInfo *selectedOne = [[MallInfo alloc] initWithDictionary:mallSaved error:nil];
    if (selectedOne == nil) {
        [VINet get:@"/api/malls/nearby?radius=0" args:nil target:self succ:@selector(getMalls:) error:@selector(getMallsFail:) inv: deals.count> 0 ? nil : self.view];
    }else{
        //恢复回原来的值
        ((VIAppDelegate *)[UIApplication sharedApplication].delegate).currentMall = selectedOne;
        [VINet get:@"/api/malls/nearby?radius=0" args:nil target:self succ:@selector(rebulidMall:) error:@selector(getMallsFail:) inv:nil];
    
        self.nav_title.text = selectedOne.Name;
        [self refreshToShowTheTable];
    }
}

- (void)showAroundMe:(id)sender{
    [self pushTo:@"VIAroundMeViewController"];
}

- (void)refreshToShowTheTable
{
    LKDBHelper *helper  = [iSQLiteHelper getDefaultHelper];
    deals    =  [helper searchModels:[MobiPromo class] where:@"Type = 'Deal'"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_ibeancon_reset_" object:nil];
    [self changeType];
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
    [[NSUserDefaults standardUserDefaults] setValue:[notifyObj jsonString] forKey:_USER_SELECTED_MALL_INFO];
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
    
    [Mall clearRelateData];//清除当前的数据
    [_tableView reloadData];
    
    MallInfo *currentMall = ((VIAppDelegate *)[UIApplication sharedApplication].delegate).currentMall;
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
    [[iSQLiteHelper getDefaultHelper] insertOrUpdateDB:[MallInfo class] values:values];
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
        [NSUserDefaults setValue:[nearest toJSONString] forKey:_USER_SELECTED_MALL_INFO];
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
    [self notifyChange:self.view];
}

//显示当前的Deal
- (void)changeType
{
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = nil;
    [_tableView reloadAndHideLoadMore:YES];
}

-(CGFloat)heightAtRow:(NSIndexPath *)indexPath{
    return  222;
}

- (void)showInfoMessage:(UIButton *)tap
{
    UIView *inms = [[UIView alloc] initWithFrame:Frm(0, 0, 200, 90)];
    UILabel *lab = [VILabel createLableWithFrame:Frm(15, 15, 170, 60) color:@"#000000" font:Bold(14) align:CENTER];
    lab.text = Lang(@"store_has_sup");
    lab.numberOfLines = 0;
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
  
}

- (void)rowSelectedAtIndexPath:(NSIndexPath *)indexPath{
//    if (typeview == Stores) {
//       
//    }
//    [self doClickEvent:nil];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    [self pushTo:@"VIDealsDetailViewController" data:[pdata toDictionary]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return   (int) ceilf(deals.count / 2.0);
}


@end
