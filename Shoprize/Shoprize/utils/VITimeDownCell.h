//
//  VITimeDownCell.h
//  Shoprose
//
//  Created by vnidev on 6/15/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Models.h"

@interface VITimeDownCell : UITableViewCell

- (id)initWithInfo:(NSString *)infoId;

- (void)repaintInfo:(MobiPromo *)leftInfo rightinfo:(MobiPromo *)rightinfo path:(NSIndexPath *)path;

@end