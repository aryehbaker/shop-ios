//
//  VISurpriseTimeDown.m
//  Shoprose
//
//  Created by vnidev on 8/16/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "VISurpriseTimeDown.h"
#import <VICore/VICore.h>
#import "KUtils.h"
#import "VINet.h"
#import "Models.h"

@interface VISurpriseTimeDown()
{
    NSTimer *leftTimer;
    NSTimer *rightTimer;
    
}
@property(nonatomic,strong) NSDictionary *leftInfo;
@property(nonatomic,strong) NSDictionary *rightInfo;

@end

@implementation VISurpriseTimeDown

-(id)initWithInfo:(NSString *)infoId
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


-(void)repaintInfo:(NSDictionary *)li rightinfo:(NSDictionary *)ri path:(NSIndexPath *)path redeem:(BOOL)redeem
{
    self.leftInfo = li;
    self.rightInfo = ri;
    [leftTimer invalidate];[rightTimer invalidate];
    
     leftTimer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repaintLeftInfo) userInfo:nil repeats:YES];
    rightTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(repaintRightInfo) userInfo:nil repeats:YES];
    
    [self egoimageView4Tag:14001].imageURL = [NSURL URLWithString:[self.leftInfo stringValueForKey:@"defPicture"]];
    [self label4Tag:14002].hidden = YES;
    [self label4Tag:14003].text = [self.leftInfo stringValueForKey:@"Offer" defaultValue:@""];
    
    NSString *leftMId = [self.leftInfo stringValueForKey:@"MobiPromoId"];
    UserSurprise *leftUsr = [[iSQLiteHelper getDefaultHelper] searchSingle:[UserSurprise class] where:@{@"MobiPromoId":leftMId} orderBy:@"MobiPromoId"];
    
    NSDate *lExp   = leftUsr.ExpireTime;
    if(leftUsr.Redeemed) {
        [self label4Tag:14004].text = Lang(@"menu_sprise_used");
        [leftTimer invalidate];
        [self label4Tag:14004].hidden = NO;
        [self imageView4Tag:14005].hidden = YES;
        [self label4Tag:14006].hidden = YES;
        [self label4Tag:14007].hidden = YES;
    }else if([[NSDate now] laterThan:lExp]){
        [self label4Tag:14004].text = Lang(@"activity_end");
        [leftTimer invalidate];
        [self label4Tag:14004].hidden = NO;
        [self imageView4Tag:14005].hidden = YES;
        [self label4Tag:14006].hidden = YES;
        [self label4Tag:14007].hidden = YES;
    } else {
        int nowval = [lExp timeIntervalSinceNow];
        if (nowval >0) {
                [leftTimer setFireDate:[NSDate now]];
                [self label4Tag:14004].hidden = YES;
                [self imageView4Tag:14005].hidden = NO;
                [self label4Tag:14006].hidden = NO;
                [self label4Tag:14007].hidden = NO;
        }else{
              [leftTimer invalidate];
              [self label4Tag:14004].text = Lang(@"activity_end");
              [self label4Tag:14004].hidden = NO;
              [self imageView4Tag:14005].hidden = YES;
              [self label4Tag:14006].hidden = YES;
              [self label4Tag:14007].hidden = YES;
        }
    }
    
   if (self.rightInfo !=nil) {
    
        [self egoimageView4Tag:14101].imageURL = [NSURL URLWithString:[self.rightInfo stringValueForKey:@"defPicture"]];
        [self label4Tag:14102].hidden = YES;
        [self label4Tag:14103].text = [self.rightInfo stringValueForKey:@"Offer" defaultValue:@""];
       
       NSString *rightMId = [self.rightInfo stringValueForKey:@"MobiPromoId"];
       UserSurprise *RightUsr = [[iSQLiteHelper getDefaultHelper] searchSingle:[UserSurprise class] where:@{@"MobiPromoId":rightMId} orderBy:@"MobiPromoId"];
       
        NSDate *lExp   = RightUsr.ExpireTime;
        if(RightUsr.Redeemed)
        {
            [self label4Tag:14104].text = Lang(@"menu_sprise_used");
            [rightTimer invalidate];
            [self label4Tag:14104].hidden = NO;
            [self imageView4Tag:14105].hidden = YES;
            [self label4Tag:14106].hidden = YES;
            [self label4Tag:14107].hidden = YES;
        }else if([[NSDate now] laterThan:lExp]){
            [self label4Tag:14104].text = Lang(@"activity_end");
            [rightTimer invalidate];
            [self label4Tag:14104].hidden = NO;
            [self imageView4Tag:14105].hidden = YES;
            [self label4Tag:14106].hidden = YES;
            [self label4Tag:14107].hidden = YES;
        }else {
            int nowval = [lExp timeIntervalSinceNow];
            if (nowval >0) {
                [rightTimer setFireDate:[NSDate now]];
                [self label4Tag:14104].hidden = YES;
                [self imageView4Tag:14105].hidden = NO;
                [self label4Tag:14106].hidden = NO;
                [self label4Tag:14107].hidden = NO;
            }else{
                [rightTimer invalidate];
                [self label4Tag:14104].text = Lang(@"activity_end");
                [self label4Tag:14104].hidden = NO;
                [self imageView4Tag:14105].hidden = YES;
                [self label4Tag:14106].hidden = YES;
                [self label4Tag:14107].hidden = YES;
            }
        }
    }
    
    [[self viewWithTag:-2000] setHidden:self.rightInfo==nil];
    [[self egoimageView4Tag:3002] setHidden:self.rightInfo==nil];
}

- (void)repaintLeftInfo
{
    NSString *leftID = [self.leftInfo stringValueForKey:@"MobiPromoId"];
    if (leftID==nil) {
        return;
    }
    
    UserSurprise *leftid = [[iSQLiteHelper getDefaultHelper] searchSingle:[UserSurprise class] where:@{@"MobiPromoId":leftID} orderBy:@"MobiPromoId"];
    
    if ([leftid.ExpireTime laterThan:[NSDate now]]) {
        long  sec = [leftid.ExpireTime timeIntervalSinceNow];
        [self label4Tag:14006].text = Fmt(@"%.2ld:%.2ld:%.2ld",sec/3600, (sec-(sec/3600*3600))/60, sec-(sec/3600*3600)-(sec-(sec/3600*3600))/60*60);
    }else{
        [leftTimer invalidate];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"_Refresh_My_Surprise" object:nil];
    }
}

- (void)repaintRightInfo
{
    NSString *rightId = [self.rightInfo stringValueForKey:@"MobiPromoId"];
    if (rightId==nil) {
        return;
    }
    UserSurprise *rightid = [[iSQLiteHelper getDefaultHelper] searchSingle:[UserSurprise class] where:@{@"MobiPromoId":rightId} orderBy:@"MobiPromoId"];
    
    if ([rightid.ExpireTime laterThan:[NSDate now]]) {
        long  sec = [rightid.ExpireTime timeIntervalSinceNow];
        [self label4Tag:14106].text = Fmt(@"%.2ld:%.2ld:%.2ld",sec/3600, (sec-(sec/3600*3600))/60, sec-(sec/3600*3600)-(sec-(sec/3600*3600))/60*60);
    }else{
        [rightTimer invalidate];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"_Refresh_My_Surprise" object:nil];
    }
}

@end
