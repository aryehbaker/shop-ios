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
    
    if (isHe) {
        [self addCommentPage:.4];
        UIImageView *t1 = [@"logo.png" imageViewForImgSizeAtX:0 Y:40];
        [self.view addSubview:t1];
    }
    if (isEn) {
        [self addCommentPage:0];
        UIImageView *t1 = [@"suplogo.png" imageViewForImgSizeAtX:(self.view.w-279)/2 Y:self.view.h-270];
        [self.view addSubview:t1];
    }
    
        UIButton *faceBk = [[UIButton alloc] initWithFrame:Frm(35, self.view.h - 170, 250, 50)];
        [faceBk setBackgroundImage:[@"facebook_btn.png" image] forState:UIControlStateNormal];
        [faceBk setTitle:Lang(@"facebook_logon") forState:UIControlStateNormal];
        faceBk.titleLabel.font = Bold(19);
        [faceBk setTitleColor:[@"#0A76BE" hexColor] forState:UIControlStateNormal];
    
        if(isEn){
           [faceBk setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
           [faceBk setTitleColor:[@"#FFFFFF" hexColor] forState:UIControlStateNormal];
        }
    
        [faceBk addTarget:self action:@selector(facebookLogon:)];
        [self.view addSubview:faceBk];
        
        
        UIButton *email = [[UIButton alloc] initWithFrame:Frm(35, faceBk.endY+5, 250, 50)];
        [email addTarget:self action:@selector(pushToLogin:)];
        email.titleLabel.font = Bold(19);
        [email setBackgroundImage:[@"mail_logon_btn.png" image] forState:UIControlStateNormal];
        [email setTitle:Lang(@"mail_logon") forState:UIControlStateNormal];
        [email setTitleColor:[@"#626262" hexColor] forState:UIControlStateNormal];
        [self.view addSubview:email];
    
    if(isEn){
        [email setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
        [email setTitleColor:[@"#FFFFFF" hexColor] forState:UIControlStateNormal];
    }
    
    UIButton *signUp = [[UIButton alloc] initWithFrame:Frm(0, self.view.h-40, self.view.w, 40)];
    [signUp setTitle:Lang(@"index_signup") forState:UIControlStateNormal];
    [signUp setBackgroundcolorByHex:RED];
    signUp.titleLabel.font = Bold(20);
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


- (void)signUp:(id)sender {
    [self pushTo:@"VIHtmlViewController" data:Lang(@"sigeup_html")];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
