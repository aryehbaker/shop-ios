//
//  VIMenuTableViewCell.m
//  Shoprose
//
//  Created by vnidev on 5/25/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "VIMenuTableViewCell.h"
#import <VICore/VICore.h>
#import "VINet.h"
#import "Fonts.h"

@interface VIMenuTableViewCell()
@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *text;
@property(nonatomic,strong) UIImageView *specal;

@end

static int show = 260;

@implementation VIMenuTableViewCell

- (id)initWithIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.icon = [[UIImageView alloc] initWithFrame:Frm(5, 2, 40, 40)];
        if (isHe) {
            [self.icon setFrame:Frm(show-40, 2, 40, 40)];
        }
        [self.contentView addSubview:self.icon];
        self.text = [VILabel createLableWithFrame:Frm(50, 0, show-80, 44) color:@"#FFFFFF" font:FontS(16) align:LEFT];
        self.text.textAlignment = Align;
        [self.contentView addSubview:self.text];
        
        UIView *line = [[UIView alloc] initWithFrame:Frm(self.text.x, self.text.endY-1, self.text.w, 1)];
        line.backgroundColor = [@"#ffffff" hexColor];
        [self.contentView addSubview:line];
        
    }
    return self;
}

- (void)repaint:(id)data
{
    if ([data boolValueForKey:@"issub" defaultValue:NO])
    {
        [self.contentView removeSubviews];

        UIView *line = [[UIView alloc] initWithFrame:Frm(75, 43, show-120, 1)];
        if (isEn)
            [line setX:50];
        line.backgroundColor = [@"#ffffff" hexColor];
        [self.contentView addSubview:line];
        
        NSString *titleStr = [data stringValueForKey:@"title"];
        if (![titleStr hasPrefix:@"@"]) {
            UILabel *titlelab = [VILabel createLableWithFrame:Frm(line.x, 0, line.w-28, 44) color:@"#ffffff" font:Regular(16) align:RIGHT];
            titlelab.textAlignment = Align;
            titlelab.text = Lang(titleStr);
            if (isEn) {
                [titlelab setX:line.x+30];
            }
            [self.contentView addSubview:titlelab];
        }else{
            self.text.text = @"";
            UIImageView *imagev = [[titleStr substringFromIndex:1] imageViewForImgSizeAtX:line.x+(line.w-95-28) Y:7];
            [self.contentView addSubview:imagev];
            if (isEn) {
                [imagev setX:line.x+30];
            }
        }
        UIImageView *smicon = [[UIImageView alloc] initWithFrame:Frm(line.endX-28, (44-25)/2, 25, 25)];
        if(isEn)
           [smicon setX:line.X];
        smicon.image = [[data stringValueForKey:@"icon"] image];
        [self.contentView addSubview:smicon];
        
    }else{
        NSString *titleStr = [data stringValueForKey:@"title"];
        [[self.contentView viewWithTag:200] removeFromSuperview];
        if (![titleStr hasPrefix:@"@"]) {
            self.text.text = Lang(titleStr);
            self.text.font = Regular(18);
        }else{
            self.text.text = @"";
            UIImageView *imagev = [[titleStr substringFromIndex:1] imageViewForImgSizeAtX:show-90-44 Y:5];
            if (isEn)
               [imagev setX:50];
            imagev.tag = 200;
            [self.contentView addSubview:imagev];
        }
        self.data = data;
        self.icon.image  = [[data stringValueForKey:@"icon"] image];
        
        int index = [data intValueForKey:@"index"];
        [[self.contentView viewWithTag:400] removeFromSuperview];
        
        if (index == 23) { //邮件设置
            UIButton *swith = [[UIButton alloc] initWithFrame:Frm(self.text.x, 8, 62, 27)];
            [swith setBackgroundImage:[@"sw_off.png" image] forState:UIControlStateNormal];
            [swith setTitle:@"ON" forState:UIControlStateNormal];
            [swith setTitleColor:[@"#ff4747" hexColor] forState:UIControlStateNormal];
            [swith setTitle:@"OFF" forState:UIControlStateSelected];
            [swith setTitleColor:[@"#202121" hexColor] forState:UIControlStateSelected];
            swith.titleLabel.font = VI_FONT_B14;
            swith.tag = 400;
            if(isEn)
                [swith setX:show - 100];
            swith.selected = [[NSUserDefaults standardUserDefaults] boolForKey:@"_close_notification_"];
            [self.contentView addSubview:swith];
            [self.contentView addSubview:[[UIView alloc] initWithFrame:swith.frame]];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    NSString *icon = [self.data stringValueForKey:@"icon"];
    if (selected) {
       icon =  [icon stringByReplacingOccurrencesOfString:@"_w" withString:@"_r"];
    }
    self.icon.image = [icon image];
    self.text.textColor = [(selected? @"#FC494D" : @"#ffffff") hexColor];
}

@end
