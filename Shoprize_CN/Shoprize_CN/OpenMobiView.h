//
//  OpenMobiView.h
//  Shoprize_EN
//
//  Created by vniapp on 11/12/14.
//  Copyright (c) 2014 techwuli.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenMobiView : UIView<UITableViewDataSource,UITableViewDelegate>

+(void)showMobisIn:(UIView *)view info:(NSDictionary *)store;

@end
