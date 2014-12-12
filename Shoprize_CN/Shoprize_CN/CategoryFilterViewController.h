//
//  CategoryFilterViewController.h
//  Shoprize_EN
//
//  Created by vniapp on 11/3/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Shoprize/ShopriseViewController.h>

@interface CategoryFilterViewController : ShopriseViewController<UITableViewDataSource,UITableViewDelegate>

-(id)initWith:(NSString *)filtervalue;

@end
