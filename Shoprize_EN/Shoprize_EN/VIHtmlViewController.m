//
//  VISignUpViewController.m
//  Shoprise_EN
//
//  Created by mk on 4/1/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIHtmlViewController.h"

@interface VIHtmlViewController ()
{
    NSMutableDictionary *htmlArgs;
}

@end

@implementation VIHtmlViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    [self addCommentPage:.7];

    
	NSString *target = [self getContentValueWithPath:@"VIHtmlViewController"];

	//注册
	if ([target isEqualToString:Lang(@"sigeup_html")]) {
		[self addNav:nil left:NONE right:NONE];
        
        UIButton *logon = [[UIButton alloc] initWithFrame:Frm(0, self.view.h-40, self.view.w, 40)];
        logon.backgroundColor = [@"#ff4747" hexColor];
        [logon setTitle:Lang(@"ready_member_to_logon") selected:Lang(@"ready_member_to_logon")];
        [logon setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
        logon.titleLabel.font = Bold(18);
        [self.view addSubview:logon];
        [logon addTarget:self action:@selector(gotoLogin:)];
	}

	self.htmlview = [[VIHtmlLoadView alloc] initWithFrame:Frm(0, self.nav.endY, self.view.w, Left_Space(self.nav.endY)) withHtmlName:target];
	self.htmlview.delegate = self;
	[self.view addSubview:self.htmlview];
}

- (void)gotoLogin:(id)val
{
    [self popTo:@"VIWelcomeViewController"];
}

static NSString *_args;
- (void)callObjcInWebview:(VIHtmlLoadView*)webview func:(NSString *)funName args:(id)args {
	if ([funName isEqualToString:@"regederUser"]) {
		htmlArgs = [self.htmlview getFormValus];
		[VINet post:@"/api/Account/Register" args:htmlArgs target:self succ:@selector(regOk:) error:@selector(showErr:) inv:self.view];
	}
}

- (void)showErr:(id)value
{
    [self showAlertError:value];
}

- (void)regOk:(id)value {
    NSMutableDictionary *post = [NSMutableDictionary dictionary];
    [post setValue:[htmlArgs stringValueForKey:@"UserName"] forKey:@"username"];
    [post setValue:[htmlArgs stringValueForKey:@"Password"] forKey:@"password"];
    [post setValue:@"password" forKey:@"grant_type"];
    [VINet post:@"/Token" args:post target:self succ:@selector(logonSucc:) error:@selector(logonFail:) inv:self.view];
}

- (void)logonFail:(id)value
{
    [self showAlertError:value];
    [self pushTo:@"VIMailLogonViewController"];
}

- (void)logonSucc:(id)value
{
    [[NSUserDefaults standardUserDefaults] setValue:[value jsonString] forKey:@"USER_INFO_MATION"];
    [self saveUserInfo:value];
    [self pushTo:@"VINearByViewController"];
}


@end
