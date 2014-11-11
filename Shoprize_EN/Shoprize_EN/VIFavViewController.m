//
//  VIAroundMeViewController.m
//  Shoprize_EN
//
//  Created by ShawFung Chao on 10/27/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import "VIFavViewController.h"
#import <Shoprize/KUtils.h>
#import <iSQLite/iSQLite.h>
#import <Shoprize/CMPopTipView.h>
#import "VIMapViewController.h"
#import "CategoryFilterViewController.h"
#import <VICore/VICore.h>

@interface VIFavViewController ()
{
    VITableView *_tableView;
    NSMutableArray *deals;
    UILabel *distance;
    
    int pageindex;
}

@end

@implementation VIFavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav:Lang(@"menu_my_fav") left:BACK right:NONE];
    
    deals = [NSMutableArray array];
    pageindex = 1;
    
    _tableView = [[VITableView alloc] initWithFrame:Frm(0, self.nav.endY, self.view.w, Space(self.nav.endY)) style:UITableViewStylePlain];
    _tableView.delegate = _tableView;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.viewDelegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [self loadData];

}

- (void)loadMoreStarted:(VITableView *)t
{
    pageindex++;
    [self loadData];
}
- (void)pullDownRefrshStart:(VITableView *)t
{
    [deals removeAllObjects];
    pageindex = 1;
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


- (void)loadData {
  NSString *now = [[NSDate date] formatDefalut];
  [VINet get:Fmt(@"/api/mobipromos/marked?from=1970-01-01&to=%@&pageIndex=%d&pageSize=10",now,pageindex) args:nil target:self succ:@selector(loadComplete:) error:@selector(loadCompleteFail:) inv:self.view];
}

-(void)loadComplete:(id)values{
    [deals addObjectsFromArray:values];
    [_tableView reloadAndHideLoadMore:YES];
}

-(void)loadCompleteFail:(id)values{
    [VIAlertView showErrorMsg:@"Load Error"];
    [_tableView reloadAndHideLoadMore:YES];
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
    
    [self pushTo:@"VIDealsDetailViewController" data:[pdata toDictionary]];
}

@end
