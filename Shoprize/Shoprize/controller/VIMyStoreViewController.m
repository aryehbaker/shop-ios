//
//  VIMyStoreViewController.m
//  Shoprose
//
//  Created by vnidev on 5/26/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "VIMyStoreViewController.h"
#import <VICore/VICore.h>
#import "CMPopTipView.h"
#import "KUtils.h"

@interface VIMyStoreViewController ()
{
    VITableView *tabview;
    NSMutableArray *storeData;

    UIView *disp;
    
    NSInteger currentPage;
    NSString *searchKey;
}

@end

@implementation VIMyStoreViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    currentPage = 0;
    [self loadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNav:Lang(@"nav_my_store") left:SEARCH right:MENU];

    disp  = [[UIView alloc] initWithFrame:Frm(0, self.nav.endY, self.view.w, 220)];
    UIImageView *imageSto = [@"mystore_icon.png" imageViewForImgSizeAtX:0 Y:0];
    [disp addSubview:imageSto];
    UILabel *tjh = [VILabel createLableWithFrame:Frm(10, imageSto.endY+20, 300, 100) color:@"#8D8D8D" font:[Fonts PekanBold:18] align:CENTER];
    tjh.numberOfLines = 10;
    tjh.text = Lang(@"empty_store_list");
    [disp addSubview:tjh];
 
    [self.view addSubview:disp];

    tabview = [[VITableView alloc] initWithFrame:Frm(0, self.nav.endY, self.view.w,self.view.h -self.nav.endY-105) style:UITableViewStylePlain];
    tabview.delegate = tabview;
    tabview.viewDelegate = self;
    tabview.backgroundColor = [UIColor clearColor];
    tabview.dataSource = self;
    [self.view addSubview:tabview];
    [tabview setHidden:YES];

    if ([tabview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tabview setSeparatorInset:UIEdgeInsetsZero];
    }

    UILabel *tipText = [VILabel createLableWithFrame:Frm(0, tabview.endY+10, self.view.w, 20) color:@"#FC494D" font:Bold(16) align:CENTER];
    tipText.text = Lang(@"why_should_i_add");
    tipText.userInteractionEnabled = YES;
    [tipText addTapTarget:self action:@selector(showTip:)];
    [self.view addSubview:tipText];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = Frm(25, self.view.h - 60, 270, 51);
    [btn setBackgroundImage:[@"add_store_btn.png" image] forState:UIControlStateNormal];
    [btn setTitle:Lang(@"add_store") forState:UIControlStateNormal];
    [btn setTitleColor:[@"#464646" hexColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotochoose:)];
    btn.titleLabel.font = Bold(22);
    [self.view addSubview:btn];
    
    
    currentPage = 0;
    storeData = [NSMutableArray array];
    [self loadData];

}

-(void)loadData
{
    NSString *query = Fmt(@"pageindex=%ld&pagesize=10&saved=ture&searchkey=%@",(long)currentPage,searchKey==nil?@"":[searchKey uriEncode]);
    [VINet get:Fmt(@"/api/stores/all?%@",query) args:nil target:self succ:@selector(loadComplet:) error:@selector(loadComplet2:) inv: (storeData.count == 0 && searchKey ==nil) ? self.view : nil];
}


-(void)loadComplet:(NSDictionary *)value
{
    NSArray *respAry = [value arrayValueForKey:@"Stores"];
    if (respAry.count != 0) {
        [disp removeFromSuperview];
        [tabview setHidden:NO];
    }
    if (currentPage == 0) {
        [storeData removeAllObjects];
    }
    [storeData addObjectsFromArray:[value arrayValueForKey:@"Stores"]];
    [tabview reloadAndHideLoadMore:[value intValueForKey:@"Count"]-1<=currentPage];
}

-(void)loadComplet2:(NSDictionary *)resp2{
    
}

- (void)loadMoreStarted:(VITableView *)t
{
    currentPage++;
    [self loadData];
}

- (void)pullDownRefrshStart:(VITableView *)t
{
    currentPage = 0;
    [self loadData];
    
}

- (CGFloat)heightAtRow:(NSIndexPath *)indexPath
{
    return 115;
}

- (NSString *)titleForDeleteBtn:(NSIndexPath *)indexPath
{
    return Lang(@"del_btn");
}
/**
 * 编辑列表的样式
 */
- (UITableViewCellEditingStyle)editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

static NSIndexPath *selected;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        selected = indexPath;
        NSDictionary *mt = [storeData objectAtIndex:indexPath.row];
        NSString *api = Fmt(@"/api/stores/%@/unmark",[mt stringValueForKey:@"StoreId"]);
        [VINet post:api args:nil target:self succ:@selector(deleteComlt:) error:@selector(showAlertError:) inv:self.view];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)deleteComlt:(id)value
{
    [storeData removeObjectAtIndex:selected.row];
    [tabview deleteRowsAtIndexPaths:[NSArray arrayWithObject:selected] withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)gotochoose:(UIButton *)btn
{
    [self push:@"VIAddStroeViewController" isNib:NO];
}

- (void)showTip:(UITapGestureRecognizer *)gen
{
    UIView *contentView = [[UIView alloc] initWithFrame:Frm(0, 0, 270, 0)];
    UILabel *title = [VILabel createLableWithFrame:Frm(15, 20, 240, 25) color:@"#1C1C1C" font:Black(18) align:RIGHT];
    title.text = Lang(@"why_should_add_title");
    title.textAlignment = Align;
    [contentView addSubview:title];
    
    NSString *tx = Lang(@"why_should_add_ctnt");
    UILabel  *ctx = [VILabel createManyLines:Frm(15, title.endY+6, 240, 0) color:@"#323232" ft:Regular(15) text:tx];
    ctx.textAlignment = Align;
    ctx.text = tx;
    [ctx autoHeight];
    [contentView addSubview:ctx];
    
    [contentView setH:ctx.endY+15];
    
    CMPopTipView *tip = [[CMPopTipView alloc] initWithCustomView:contentView];
    [tip presentPointingAtView:gen.view inView:self.view animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return storeData.count;
}

-(void)whenSearchKey:(NSString *)search
{
    searchKey = search;
    currentPage = 0;
    [self loadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"mycell_id_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *value = [storeData objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        VIEGOImageView *imageview = [[VIEGOImageView alloc] initWithFrame:Frm(20, 5, self.view.w-40, 80) placeImg:[@"no_pic.png" image] url:[value stringValueForKey:@"Logo"]];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.tag = 200;
        [cell.contentView addSubview:imageview];
        UILabel *sname = [VILabel createLableWithFrame:Frm(0, imageview.endY+8,self.view.w, 20) color:@"#FF4F4F" font:FontS(15) align:CENTER];
        sname.tag = 201;
        [cell.contentView addSubview:sname];
    }
    [cell.contentView label4Tag:201].text = [value stringValueForKey:@"Name"];
    [cell.contentView egoimageView4Tag:200].imageURL = [NSURL URLWithString:[value stringValueForKey:@"Logo"]];
  
    return cell;
}

- (void)rowSelectedAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *pdata = [[storeData objectAtIndex:indexPath.row] mutableCopy];
    [pdata setValue:@"demo" forKey:@"MallAddress"];
    [pdata setValue:[pdata stringValueForKey:@"StoreId"] forKey:@"AddressId"];
    
    //[self pushTo:@"VIStoreDetailViewController" data:pdata];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
