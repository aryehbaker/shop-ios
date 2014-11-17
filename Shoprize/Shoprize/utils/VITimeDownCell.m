//
//  VITimeDownCell.m
//  Shoprose
//
//  Created by vnidev on 6/15/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "VITimeDownCell.h"
#import <VICore/VICore.h>
#import "VINet.h"
#import "KUtils.h"

@interface VITimeDownCell()
{
    NSTimer *leftTimer;
    NSTimer *rightTimer;
}
@property(nonatomic,strong) MobiPromo *leftInfo;
@property(nonatomic,strong) MobiPromo *rightInfo;

@end

@implementation VITimeDownCell
@synthesize leftInfo=leftinfo,rightInfo=rightinfo;

- (id)initWithInfo:(NSString *)infoId
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoId];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:[VIBaseViewController loadXibView:@"UI.xib" withTag:14000]];
        [self egoimageView4Tag:14001].placeholderImage = [@"no_pic.png" image];
        [self egoimageView4Tag:14101].placeholderImage = [@"no_pic.png" image];
    }
    return self;
}

- (void)repaintInfo:(MobiPromo *)li rightinfo:(MobiPromo *)rl path:(NSIndexPath *)path {

    [leftTimer invalidate];
    [rightTimer invalidate];
    
    leftTimer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repaintLeftInfo) userInfo:nil repeats:YES];
    rightTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repaintRightInfo) userInfo:nil repeats:YES];
    
    self.leftInfo = li;
    self.rightInfo = rl;
    
    if (leftinfo != nil) {
        
        [self egoimageView4Tag:14001].imageURL = [NSURL URLWithString:[self.leftInfo StoreImageUrl]];
        [self label4Tag:14002].hidden = YES;
        [self label4Tag:14003].text = [leftinfo StoreName];
        
        id jsonValue = [[leftinfo Prerequisite] jsonVal];
        NSString *StartTime = [jsonValue stringValueForKey:@"StartTime"];
        NSString *nowTime   = [[NSDate now] format:@"HH:mm"];
        if ([self time2Sec:StartTime] > [self time2Sec:nowTime]) {
            [leftTimer setFireDate:[NSDate now]];
            [self label4Tag:14004].hidden = YES;
            [self imageView4Tag:14005].hidden = NO;
            [self label4Tag:14006].hidden = NO;
            [self label4Tag:14007].hidden = NO;
        } else{
            [leftTimer invalidate];
            [self label4Tag:14004].hidden = NO;
            [self imageView4Tag:14005].hidden = YES;
            [self label4Tag:14006].hidden = YES;
            [self label4Tag:14007].hidden = YES;
            [self label4Tag:14004].text = @"זמין";
        }
    }

    if (rightinfo!=nil) {
        
        [self egoimageView4Tag:14101].imageURL = [NSURL URLWithString:[self.rightInfo StoreImageUrl]];
        [self label4Tag:14102].hidden = YES;
        [self label4Tag:14103].text = [self.rightInfo StoreName];
        
        id jsonValue = [[self.rightInfo Prerequisite] jsonVal];
        NSString *StartTime = [jsonValue stringValueForKey:@"StartTime"];
        NSString *nowTime   = [[NSDate now] format:@"HH:mm"];
        if ([self time2Sec:StartTime] > [self time2Sec:nowTime]) {
            [rightTimer setFireDate:[NSDate now]];
            [self label4Tag:14104].hidden = YES;
            [self imageView4Tag:14105].hidden = NO;
            [self label4Tag:14106].hidden = NO;
            [self label4Tag:14107].hidden = NO;
        } else{
            [rightTimer invalidate];
            [self label4Tag:14104].hidden = NO;
            [self imageView4Tag:14105].hidden = YES;
            [self label4Tag:14106].hidden = YES;
            [self label4Tag:14107].hidden = YES;
            [self label4Tag:14104].text = @"זמין";
        }
     }
    
    [[self viewWithTag:-2000] setHidden:rightinfo==nil];
    [[self egoimageView4Tag:3002] setHidden:rightinfo==nil];
    
}

- (NSDate *)addTime:(NSString *)start
{
    NSString *time = [[NSDate now] formatDefalut];
    return [[time stringByAppendingFormat:@" %@:00",start] parse:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)repaintLeftInfo
{
    id jsonValue = [[self.leftInfo Prerequisite] jsonVal];
    if ([jsonValue allKeys].count >0 && [[jsonValue stringValueForKey:@"Type"] isEqualToString:@"InStore"]) {
        NSString *StartTime = [jsonValue stringValueForKey:@"StartTime"];
        NSString *nowTime   = [[NSDate date] format:@"HH:mm:ss"];
        int offset = [self time2Sec:StartTime] - [self time2Sec:nowTime];
        if (offset>0) {
            [self label4Tag:14006].text = Fmt(@"%.2d:%.2d:%.2d",offset/3600, (offset-(offset/3600*3600))/60, offset-(offset/3600*3600)-(offset-(offset/3600*3600))/60*60);
        }else{
            [leftTimer invalidate];
            [self repaintInfo:leftinfo rightinfo:rightinfo path:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSurpiseShow" object:nil];
        }
    }
}

- (void)repaintRightInfo
{
    id jsonValue = [[self.rightInfo Prerequisite] jsonVal];
    if ([jsonValue allKeys].count >0 && [[jsonValue stringValueForKey:@"Type"] isEqualToString:@"InStore"])
    {
        NSString *StartTime = [jsonValue stringValueForKey:@"StartTime"];
        NSString *nowTime   = [[NSDate now] format:@"HH:mm:ss"];
        int sec = [self time2Sec:StartTime] - [self time2Sec:nowTime];
        if (sec>0) {
            [self label4Tag:14106].text = Fmt(@"%.2d:%.2d:%.2d",sec/3600, (sec-(sec/3600*3600))/60, sec-(sec/3600*3600)-(sec-(sec/3600*3600))/60*60);
        }else{
            [rightTimer invalidate];
            [self repaintInfo:leftinfo rightinfo:rightinfo path:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSurpiseShow" object:nil];
        }
    }
}

- (int)time2Sec:(NSString *)time {
   NSArray *ts = [time componentsSeparatedByString:@":"];
    if (ts.count == 1) {
        return [time intValue];
    }
    if (ts.count == 2) {
      return [[ts objectAtIndex:0] intValue] * 60 * 60 + [[ts objectAtIndex:1] intValue] * 60;
    }
    if (ts.count == 3) {
        return [[ts objectAtIndex:0] intValue] * 60 * 60 + [[ts objectAtIndex:1] intValue] * 60
        + [[ts objectAtIndex:2] intValue]  ;
    }
    return 0;
}

@end


