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
#import "CategoryFilterViewController.h"
#import <VICore/VICore.h>
#import <Shoprize/VIDealsDetailViewController.h>
#import <Shoprize/Ext.h>

@interface VIFavViewController () {

    VITableView *_tableView;
    NSMutableArray *deals;
    UILabel *distance;
    
    int pageindex;
    
    long currentTag;
    
    NSMutableArray *wanted;
    NSMutableArray *redeemed;
}

@end

@implementation VIFavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav:Lang(@"menu_my_deal") left:BACK right:MENU];
    
    UIButton *left = [[UIButton alloc] initWithFrame:Frm(0, self.nav.endY, self.view.w/2, 34)];
    [left setTitle:Lang(@"deal_wanted") selected:Lang(@"deal_wanted")];
    left.titleLabel.font = Bold(16);
    left.tag = 100;
    [left setTitleColor:[@"#FFFFFF" hexColor] forState:UIControlStateNormal];
    [left setTitleColor:[@"#ff4747" hexColor] forState:UIControlStateSelected];
    [left addTarget:self action:@selector(changeTab:)];
    UIImageView *imgs = [@"suprise_check.png" imageViewForImgSizeAtX:10 Y:4];
    imgs.tag = 110;
    [left addSubview:imgs];
    
    [self.view addSubview:left];
    
    UIButton *right = [[UIButton alloc] initWithFrame:Frm(left.endX, self.nav.endY, self.view.w-left.endX, left.h)];
    [right setTitle:Lang(@"deal_redeem") selected:Lang(@"deal_redeem")];
    right.titleLabel.font =  Bold(16);
    right.tag = 101;
    [right setTitleColor:[@"#FFFFFF" hexColor] forState:UIControlStateNormal];
    [right setTitleColor:[@"#ff4747" hexColor] forState:UIControlStateSelected];
    [right addTarget:self action:@selector(changeTab:)];
    [self.view addSubview:right];
    imgs = [@"checked_right.png" imageViewForImgSizeAtX:10 Y:4];
    imgs.tag = 111;
    [right addSubview:imgs];
    
    deals = [NSMutableArray array];
    pageindex = 0;
    
    _tableView = [[VITableView alloc] initWithFrame:Frm(0, right.endY, self.view.w, Space(right.endY)) style:UITableViewStylePlain];
    _tableView.delegate = _tableView;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.viewDelegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    wanted = [NSMutableArray array];
    redeemed = [NSMutableArray array];
    
    [self changeTab:left];
}

-(void)changeTab:(UIButton *)sender
{
    [self.view button4Tag:100].selected = NO;
    [self.view button4Tag:100].backgroundColor = [@"#ff4747" hexColor];
    [self.view button4Tag:101].selected = NO;
    [self.view button4Tag:101].backgroundColor = [@"#ff4747" hexColor];
    
    [[self.view button4Tag:100] imageView4Tag:110].image = [@"checked_right.png" image];
    [[self.view button4Tag:101] imageView4Tag:111].image = [@"suprise_check.png" image];
    
    sender.selected = YES;
    sender.backgroundColor = [@"#ffffff" hexColor];
    
    [sender imageView4Tag:sender.tag+10].image = sender.tag == 100 ? [@"checked_right_check.png" image] :
    [@"suprise_check_chekc.png" image];
    [deals removeAllObjects];
    [_tableView reloadAndHideLoadMore:YES];
    
    currentTag = sender.tag;
    
    if (currentTag == 100 && wanted.count>0) {
        [deals addObjectsFromArray:wanted];
        [_tableView reloadAndHideLoadMore:YES];
        return;
    }
    if (currentTag == 101 && redeemed.count>0) {
        [deals addObjectsFromArray:redeemed];
        [_tableView reloadAndHideLoadMore:YES];
        return;
    }
    [self pullDownRefrshStart:_tableView];
}

- (void)loadMoreStarted:(VITableView *)t
{
    pageindex++;
    [self loadData];
}
- (void)pullDownRefrshStart:(VITableView *)t
{
    [deals removeAllObjects];
    if(currentTag == 100)
       [wanted removeAllObjects];
    if (currentTag == 101)
        [redeemed removeAllObjects];
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
    
    [[cellview button4Tag:1004] setHidden:currentTag == 101];
    
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
        [[cellview button4Tag:1104] setHidden:currentTag == 101];
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
    if (currentTag == 100 && wanted.count>0) {
        [wanted removeObjectAtIndex:last_selected_long];
    }else{
        [redeemed removeObjectAtIndex:last_selected_long];
    }
    [deals removeObjectAtIndex:last_selected_long];
    [_tableView reloadAndHideLoadMore:YES];
}

-(void)deleFail:(id)sender
{
    [VIAlertView showInfoMsg:sender];
}

- (void)loadData {
    if (currentTag == 101) {
        [VINet get:@"/api/mobipromos/redeemed" args:nil target:self succ:@selector(loadComplete:) error:@selector(loadCompleteFail:) inv:self.view];
    }else{
        [VINet get:Fmt(@"/api/mobipromos/marked?pageIndex=%d&pageSize=10",pageindex) args:nil target:self succ:@selector(loadComplete:) error:@selector(loadCompleteFail:) inv:self.view];
    }
}

-(void)loadComplete:(id)values{
    NSMutableArray *filter =  [Ext doEach:values with:^id(id itm) {
        if ([[itm stringValueForKey:@"Type"] isEqualToString:@"Deal"])
            return itm;
        return nil;
    }];
   [deals addObjectsFromArray:filter];
   
    if (currentTag == 100) {
        [wanted removeAllObjects];
        [wanted addObjectsFromArray:deals];
    }
    if (currentTag == 101) {
        [redeemed removeAllObjects];
        [redeemed addObjectsFromArray:deals];
    }
    
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

    if(currentTag == 100){
        VIDealsDetailViewController *deal = [[VIDealsDetailViewController alloc] init];
        deal.dealid = [pdata stringValueForKey:@"MobiPromoId"];
        deal.showRedeem = YES;
        [self push:deal];
    }else{
        [self pushTo:@"VIReedemViewController" data:respval];
    }


}


@end
