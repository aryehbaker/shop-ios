//
//  VIMyStoreViewController.h
//  ShopriseComm
//
//  Created by mk on 4/3/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "ShopriseViewController.h"

@interface VIStoreViewController : ShopriseViewController<VICfgTableProto>

@property(nonatomic,strong) NSString  *tableCfg;
@property(nonatomic,strong) NSString  *tbcfTitle;

@end
