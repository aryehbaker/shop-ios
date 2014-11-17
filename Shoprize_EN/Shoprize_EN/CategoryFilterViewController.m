//
//  CategoryFilterViewController.m
//  Shoprize_EN
//
//  Created by vniapp on 11/3/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import "CategoryFilterViewController.h"
#import <VICore/VICore.h>

@interface CategoryFilterViewController ()

@property(nonatomic,strong) NSMutableArray *datas;

@end

@implementation CategoryFilterViewController

-(id)initWith:(NSString *)filtervalue
{
    self = [super init];
    if (self) {
        NSArray *v2 = [filtervalue componentsSeparatedByString:@","];
        [[iSQLiteHelper getDefaultHelper] executeDB:^(FMDatabase *db) {
             NSString *where = Fmt(@"select distinct(CategoryName),CategoryId from MobiPromoAR");
            FMResultSet *set = [db executeQuery:where];
            self.datas = [NSMutableArray array];
            while (set.next) {
                NSString *idv = Fmt(@"'%@'",[set stringForColumnIndex:1]);
                [self.datas addObject:[@{
                                        @"t" : [set stringForColumnIndex:0],
                                        @"i" : [set stringForColumnIndex:1],
                                        @"s" : [NSNumber numberWithBool:
                                                v2 == nil ?  YES :
                                                [v2 indexOfObject:idv] != NSNotFound]
                                        } mutableCopy]];
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self addNav:@"Filter" left:BACK right:NONE];
    [self.leftOne addTarget:self action:@selector(doComplete:)];
    
    int w = self.view.w ,h = self.view.h;
    
    UITableView *table = [[UITableView alloc] initWithFrame:Frm(0, self.nav.endY,w,h-self.nav.endY) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    table.backgroundColor = [@"#ffffff" hexColor];
}

-(void)doComplete:(id)sender {
    [self dismissModalViewController];
    
    NSMutableString *mtb = [[NSMutableString alloc] init];
    for (NSMutableDictionary *dict in self.datas) {
        if ([dict boolValueForKey:@"s"]) {
             [mtb appendFormat:@",'%@'",[dict stringValueForKey:@"i"]];
        }
    }
    NSString *reslut = @"";
    if (mtb.length > 0) {
        reslut = [mtb substringFromIndex:1];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_filtered_" object:reslut];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellid = @"tablviewcellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSMutableDictionary *mt = [self.datas objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [mt stringValueForKey:@"t"];
    cell.selected = [mt boolValueForKey:@"s"];
    cell.accessoryType =cell.selected ? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *mt = [self.datas objectAtIndex:indexPath.row];
    BOOL selc = [mt boolValueForKey:@"s"];
    [mt setValue:[NSNumber numberWithBool:!selc] forKey:@"s"];
    [self.datas replaceObjectAtIndex:indexPath.row withObject:mt];
    [tableView reloadData];
}

@end
