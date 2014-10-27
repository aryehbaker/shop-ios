//
//  VIAddStroeViewController.m
//  Shoprose
//
//  Created by vnidev on 5/29/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "VIAddStroeViewController.h"
#import "KUtils.h"

@interface VIAddStroeViewController ()
{
    UITableView *tabview;
    NSMutableArray *storeData;
}

@end

@implementation VIAddStroeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNav:Lang(@"nav_my_store") left:SEARCH right:MENU];
    
    tabview = [[UITableView alloc] initWithFrame:Frm(0, self.nav.endY, 320,self.view.h -self.nav.endY-70)];
    tabview.delegate = self;
    tabview.dataSource = self;
    
    storeData= [[iSQLiteHelper getDefaultHelper] searchAllModel:[Store class]];
    
    tabview.backgroundColor = [UIColor whiteColor];
    if ([tabview respondsToSelector:@selector(setSeparatorInset:)]) {
        [tabview setSeparatorInset:UIEdgeInsetsZero];
    }

    [self.view addSubview:tabview];
    
    UIView *v = [[UIView alloc] initWithFrame:Frm(0, tabview.endY, self.view.w, self.view.h-tabview.endY)];
    v.backgroundColor = [UIColor whiteColor];
    
    UIButton *tbn = [UIButton buttonWithType:UIButtonTypeCustom];
    tbn.frame = Frm(30,15, 260, 40);
    tbn.layer.borderWidth = 1;
    tbn.layer.cornerRadius = 20;
    tbn.layer.borderColor = [@"#9e9e9e" hexColor].CGColor;
    [tbn setTitle:Lang(@"add_store_done") hightTitle:Lang(@"add_store_done")];
    [tbn setTitleColor:@"#464646" hightColor:@"#464646"];
    [tbn addTarget:self action:@selector(completeSelect:)];
    [v addSubview:tbn];
    
    [self.view addSubview: v];
    
    [tabview reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return storeData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"mycell_id_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:[self loadXib:@"UI.xib" withTag:12000]];
        [cell egoimageView4Tag:12002].placeholderImage = [@"no_pic.png" image];
    }
    
    Store *value = [storeData objectAtIndex:indexPath.row];
    BOOL check = value.IsMarked;
    [cell viewWithTag:12001].backgroundColor = check ? [@"#ebebeb" hexColor] : [@"#ffffff" hexColor];
    [cell imageView4Tag:12003].image = check ? [@"heart_red.png" image] : [@"heart_gray.png" image];
    [cell egoimageView4Tag:12002].imageURL = [NSURL URLWithString:value.Logo];
    [cell label4Tag:12004].text = value.StoreName;
    [cell label4Tag:12004].font = Bold(15);
    [cell label4Tag:12004].textColor = check ? [@"#FF2B32" hexColor] : [@"#767676" hexColor];
    
    return cell;
}

-(void)whenSearchKey:(NSString *)search
{
    NSMutableArray *displayData = [[iSQLiteHelper getDefaultHelper] searchAllModel:[Store class]];
    [storeData removeAllObjects];
    if (search != nil) {
        for (Store *d in displayData) {
            if ([d.StoreName like:search]) {
                [storeData addObject:d];
            }
        }
        [tabview reloadData];
    }else{
        storeData = displayData;
        [tabview reloadData];
    }
}

- (void)completeSelect:(id)sender {
    [self pop:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)index
{
    Store *mt = [storeData objectAtIndex:index.row];
    [mt setIsMarked:!mt.IsMarked];
    [storeData replaceObjectAtIndex:index.row withObject:mt];
    [tabview reloadData];
    
    // do update
    [[iSQLiteHelper getDefaultHelper] insertOrUpdateUsingObj:mt];
    
    NSString *api = Fmt(@"/api/stores/%@/mark",mt.StoreId);
    if (!mt.IsMarked) {
        api = Fmt(@"/api/stores/%@/unmark",mt.StoreId);
    }
    [VINet post:api args:nil target:self succ:@selector(doNothing:) error:@selector(doNothing:) inv:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
