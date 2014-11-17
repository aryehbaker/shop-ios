//
//  VIAroundMeViewController.m
//  Shoprize_EN
//
//  Created by ShawFung Chao on 10/27/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import "VIAroundMeViewController.h"
#import <Shoprize/KUtils.h>
#import <iSQLite/iSQLite.h>
#import <Shoprize/CMPopTipView.h>
#import <Shoprize/VIDealsDetailViewController.h>
#import "CategoryFilterViewController.h"
#import <VICore/VICore.h>
#import "VIMapIndexViewController.h"
#import "ASValuePopUpView.h"
#import "ASValueTrackingSlider.h"

@interface VIAroundMeViewController ()<ASValueTrackingSliderDataSource,ASValueTrackingSliderDelegate>
{
    VITableView *_tableView;
    NSMutableArray *deals;
    
    ASValueTrackingSlider *slider;
}

@end

@implementation VIAroundMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav:@"Aroud Me" left:MapIt right:MENU];
    
    [self.leftOne addTarget:self action:@selector(mapMe:)];
    
    deals = [NSMutableArray array];
    
    _tableView = [[VITableView alloc] initWithFrame:Frm(0, self.nav.endY, self.view.w, Space(self.nav.endY) - 40) style:UITableViewStylePlain];
    _tableView.delegate = _tableView;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.viewDelegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    UIView *filter = [[UIView alloc] initWithFrame:Frm(0, self.view.h-40, self.view.w, 40)];
    filter.backgroundColor = [@"#9B9B9B" hexColorAlpha:1];
    UIView *l = [[UIView alloc] initWithFrame:Frm(0, 0, filter.w, 1)];
    l.backgroundColor = [@"#727272" hexColorAlpha:1];
    [filter addSubview:l];
    
    UIButton *lter = [[UIButton alloc] initWithFrame:Frm(5,2, 60, 36)];
    [lter setImage:@"filter.png" selectd:@"filter.png"];
    [lter setImageEdgeInsets:UIEdgeInsetsMake(6,20, 6, 20)];
    [lter addTarget:self action:@selector(showFiler:)];
    lter.titleLabel.font = FontB(15);
    [filter addSubview:lter];
    
    slider = [[ASValueTrackingSlider alloc] initWithFrame:Frm(lter.endX+5, 0, filter.w-lter.endX-20, filter.h)];
    slider.popUpViewColor = [@"#FF1500" hexColor];
    slider.textColor = [@"#ffffff" hexColor];
    slider.font = FontB(15);
    slider.minimumValue = 1;
    slider.maximumValue = 30;
    slider.dataSource = self;
    slider.delegate = self;
    [slider setValue:2 animated:YES];
    
    [filter addSubview:slider];
    
    [self.view addSubview:filter];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filter_ed:) name:@"_filtered_" object:nil];
}
- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider
{
    
}
- (void)sliderDidHidePopUpView:(ASValueTrackingSlider *)slider
{
    if (isLoading) return;
    isLoading = YES;
    [deals removeAllObjects];
    [_tableView reloadAndHideLoadMore:YES];
    [self performSelector:@selector(preLoading) withObject:nil afterDelay:.5];
}

bool isLoading;
- (void)preLoading {
    [self loadData];
}

- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value
{
    return Fmt(@"%d mile",(int)ceil(value)) ;
}

static NSString *filervalue;
-(void)filter_ed:(NSNotification *)noti {
    filervalue = noti.object;
    if ([filervalue isEqualToString:@""]) {
        filervalue = @" '1' ";
    }
    [self loadData];
}

-(void)showFiler:(id)sender
{
    CategoryFilterViewController *ctrl = [[CategoryFilterViewController alloc] initWith:filervalue];
    [self presentModalViewController:ctrl];
}

-(void)mapMe:(id)sender
{
    VIMapIndexViewController *m = [[VIMapIndexViewController alloc] init];
    [self push:m];
}

- (void)loadMoreStarted:(VITableView *)t
{
    
}
- (void)pullDownRefrshStart:(VITableView *)t
{
    [self loadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return   (int) ceilf(deals.count / 2.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"statci_view2";
    UITableViewCell *cellview = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cellview == nil) {
        cellview = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cellview.selectionStyle = UITableViewCellSelectionStyleNone;
        [cellview.contentView addSubview:[VIBaseViewController loadXibView:@"UI.xib" withTag:1000]];
        cellview.backgroundColor = [UIColor clearColor];
        [cellview egoimageView4Tag:1001].placeholderImage = [@"no_pic.png" image];
        [cellview egoimageView4Tag:1101].placeholderImage = [@"no_pic.png" image];
    }
    
    MobiPromoAR *left =   [deals objectAtIndex:2 * indexPath.row];
    
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
    
    MobiPromoAR *right =  nil;
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
                btns.userInteractionEnabled = YES;
                [btns setTag:tag];
                [btns addTarget:self action:@selector(doClickEvent:)];
               i++;
           }
       }
    }
    return cellview;
}

-(void)loadDataNew:(id)sender
{
    filervalue = nil;
    [self loadData];
}

- (void)loadData {
    if (filervalue!=nil) {
        LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
        deals = [helper search:[MobiPromoAR class] where:Fmt(@"CategoryId in (%@)",filervalue) orderBy:@"CreateDate desc" offset:0 count:100000];
        [_tableView reloadAndHideLoadMore:YES];
        
    }else{
        int distance2 =  (int)ceil(slider.value);
        [VINet get:Fmt(@"/api/mobipromos/nearby?radius=%d",distance2) args:nil target:self succ:@selector(loadComplete:) error:@selector(loadCompleteFail:) inv:_tableView];
    }
}

-(void)loadComplete:(id)values{
    
    LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
    [helper deleteWithClass:[MobiPromoAR class] where:@"1 = 1"];
    
    for (NSDictionary *dct in values) {
        NSMutableDictionary *mtdct = [dct mutableCopy];
        
        NSArray *adds = [dct arrayValueForKey:@"Addresses"];
        if(adds.count > 0){
            [mtdct addEntriesFromDictionary:[adds objectAtIndex:0]];
        }
        MobiPromoAR *mob = [[MobiPromoAR alloc] initWithDictionary:mtdct error:nil];
        
        for (NSDictionary *p in [dct arrayValueForKey:@"Pictures"]) {
            Picture *sp = [[Picture alloc] initWithDictionary:p error:nil];
            sp.MobiPromoId = mob.MobiPromoId;
            [helper insertOrUpdateUsingObj:sp];
            
            if (mob.defPicture == nil) {
                mob.defPicture = sp.PictureUrl;
            }
        }
        [helper insertOrUpdateUsingObj:mob];
        
    }
    
    deals = [helper search:[MobiPromoAR class] where:@"" orderBy:@"CreateDate desc" offset:0 count:100000];
    [_tableView reloadAndHideLoadMore:YES];
    isLoading = NO;
}

-(void)loadCompleteFail:(id)values{
    isLoading = NO;
    [VIAlertView showErrorMsg:@"Load Error"];
}

- (void)showInfoMessage:(UIButton *)tap
{
    UIView *inms = [[UIView alloc] initWithFrame:Frm(0, 0, 200, 90)];
    UILabel *lab = [UILabel initManyLineWithFrame:Frm(15, 15, 170, 60) color:@"#000000" font:Bold(14) text:Lang(@"store_has_sup")];
    lab.textAlignment = CENTER;
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

-(CGFloat)heightAtRow:(NSIndexPath *)indexPath {
    return 222;
}

- (void)doClickEvent:(UIButton *)clickBtn
{
    long index = 2 * (clickBtn.tag / 10) + clickBtn.tag % 2;
    if(index == deals.count)
        return;
    MobiPromoAR *pdata = [deals objectAtIndex:index];
    
    VIDealsDetailViewController *deal = [[VIDealsDetailViewController alloc] init];
    deal.mobipromoar = pdata;
    [self push:deal];
    
}

@end
