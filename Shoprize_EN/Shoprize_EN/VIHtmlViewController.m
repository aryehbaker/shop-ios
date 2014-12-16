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
        if ([[htmlArgs stringValueForKey:@"FirstName"] length]==0
            || [[htmlArgs stringValueForKey:@"LastName"] length]==0
            || [[htmlArgs stringValueForKey:@"UserName"] length]==0
            )
        {
            [self showAlertError:[@"flu_filed_required" lang]];
            return;
        }
        NSString *userName = [htmlArgs stringValueForKey:@"UserName"];
        if (![userName isMatchedByRegex:@"[_a-zA-Z\\d\\-\\./]+@[_a-zA-Z\\d\\-]+(\\.[_a-zA-Z\\d\\-]+)+"])
        {
            [self showAlertError:[@"email_required" lang]];
            return;
        }
        if ([[htmlArgs stringValueForKey:@"Password"] length] < 6) {
            [self showAlertError:[@"filed_password_gt6" lang]];
            return;
        }
       
		[VINet post:@"/api/Account/Register" args:htmlArgs target:self succ:@selector(regOk:) error:@selector(showErr:) inv:self.view];
	}
}

- (void)showErr:(id)value
{
    [self showAlertError:value];
}

- (void)regOk:(id)value {

    NSString *mail = [htmlArgs stringValueForKey:@"UserName"];
    [self showAlertMsg:Fmt([@"reg_ok_msg" lang],mail) ];
    [self pop:YES];
    
//
//    NSMutableDictionary *post = [NSMutableDictionary dictionary];
//    [post setValue:[htmlArgs stringValueForKey:@"UserName"] forKey:@"username"];
//    [post setValue:[htmlArgs stringValueForKey:@"Password"] forKey:@"password"];
//    [post setValue:@"password" forKey:@"grant_type"];
//    [VINet post:@"/Token" args:post target:self succ:@selector(logonSucc:) error:@selector(logonFail:) inv:self.view];
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
