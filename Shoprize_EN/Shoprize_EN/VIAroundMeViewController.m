//
//  VIAroundMeViewController.m
//  Shoprize_EN
//
//  Created by ShawFung Chao on 10/27/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import "VIAroundMeViewController.h"

@interface VIAroundMeViewController ()
{
    VITableView *_tableView;
    NSMutableArray *deals;
}

@end

@implementation VIAroundMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNav:@"Aroud Me" left:BACK right:MapIt];
    _tableView = [[VITableView alloc] initWithFrame:Frm(0, self.nav.endY, 320, Space(self.nav.endY)) style:UITableViewStylePlain];
    _tableView.delegate = _tableView;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.viewDelegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
