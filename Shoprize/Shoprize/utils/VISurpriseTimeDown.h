//
//  VISurpriseTimeDown.h
//  Shoprose
//
//  Created by vnidev on 8/16/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VISurpriseTimeDown : UITableViewCell

- (id)initWithInfo:(NSString *)infoId;

- (void)repaintInfo:(NSDictionary *)leftInfo rightinfo:(NSDictionary *)rightinfo path:(NSIndexPath *)path

             redeem:(BOOL)redeem;


@end
