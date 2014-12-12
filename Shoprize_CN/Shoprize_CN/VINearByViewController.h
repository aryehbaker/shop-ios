//
//  VINearByViewController.h
//  Shoprise_EN
//
//  Created by mk on 4/2/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import <Shoprize/ShopriseViewController.h>

@interface VINearByViewController : ShopriseViewController<UITableViewDataSource,VITableViewDelegate>

@property(nonatomic,strong) NSDictionary *mallInfo;

@end
