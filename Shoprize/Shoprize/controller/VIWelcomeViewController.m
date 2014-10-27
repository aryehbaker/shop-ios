//
//  VIWelcomeViewController.m
//  ShopriseComm
//
//  Created by mk on 4/1/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIWelcomeViewController.h"
#import "VIMailLogonViewController.h"
#import <objc/runtime.h>

@interface VIWelcomeViewController ()

@end

@implementation VIWelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCommentPage:.4];
    
    UIImageView *t1 = [@"logo.png" imageViewForImgSizeAtX:0 Y:40];
    [self.view addSubview:t1];
    
    /*
    UILabel *txt = [VILabel createLableWithFrame:Frm(36, t1.endY+10,t1.w - 72  , 40) color:@"#FEFEFE" font:FontPekanRegular(18) align:CENTER];
    txt.numberOfLines = 2;
    txt.text = Lang(@"logon_logo_desc");
    [self.view addSubview:txt];
    */
    UIButton *faceBk = [[UIButton alloc] initWithFrame:Frm(35, self.view.h - 170, 250, 50)];
    [faceBk setBackgroundImage:[@"facebook_btn.png" image] forState:UIControlStateNormal];
    [faceBk setTitle:Lang(@"facebook_logon") forState:UIControlStateNormal];
    faceBk.titleLabel.font = FontPekanBold(20);
    [faceBk setTitleColor:[@"#0A76BE" hexColor] forState:UIControlStateNormal];
    
    [faceBk addTarget:self action:@selector(facebookLogon:)];
    [self.view addSubview:faceBk];
    
    
    UIButton *email = [[UIButton alloc] initWithFrame:Frm(35, faceBk.endY+5, 250, 50)];
    [email addTarget:self action:@selector(pushToLogin:)];
    email.titleLabel.font = FontPekanBold(20);
    [email setBackgroundImage:[@"mail_logon_btn.png" image] forState:UIControlStateNormal];
    [email setTitle:Lang(@"mail_logon") forState:UIControlStateNormal];
    [email setTitleColor:[@"#626262" hexColor] forState:UIControlStateNormal];
    [self.view addSubview:email];
    
    UIButton *signUp = [[UIButton alloc] initWithFrame:Frm(0, self.view.h-40, 320, 40)];
    [signUp setTitle:Lang(@"index_signup") forState:UIControlStateNormal];
    [signUp setBackgroundcolorByHex:@"#FF4745"];
    signUp.titleLabel.font = FontPekanBold(20);
    [signUp setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    [signUp addTarget:self action:@selector(signUp:)];
    [self.view addSubview:signUp];
 
}

- (void)facebookLogon:(UIButton *)sender
{
    sender.enabled = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_facebook_logon_" object:nil];
    
    double delayInSeconds = 2.0;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^(void){
        sender.enabled = YES;
    });
    
   
}

- (void)pushToLogin:(id)sender
{
    VIMailLogonViewController *mail = [[VIMailLogonViewController alloc] init];
    [self push:mail];
}


- (void)signUp:(id)sender
{
    [self pushTo:@"VIHtmlViewController" data:@"sigeup.html"];
    //[self pushTo:@"VIHtmlViewController" data:@"whichULike.html"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end