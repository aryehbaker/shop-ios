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
#import <Shoprize/VIDealsDetailViewController.h>

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
    pageindex = 0;
    
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
    pageindex = 0;
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
    cellview.contentView.tag = indexPath.row;
    
    NSDictionary *left =   [deals objectAtIndex:2 * indexPath.row];
    NSString *image = [left stringValueForKey:@"MobiPromoPictures/0/PictureUrl" defaultValue:@""];
    [cellview egoimageView4Tag:1001].imageURL = [NSURL URLWithString:[left stringValueForKey:@"StoreLogo"]];
    
    [cellview egoimageView4Tag:1002].imageURL = [NSURL URLWithString:image];
    [cellview label4Tag:1003].text = [[left stringValueForKey:@"Offer"] killQute];
    [[cellview label4Tag:1003] setRTL];
    [cellview label4Tag:1003].font = Bold(13);
    
    [[cellview button4Tag:1004] setImage:@"close_btn.png" selectd:@"close_btn.png"];
    [[cellview button4Tag:1004] addTarget:self action:@selector(deleme:)];
    
    [[cellview viewWithTag:1104] setHidden:YES];
    NSDictionary *right =  nil;
    if ((2 * indexPath.row + 1) < deals.count) {
        right = [deals objectAtIndex:(2 * indexPath.row + 1)];
        NSString *rimg = [right stringValueForKey:@"MobiPromoPictures/0/PictureUrl" defaultValue:@""];
        [cellview egoimageView4Tag:1101].imageURL = [NSURL URLWithString:rimg];
        [cellview egoimageView4Tag:1102].imageURL = [NSURL URLWithString: [right stringValueForKey:@"StoreLogo"]];
        [cellview label4Tag:1103].text = [[right stringValueForKey:@"Offer"] killQute];
        [[cellview label4Tag:1103] setRTL];
        [cellview label4Tag:1103].font = Bold(13);
        
        [[cellview button4Tag:1104] setImage:@"close_btn.png" selectd:@"close_btn.png"];
        [[cellview button4Tag:1104] addTarget:self action:@selector(deleme:)];
        [[cellview viewWithTag:1104] setHidden:NO];
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

static long last_selected_long;
-(void)deleme:(UIButton *)btn
{
    UIView *root = btn;
    while (root.superview.tag != 1000) {
        root = root.superview;
    }
    root = root.superview.superview;
    long newTag = root.tag;
    if (btn.tag == 1104) {
        newTag+=1;
    }
    last_selected_long = newTag;
    NSDictionary *pdata = [deals objectAtIndex:newTag];
    [self showConfirmWithTitle:@"" msg:@"Are you sure delete ?" callbk:^(BOOL isOk) {
        if (isOk) {
             [VINet post:Fmt(@"/api/mobipromos/%@/unmark",[pdata stringValueForKey:@"MobiPromoId"]) args:nil target:self succ:@selector(deleCom:) error:@selector(deleFail:) inv:self.view];
        }
    }];
}

-(void)deleCom:(id)sender
{
    [deals removeObjectAtIndex:last_selected_long];
    [_tableView reloadAndHideLoadMore:YES];
}

-(void)deleFail:(id)sender
{
    [VIAlertView showInfoMsg:sender];
}

- (void)loadData {
  [VINet get:Fmt(@"/api/mobipromos/marked?pageIndex=%d&pageSize=10",pageindex) args:nil target:self succ:@selector(loadComplete:) error:@selector(loadCompleteFail:) inv:self.view];
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
     NSDictionary *pdata = [deals objectAtIndex:index];
     NSMutableDictionary *respval = [pdata mutableCopy];
     [respval setValue:@"RESPDEAL" forKey:@"resptype"];
     [self pushTo:@"VIReedemViewController" data:respval];

}


@end
