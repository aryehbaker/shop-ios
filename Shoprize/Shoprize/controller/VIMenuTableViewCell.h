//
//  VIMenuTableViewCell.h
//  Shoprose
//
//  Created by vnidev on 5/25/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIMenuTableViewCell : UITableViewCell
@property(nonatomic,strong) id data;

- (id)initWithIdentifier:(NSString *)reuseIdentifier;

- (void)repaint:(id)data;

@end
