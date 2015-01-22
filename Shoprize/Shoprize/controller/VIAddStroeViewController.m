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
    VITableView *tabview;
    NSMutableArray *storeData;
    
    NSInteger currentPage;
    NSString *searchKey;
}

@end

@implementation VIAddStroeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNav:Lang(@"nav_my_store") left:SEARCH right:MENU];
    
    tabview = [[VITableView alloc] initWithFrame:Frm(0, self.nav.endY,self.view.w,self.view.h -self.nav.endY-70)];
    tabview.delegate = tabview;
    tabview.viewDelegate = self;
    tabview.dataSource = self;
    
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
    [tbn setTitle:Lang(@"add_store_done") selected:Lang(@"add_store_done")];
    [tbn setTitleColor:[@"#464646" hexColor] forState:UIControlStateNormal];
    [tbn addTarget:self action:@selector(completeSelect:)];
    [v addSubview:tbn];
    
    if(isEn){
        [tbn setBackgroundcolorByHex:@"#ff4747"];
        [tbn setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
        tbn.layer.borderWidth = 0;
    }
    
    [self.view addSubview: v];
    
    currentPage = 0;
    storeData = [NSMutableArray array];
    [self loadData];
}

-(void)loadData
{
    NSString *query = Fmt(@"pageindex=%d&pagesize=10&saved=false&searchkey=%@",currentPage,searchKey==nil?@"":searchKey);
    [VINet get:Fmt(@"/api/stores/all?%@",query) args:nil target:self succ:@selector(loadComplet:) error:@selector(loadComplet2:) inv: (storeData.count == 0 && searchKey ==nil) ? self.view : nil];
}

-(void)loadComplet:(NSDictionary *)value
{
    if (currentPage == 0) {
        [storeData removeAllObjects];
    }
    [storeData addObjectsFromArray:[value arrayValueForKey:@"Stores"]];
    [tabview reloadAndHideLoadMore:[value intValueForKey:@"Count"]==storeData.count];
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

- (void)rowSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *mt = [[storeData objectAtIndex:indexPath.row] mutableCopy];
    [mt setValue:[NSNumber numberWithBool:![mt boolValueForKey:@"Saved"]] forKey:@"Saved"];
    [storeData replaceObjectAtIndex:indexPath.row withObject:mt];
    [tabview reloadData];
    
    // do update
    [[iSQLiteHelper getDefaultHelper] insertOrUpdateUsingObj:mt];
    
    NSString *StoreId = [mt stringValueForKey:@"StoreId"];
    NSString *StoreName = [mt stringValueForKey:@"Name"];
    
    BOOL mark = [mt boolValueForKey:@"Saved"];
    NSString *api = Fmt(@"/api/stores/%@/mark",StoreId);
    if (!mark) {
        api = Fmt(@"/api/stores/%@/unmark",StoreId);
    }
    
    if (mark) {
        [self addTracksForKey:_TK_Add_Fav_Store values:@[StoreId,StoreName]];
    }
    
    [VINet post:api args:nil target:self succ:@selector(doNothing:) error:@selector(doNothing:) inv:self.view];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return storeData.count;
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
    
    NSDictionary *value = [storeData objectAtIndex:indexPath.row];
    BOOL check = [value boolValueForKey:@"Saved"];
    [cell imageView4Tag:12003].image = check ? [@"heart_red.png" image] : [@"heart_gray.png" image];
    [cell egoimageView4Tag:12002].imageURL = [NSURL URLWithString:[value stringValueForKey:@"Logo"]];
    [cell label4Tag:12004].text = [value stringValueForKey:@"Name"];
    [cell label4Tag:12004].font = FontS(15);
    [cell label4Tag:12004].textColor = check ? [@"#FF2B32" hexColor] : [@"#767676" hexColor];
    
    return cell;
}

-(void)whenSearchKey:(NSString *)search
{
    searchKey = search;
    currentPage = 0;
    [self loadData];
}

- (void)completeSelect:(id)sender {
    [self pop:YES];
}



@end
