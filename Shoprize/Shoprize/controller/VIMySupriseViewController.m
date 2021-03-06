//
//  VIMySupriseViewController.m
//  Shoprose
//
//  Created by vnidev on 5/29/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "VIMySupriseViewController.h"
#import "KUtils.h"
#import "VISurpriseTimeDown.h"

typedef NS_ENUM(NSInteger, Tabs) { USED,ACT};

@interface VIMySupriseViewController ()
{
    NSMutableArray *usedSuprise;
    NSMutableArray *validSuprise;
    
    UITableView *all;
    
    Tabs currentTab;
}

@end

@implementation VIMySupriseViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshData];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCame:) name:@"_Refresh_My_Surprise" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    currentTab = ACT;
    
    [self addNav:Lang(@"my_suprise") left:SEARCH right:MENU];
    
    CGRect leftFm  = Frm(0, self.nav.endY, self.view.w/2, 34);
    CGRect rightFm = Frm(leftFm.origin.x+leftFm.size.width, self.nav.endY, leftFm.size.width, leftFm.size.height);
    
    UIButton *left = [[UIButton alloc] init];
    [left setFrame:leftFm];
    [left setTitle:Lang(@"menu_exp_exp") selected:Lang(@"menu_exp_exp")];
    left.titleLabel.font = isEn ? Bold(13) : Bold(16);
    left.tag = 100;
    left.backgroundColor = [@"#ff4747" hexColor];
    [left setTitleColor:[@"#FFFFFF" hexColor] forState:UIControlStateNormal];
    [left setTitleColor:[@"#ff4747" hexColor] forState:UIControlStateSelected];
    [left addTarget:self action:@selector(changeTab:)];
    [left setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    UIImageView *imgs = [@"checked_right.png" imageViewForImgSizeAtX:left.w-30 Y:4];
    imgs.tag = 110;
    [left addSubview:imgs];
    [self.view addSubview:left];
    if (isEn) {
        [imgs setX:5];
        [left setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
        [left setFrame:rightFm];
    }
    
    UIButton *right = [[UIButton alloc] init];
    [right setFrame:rightFm];
    [right setTitle:Lang(@"menu_sprise_active") selected:Lang(@"menu_sprise_active")];
    right.titleLabel.font = Bold(16);
    right.tag = 101;
    right.backgroundColor = [@"#ff4747" hexColor];
    [right setTitleColor:[@"#FFFFFF" hexColor] forState:UIControlStateNormal];
    [right setTitleColor:[@"#ff4747" hexColor] forState:UIControlStateSelected];
    [right addTarget:self action:@selector(changeTab:)];
    [self.view addSubview:right];
    
    imgs = [@"suprise_check.png" imageViewForImgSizeAtX:left.w-35 Y:4];
    imgs.tag = 111;
    [right addSubview:imgs];
    if (isEn) {
        [imgs setX:5];
        [right setFrame:leftFm];
    }
    all = [[UITableView alloc] initWithFrame:Frm(0, right.endY, self.view.w, self.view.h-right.endY)];
    all.delegate = self;
    all.dataSource = self;
    all.separatorStyle = UITableViewCellSeparatorStyleNone;
    all.backgroundColor = [UIColor clearColor];
    [self.view addSubview:all];
    
    [self refreshData];
    
    if (isEn) {
         [self changeTab:left];
    }else{
        [self changeTab:right];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"_Refresh_My_Surprise" object:nil];
}

-(void)notifyCame:(NSNotification *)noti
{
    [self refreshData];
}

- (void)refreshData
{
    NSString *valid = Fmt(@"select m.* from MobiPromo m where exists (select * from UserSurprise u where u.Redeemed = 0 and u.ExpireTime > datetime('now','localtime') and u.MobiPromoId=m.MobiPromoId)");
    
    NSString *passd = Fmt(@"select m.* from MobiPromo m where m.MobiPromoId in (select u.MobiPromoId from UserSurprise u where u.Redeemed = 1 or u.ExpireTime < datetime('now','localtime'))");
    
    LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
    validSuprise  = [helper  searchWithSQL:valid toClass:[MobiPromo class]];
    usedSuprise   = [helper  searchWithSQL:passd toClass:[MobiPromo class]];

    [all reloadData];
}

- (void)changeTab:(UIButton *)btn
{
    NSArray *def = @[
                     @[@"checked_right.png",@"checked_right_check.png"],
                     @[@"suprise_check.png",@"suprise_check_chekc.png"],
                     @[@"ic_action_timer_white.png",@"ic_action_timer_red.png"]
                   ];
 
    for (int i =0 ; i<3; i++) {
        [self.view button4Tag:100+i].selected = NO;
        [self.view button4Tag:100+i].backgroundColor = [@"#ff4747" hexColor];
        [[self.view button4Tag:100+i] imageView4Tag:100+i+10].image = [[[def objectAtIndex:i] objectAtIndex:0] image];
    }
    
    btn.selected = YES;
    int value = 0;
    switch (btn.tag) {
        case 100:
            currentTab = USED,value = 0;
            break;
        case 101 :
            currentTab = ACT,value = 1;
            break;
        default:
            break;
    }
    
    btn.backgroundColor = [@"#FFFFFF" hexColor];
    [[self.view button4Tag:100+value] imageView4Tag:100+value+10].image =
            [[[def objectAtIndex:value] objectAtIndex:1] image];
    [[self.view viewWithTag:10000] removeFromSuperview];
    
    if (currentTab == USED && usedSuprise.count == 0){
        [all setHidden:YES];
        [self addEmpty:Lang(@"empty_suprise_redeem")];
    }else{
        [all setHidden:NO];
    }

    if(currentTab == ACT && validSuprise.count == 0) {
        [all setHidden:NO];
        [self addEmpty:Lang(@"empty_suprise_active")];
    }else{
        [all setHidden:NO];
    }
    
    [all reloadData];
}

-(void)addEmpty:(NSString *)text
{
    UIView *view = [[UIView alloc]  initWithFrame:all.frame];
    view.tag = 10000;
    VIRTLabel *lable = [[VIRTLabel alloc] initWithFrame:Frm(10, 10, view.w-20, 0)];
    [lable setText:text];
    [lable setTextAlignment:RTTextAlignmentCenter];
    [lable setTextColor:[@"#898989" hexColor]];
    [lable setH:lable.optimumSize.height];
    [view addSubview:lable];
    UIImageView *icon = [@"ic_surprises_large_gray.png" imageView];
    [icon setX:(view.w-icon.w)/2];
    [icon setY:lable.endY+10];
    [view addSubview:icon];
    [self.view addSubview:view];
}

- (void)whenSearchKey:(NSString *)search
{
    if (currentTab == USED && (search !=nil && ![search isEqualToString:@""]))
    {
        NSString *passd = Fmt(@"select m.* from MobiPromo m where (m.Offer like '%%%@%%' or Description like '%%%@%%' or StoreName like '%%%@%%' ) and  m.MobiPromoId in (select u.MobiPromoId from UserSurprise u where u.Redeemed = 1 or u.ExpireTime < datetime('now','localtime'))",search,search,search);
        LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
        usedSuprise  = [helper  searchWithSQL:passd toClass:[MobiPromo class]];
        [all reloadData];
        return;
    }
    
    if (currentTab == ACT && (search !=nil && ![search isEqualToString:@""])) {
        NSString *valid = Fmt(@"select m.* from MobiPromo m where (m.Offer like '%%%@%%' or Description like '%%%@%%' or StoreName like '%%%@%%' )  and exists (select * from UserSurprise u where u.Redeemed = 0 and u.ExpireTime > datetime('now','localtime') and u.MobiPromoId=m.MobiPromoId)",search,search,search);
        
        LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
        validSuprise  = [helper  searchWithSQL:valid toClass:[MobiPromo class]];
        [all reloadData];
        
        return;
    }

    [self refreshData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  123;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentTab == USED) {
        int noofz = (int)ceilf(usedSuprise.count/2.0) ;
        if (noofz==0) {
            [tableView setHidden:YES];
            [[self.view viewWithTag:-100] setHidden:NO];
        }else{
            [tableView setHidden:NO];
            [[self.view viewWithTag:-100] setHidden:YES];
        }
        return noofz;
    }else{
        int noofz = (int)ceilf(validSuprise.count/2.0) ;
        if (noofz==0) {
            [tableView setHidden:YES];
            [[self.view viewWithTag:-100] setHidden:NO];
        }else{
            [tableView setHidden:NO];
            [[self.view viewWithTag:-100] setHidden:YES];
            
        }
        return noofz;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"statci_view";
    VISurpriseTimeDown *cellview = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cellview == nil) {
        cellview = [[VISurpriseTimeDown alloc] initWithInfo:cellId];
        cellview.selectionStyle = UITableViewCellSelectionStyleNone;
        cellview.backgroundColor = [UIColor clearColor];
    }
    id supriese;
    switch (currentTab) {
        case ACT:
            supriese = validSuprise;
            break;
        case USED:
            supriese = usedSuprise;
            break;
        default:
            break;
    }
    
    MobiPromo *left1 =   [supriese objectAtIndex:2 * indexPath.row];
    
    NSMutableDictionary *left = [[left1 toDictionary] mutableCopy];
    
    NSMutableDictionary *right = nil;
    if ((2 * indexPath.row + 1) < [supriese count]) {
        MobiPromo *right1 = [supriese objectAtIndex:(2 * indexPath.row + 1)];
        right = [[right1 toDictionary] mutableCopy];
    }
    
    [cellview repaintInfo:left rightinfo:right path:indexPath redeem:currentTab==USED];
    
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

- (void)doClickEvent:(UIButton *)sender
{
    long index = 2 * (sender.tag / 10) + sender.tag % 2;
    
    if (currentTab==USED && index == usedSuprise.count) {
         return;
    }
    if (currentTab==ACT && index == validSuprise.count) {
        return;
    }
    id supriese;
    switch (currentTab) {
        case ACT:
            supriese = validSuprise;
            break;
        case USED:
            supriese = usedSuprise;
            break;
        default:
            break;
    }
    
    MobiPromo *pdata = [supriese objectAtIndex:index];
    [self pushTo:@"VIReedemViewController" data:[pdata toDictionary]];
}


@end
