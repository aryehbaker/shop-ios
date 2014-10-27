//
//  VITimeDownCell.h
//  Shoprose
//
//  Created by vnidev on 6/15/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VITimeDownCell : UITableViewCell

- (id)initWithInfo:(NSString *)infoId;

- (void)repaintInfo:(NSDictionary *)leftInfo rightinfo:(NSDictionary *)rightinfo path:(NSIndexPath *)path;

@end

@interface NSDictionary (TimeDown)

- (BOOL) isExpirt;

- (BOOL) notStart;

@end