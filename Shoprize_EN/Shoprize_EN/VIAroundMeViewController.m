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
#import "VIMapViewController.h"
#import "CategoryFilterViewController.h"
#import "CategoryFilterViewController.h"
#import <VICore/VICore.h>

@interface VIAroundMeViewController ()
{
    VITableView *_tableView;
    NSMutableArray *deals;
    UILabel *distance;
}

@end

@implementation VIAroundMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav:@"Aroud Me" left:BACK right:MapIt];
    [self.rightOne addTarget:self action:@selector(mapMe:)];
    
    _tableView = [[VITableView alloc] initWithFrame:Frm(0, self.nav.endY, 320, Space(self.nav.endY) - 35) style:UITableViewStylePlain];
    _tableView.delegate = _tableView;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.viewDelegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    UIView *filter = [[UIView alloc] initWithFrame:Frm(0, self.view.h-35, self.view.w, 35)];
    filter.backgroundColor = [@"#9B9B9B" hexColorAlpha:1];
    UIView *l = [[UIView alloc] initWithFrame:Frm(0, 0, filter.w, 1)];
    l.backgroundColor = [@"#727272" hexColorAlpha:1];
    [filter addSubview:l];
    
    UIButton *lter = [[UIButton alloc] initWithFrame:Frm(0, 2, 80, 31)];
    [lter setTitle:@"Filter" selected:@"Filter"];
    [lter addTarget:self action:@selector(showFiler:)];
    lter.titleLabel.font = FontB(15);
    [filter addSubview:lter];
    
    UIButton *plus = [[UIButton alloc] initWithFrame:Frm(filter.w-40, 3, 28, 28)];
    plus.tag = 1;
    [plus addTarget:self action:@selector(doPlus:)];
    [plus setTitle:@"+" selected:@"+"];
    [filter addSubview:plus];
    
    distance = [[UILabel alloc] initWithFrame:Frm(plus.x-55, 2, 50, 30)];
    [distance setFont:FontS(14)];
    [distance setTextAlignment:NSTextAlignmentCenter];
    [distance setText:@"2mile"];
    [distance setTextColor:[UIColor whiteColor]];
    [filter addSubview:distance];
    
    UIButton *mins = [[UIButton alloc] initWithFrame:Frm(distance.x-35, 3, 28, 28)];
    [mins setTitle:@"-" selected:@"-"];
    [filter addSubview:mins];
    mins.tag = -1;
    [mins addTarget:self action:@selector(doPlus:)];
    
    [self.view addSubview:filter];
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filter_ed:) name:@"_filtered_" object:nil];
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
    if (deals.count == 0) {
        return;
    }
    VIMapViewController *m = [[VIMapViewController alloc] init];
    m.deals = deals;
    [self push:m];
}

-(void)doPlus:(UIButton *)sender
{
    int value = [distance.text integerValue];
    int mile = value+sender.tag;
    if (mile <= 0) {
        mile = 1;
    }
    [distance setText:Fmt(@"%dmile",mile)];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    MobiPromoExt *left =   [deals objectAtIndex:2 * indexPath.row];
    
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
    
    MobiPromoExt *right =  nil;
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
    
    [[iSQLiteHelper getDefaultHelper] executeDB:^(FMDatabase *db) {
       NSString *filter = filervalue == nil ? @"" : Fmt(@" and t.CategoryId in(%@)",filervalue);
       FMResultSet *set2 = [db executeQuery:Fmt(@"select t.*,s.Lat,s.Lon,s.Lon from MobiPromo t inner join Store s on t.Type = 'Deal' and t.AddressId =s.AddressId %@",filter)];
        deals = [NSMutableArray array];
        int distance2 = [[distance text] intValue];
        
        while ([set2 next]) {
            NSDictionary *dct = [set2 resultDictionary];
            MobiPromoExt *ext = [[MobiPromoExt alloc] initWithDictionary:dct error:nil];
            double dis = ([VINet distanceTo:ext.Lat lon:ext.Lon] / 1000) * 0.621;//km to m
            if (dis < distance2) {
                [deals addObject:ext];
            }
        }
        [_tableView reloadAndHideLoadMore:YES];
    }];
    
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

-(CGFloat)heightAtRow:(NSIndexPath *)indexPath
{
    return 222;
}

- (void)doClickEvent:(UIButton *)clickBtn
{
    long index = 2 * (clickBtn.tag / 10) + clickBtn.tag % 2;
    if(index == deals.count)
        return;
    MobiPromo *pdata = [deals objectAtIndex:index];
    
    [self pushTo:@"VIDealsDetailViewController" data:[pdata toDictionary]];
}

@end
