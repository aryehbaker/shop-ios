//
//  VILocalNotify.m
//  Shoprise_HE
//
//  Created by vnidev on 7/21/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VILocalNotify.h"
#import "VIAppDelegate.h"
#import <VICore/VICore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <Shoprize/Fonts.h>

@interface VILocalNotify()
{
    NSTimer *t ;
}

@property(nonatomic,copy) NSString *text;
@property(nonatomic,strong) id obj;

@end

const int TIME_SECOND_SHOW = 5;

@implementation VILocalNotify

static VILocalNotify *pushView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * TIME_SECOND_SHOW);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        });
    }
    return self;
}

static SystemSoundID shake_sound_male_id = 0;

+(void)showPopNotify:(NSString *)text obj:(id)obj
{
    UIWindow *mainWind = ((VIAppDelegate*)[UIApplication sharedApplication].delegate).window;
    
    if (pushView) {
       [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
       [pushView removeFromSuperview];
       pushView = nil;
    }
    
    pushView = [[VILocalNotify alloc] initWithFrame:CGRectMake(0, 0, mainWind.w, 64)];
    pushView.backgroundColor = [@"#000000" hexColorAlpha:.8];
    pushView.tag = - 5000;
    pushView.text = text;
    pushView.obj = obj;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"local_msg" ofType:@"caf"];
    if (path!=nil) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_male_id);
        AudioServicesPlaySystemSound(shake_sound_male_id);
    }
    AudioServicesPlaySystemSound(shake_sound_male_id); //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    //AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
    
    UIImageView *appIcon = [@"AppIcon60x60.png" imageView];
    appIcon.frame = Frm(13, 6, 20, 20);
    appIcon.layer.cornerRadius = 5;
    appIcon.layer.masksToBounds = YES;
    [pushView addSubview:appIcon];
    
    UILabel *appname = [VILabel createLableWithFrame:Frm(appIcon.endX+10, appIcon.Y, 200, 13) color:@"#ffffff" font:FontS(13) align:LEFT];
    appname.text = @"Shoprize";
    [pushView addSubview:appname];
    
    //确定跳转
    [pushView addTapTarget:pushView action:@selector(oktogo:)];
    
    UILabel *tlab = [VILabel createLableWithFrame:Frm(appname.x,appname.endY+3, mainWind.w-(appname.x+20),40) color:@"#ffffff" font:Regular(13) align:LEFT];
    tlab.text = text;
    tlab.numberOfLines = 2;
    [pushView addSubview:tlab];
    
    [pushView setY:-pushView.h];
    
    [mainWind addSubview:pushView];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [UIView animateWithDuration:.35 animations:^{
         [pushView setY:0];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)oktogo:(UIButton *)btn
{
    if ([[self.obj stringValueForKey:@"NotifyType"] isEqualToString:@"Store"])
    {
        VIBaseViewController *b = [[NSClassFromString(@"VIStoreDetailViewController") alloc] init];
        [b setValueToContent:self.obj forKey:@"push_in"];
        VIAppDelegate *app = (VIAppDelegate *)[UIApplication sharedApplication].delegate;
        [[app pushStack] pushViewController:b animated:YES];
        [self cancel:nil];
    }
}

-(void)cancel:(id)btn
{
    [UIView animateWithDuration:.2 animations:^{
            [self setY:-self.h];
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
                pushView = nil;
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            }
        }];
}

@end
