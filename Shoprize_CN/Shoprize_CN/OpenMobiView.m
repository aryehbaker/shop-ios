//
//  OpenMobiView.m
//  Shoprize_EN
//
//  Created by vniapp on 11/12/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import "OpenMobiView.h"
#import <VICore/VICore.h>
#import <Shoprize/VINet.h>
#import <Shoprize/KUtils.h>
#import "VIAppDelegate.h"

@interface OpenMobiView()
{
    UITableView *table;
    
    NSMutableArray *datalist;
    NSDictionary *postdata;
}
@end

@implementation OpenMobiView

+(void)showMobisIn:(UIView *)view info:(NSDictionary *)store
{
    OpenMobiView *open = [[OpenMobiView alloc] initIn:view info:store];
    [open setY:view.h];
    [view addSubview:open];
    
    [UIView animateWithDuration:.38 animations:^{
        [open setY:0];
    }];
    
}

-(id)initIn:(UIView *)view info:(NSDictionary *)store
{
    self = [super initWithFrame:view.bounds];
    if (self) {
        postdata = store;
        int x = view.w * 0.05,y =view.h*0.1;
        UIImageView *close = [@"close_btn.png" imageViewForImgSizeAtX:x Y:y];
        [close addX:-close.w/2 andY:-close.h/2];
        [close addTapTarget:self action:@selector(closeIt:)];
        
        UIView *content = [[UIView alloc] initWithFrame:Frm(x,y, self.w * 0.9, self.h*0.8)];
        content.layer.cornerRadius = 3;
        content.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:content];
        [self addSubview:close];
        //8 85 102
        
        EGOImageView *ego = [[EGOImageView alloc] initWithFrame:Frm(8, 8, 86, 102)];
        ego.contentMode = UIViewContentModeScaleAspectFit;
        ego.imageURL = [NSURL URLWithString:[store stringValueForKey:@"Logo"]];
        ego.placeholderImage  = [@"defaults.png" image];
        [content addSubview:ego];
        
        VIRTLabel *rtlabel = [[VIRTLabel alloc] initWithFrame:Frm(108,8,content.w-116, 0)];
        [rtlabel setText:Fmt(@"<b>Name</b>:%@\n<b>OpenHour</b>:%@\n<b>Phone</b>:%@\n<b>Address</b>:%@",
                             [store stringValueForKey:@"Name" defaultValue:@""],
                             [store stringValueForKey:@"OpenHours" defaultValue:@""],
                             [store stringValueForKey:@"Phone" defaultValue:@""],
                             [store stringValueForKey:@"Address" defaultValue:@""])];
        [rtlabel setH:rtlabel.optimumSize.height];
        [content addSubview:rtlabel];
        [rtlabel setFont:FontS(13)];
        
        int endY = MAX(rtlabel.endY, ego.endY);
        
        table = [[UITableView alloc] initWithFrame:Frm(8, endY, content.w-16, content.h-endY-5) style:UITableViewStylePlain];
        table.dataSource = self;
        table.delegate = self;
        [content addSubview:table];
        
        UIView *li = [[UIView alloc] initWithFrame:Frm(table.x, table.y-1, table.w, 1)];
        li.backgroundColor = [@"#CDCBD4" hexColor];
        [content addSubview:li];
        
        [VINet get:Fmt(@"/api/stores/%@/detail",[store stringValueForKey:@"AddressId"]) args:nil target:self succ:@selector(loadComplte:) error:@selector(loadFail:) inv:table];
    }
    return self;
    
}

-(void)loadComplte:(NSDictionary *)value
{
    datalist = [NSMutableArray array];
    Store *store = [[Store alloc] initWithDictionary:value error:nil];
    for (MobiPromo *d in store.MobiPromos) {
        if (YES || ![d isSuprise]) {
            [datalist addObject:d];
        }
    }
    [table reloadData];
}

-(void)loadFail:(id)value
{
    [VIAlertView showErrorMsg:@"Load Error"];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return datalist.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = [datalist objectAtIndex:indexPath.row];
    
    VIAppDelegate *app = (VIAppDelegate*)[UIApplication sharedApplication].delegate;
    VIDealsDetailViewController *d = [[VIDealsDetailViewController alloc] init];
    d.dealid = [info stringValueForKey:@"MobiPromoId"];
    
    [[app pushStack] pushViewController:d animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"thisiscellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    EGOImageView *ego;
    VIRTLabel *label;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        ego = [[EGOImageView alloc] initWithFrame:Frm(3, 3, 60, 74)];
        ego.placeholderImage = [@"defaults.png" image];
        ego.tag = 100;
        [cell.contentView addSubview:ego];
        label = [[VIRTLabel alloc] initWithFrame:Frm(ego.endX+10, 3, tableView.w-ego.endX-20, 0)];
        label.tag = 101;
        [cell.contentView addSubview:label];
    }else{
        ego = [cell.contentView egoimageView4Tag:100];
        label = (VIRTLabel*)[cell.contentView viewWithTag:101];
    }
    
    NSDictionary *info = [datalist objectAtIndex:indexPath.row];
    ego.imageURL = [NSURL URLWithString:[info stringValueForKey:@"Pictures/0/PictureUrl"]];
    NSString *offer = [info stringValueForKey:@"Offer"];
    if (offer.length > 30) {
        offer = [[offer substringToIndex:30] contact:@"...", nil];
    }
    NSString *expd = [[[info stringValueForKey:@"ExpireDate"] toLocalDate] format:@"MM/dd/yyyy"];
    if (expd!=nil) {
        [label setText:Fmt(@"<i>%@</i>\n<b>StartDate</b>:%@\n<b>ExpireDate</b>:%@" ,offer
                           ,[[[info stringValueForKey:@"StartDate"] toLocalDate] format:@"MM/dd/yyyy"]
                           ,expd
                           )];
    }else{
        [label setText:Fmt(@"<i>%@</i>\n<b>StartDate</b>:%@\n<b>" ,offer
                           ,[[[info stringValueForKey:@"StartDate"] toLocalDate] format:@"MM/dd/yyyy"]
                           )];
    }
   
    [label setH:label.optimumSize.height];
    label.layer.masksToBounds = YES;
    
    return cell;
}

-(void)closeIt:(id)sender
{
    [UIView animateWithDuration:.2 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

@end
