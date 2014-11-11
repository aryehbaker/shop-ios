//
//  VIMyStoreViewController.m
//  ShopriseComm
//
//  Created by mk on 4/3/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIStoreViewController.h"

@interface VIStoreViewController ()

@end

@implementation VIStoreViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self addNav:_tbcfTitle left:BACK right:NONE];
    
    VICfgTableView *cfg = [[VICfgTableView alloc] initWithFrame:Frm(0, self.nav.endY, self.view.w, Space(self.nav.endY)) cfg:_tableCfg];
    cfg.delegate = self;
    [self.view addSubview:cfg];
    
}

-(void)rowSelectedAt:(NSIndexPath *)index data:(id)data
{
    
}


@end
