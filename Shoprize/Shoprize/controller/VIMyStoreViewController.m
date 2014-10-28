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
    UITableView *tabview;
    NSMutableArray *displayData;
    UIView *disp;
}

@end

@implementation VIMyStoreViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    displayData = [self alltea];
   
    if (tabview) {
        if (displayData.count>0) {
            [disp removeFromSuperview];
            [self.view addSubview:tabview];
        }else{
            [tabview removeFromSuperview];
            [self.view addSubview:disp];
        }
        [tabview reloadData];
    }
}

- (NSMutableArray *)alltea {
    return [[iSQLiteHelper getDefaultHelper] searchModels:[Store class] where:@"IsMarked=1"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    displayData = [NSMutableArray array];
    
    [self addNav:Lang(@"nav_my_store") left:SEARCH right:MENU];

    disp  = [[UIView alloc] initWithFrame:Frm(0, self.nav.endY, 320, 220)];
    UIImageView *imageSto = [@"mystore_icon.png" imageViewForImgSizeAtX:0 Y:0];
    [disp addSubview:imageSto];
    UILabel *tjh = [VILabel createLableWithFrame:Frm(10, imageSto.endY+20, 300, 100) color:@"#8D8D8D" font:FontS(18) align:CENTER];
    tjh.numberOfLines = 10;
    tjh.text = Lang(@"empty_store_list");
    [disp addSubview:tjh];
 
    [self.view addSubview:disp];

    tabview = [[UITableView alloc] initWithFrame:Frm(0, self.nav.endY, 320,self.view.h -self.nav.endY-105) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.backgroundColor = [UIColor clearColor];
    tabview.dataSource = self;
    [self.view addSubview:tabview];
    
    if ([tabview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tabview setSeparatorInset:UIEdgeInsetsZero];
    }

    //TODO need Delete
    for (UIView *v in [tabview subviews]) {
        if (v.h == 65) { [v setHidden:YES];}
    }
    
    UILabel *tipText = [VILabel createLableWithFrame:Frm(0, tabview.endY+10, 320, 20) color:@"#FC494D" font:Bold(16) align:CENTER];
    tipText.text = Lang(@"why_should_i_add");
    tipText.userInteractionEnabled = YES;
    [tipText addTapTarget:self action:@selector(showTip:)];
    [self.view addSubview:tipText];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = Frm(25, self.view.h - 60, 270, 51);
    [btn setBackgroundImage:[@"add_store_btn.png" image] forState:UIControlStateNormal];
    [btn setTitle:Lang(@"add_store") forState:UIControlStateNormal];
    [btn setTitleColor:@"#464646" hightColor:@"#464646"];
    [btn addTarget:self action:@selector(gotochoose:)];
    btn.titleLabel.font = Bold(22);
    [self.view addSubview:btn];
    
    if (displayData.count>0) {
        [disp removeFromSuperview];
        [self.view addSubview:tabview];
    }else{
        [tabview removeFromSuperview];
        [self.view addSubview:disp];
    }
}
static NSIndexPath *selected;
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        selected = indexPath;
        Store *mt = [displayData objectAtIndex:indexPath.row];
        NSString *api = Fmt(@"/api/stores/%@/unmark",[mt StoreId]);
        [VINet post:api args:nil target:self succ:@selector(deleteComlt:) error:@selector(showAlertError:) inv:self.view];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)deleteComlt:(id)value
{
    Store *mt = [displayData objectAtIndex:selected.row];
    [mt setIsMarked:NO];
    //更新数据
    [[iSQLiteHelper getDefaultHelper] insertOrUpdateUsingObj:mt];
    
    [displayData removeObjectAtIndex:selected.row];
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
    [contentView addSubview:ctx];
    
    [contentView setH:ctx.endY+15];
    
    CMPopTipView *tip = [[CMPopTipView alloc] initWithCustomView:contentView];
    [tip presentPointingAtView:gen.view inView:self.view animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Lang(@"del_btn");
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayData.count;
}

-(void)whenSearchKey:(NSString *)search
{
    NSMutableArray *alldata = [self alltea];
    [displayData removeAllObjects];
    if (search!=nil && ![search isEqualToString:@""]) {
        for (Store *d in alldata) {
            if ([d.StoreName like:search]) {
                [displayData addObject:d];
            }
        }
        [tabview reloadData];
        return;
    }
    
    [displayData addObjectsFromArray:alldata];
    [tabview reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"mycell_id_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    Store *left = [displayData objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        VIEGOImageView *imageview = [[VIEGOImageView alloc] initWithFrame:Frm(0, 5, 320, 80) placeImg:[@"no_pic.png" image] url:left.Logo];
        imageview.contentMode = UIViewContentModeScaleAspectFit;
        imageview.tag = 200;
        [cell.contentView addSubview:imageview];
        UILabel *sname = [VILabel createLableWithFrame:Frm(0, imageview.endY+8, 320, 20) color:@"#FF4F4F" font:Bold(15) align:CENTER];
        sname.tag = 201;
        sname.text = left.StoreName;
        [cell.contentView addSubview:sname];
    }
    [cell.contentView label4Tag:201].text = left.StoreName;
    [cell.contentView egoimageView4Tag:200].imageURL = [NSURL URLWithString:left.Logo];
  
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Store *pdata = [displayData objectAtIndex:indexPath.row];
    [self pushTo:@"VIStoreDetailViewController" data:[pdata toDictionary]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
