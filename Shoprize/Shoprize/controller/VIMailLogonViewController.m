//
//  VIMailLogonViewController.m
//  ShopriseComm
//
//  Created by mk on 4/1/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIMailLogonViewController.h"
#import "VILineTextField.h"
#import "CMPopTipView.h"

@interface VIMailLogonViewController ()
{
    VILineTextField *mail;
    VILineTextField *passwd;
    
    CMPopTipView *p;
}

@end

@implementation VIMailLogonViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCommentPage:.5];
    
    [self addNav:nil left:BACK right:NONE];

    mail = [[VILineTextField alloc] initWithFrame:Frm(30, self.nav.endY+30, 260, 35) holder:Lang(@"e-mail")];
    mail.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"last_user"];
    mail.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:mail];
    
    passwd = [[VILineTextField alloc] initWithFrame:Frm(mail.x, mail.endY+15, mail.w, mail.h) holder:Lang(@"password")];
    passwd.secureTextEntry = YES;
    //passwd.text = @"MobiAdmin12";
    [self.view addSubview:passwd];
    
    UIButton *Login = [[UIButton alloc] initWithFrame:Frm(passwd.x, passwd.endY+30, passwd.w, 40)];
    [Login setTitle:Lang(@"logon") forState:UIControlStateNormal];
    [Login setBackgroundColor:[@"#FFFFFF" hexColorAlpha:.6]];
    Login.layer.borderWidth = 1;
    Login.layer.cornerRadius = 18;
    Login.layer.borderColor = [@"#8D4D4F" hexColor].CGColor;
    [Login setTitleColor:[@"#424242" hexColor]  forState:UIControlStateNormal];
    [Login addTarget:self action:@selector(showMainview:)];
    [self.view addSubview:Login];
 
    UILabel *fg = [VILabel createLableWithFrame:Frm(Login.x, Login.endY+10, Login.w, 30) color:@"#ffffff" font:FontPekanRegular(14) align:CENTER];
    fg.text = Lang(@"forgetPwd");
    fg.userInteractionEnabled = YES;
    [fg addTapTarget:self action:@selector(forgetPasswordView:)];
    [self.view addSubview:fg];
  
    UILabel *sinup  = [VILabel createLableWithFrame:Frm(0, self.view.h-40, self.view.w, 40) color:@"#FFFFFF" font:FontPekanBold(22) align:CENTER];
    sinup.text = Lang(@"index_signup");
    sinup.backgroundColor = [@"#FF4745" hexColor];
    sinup.userInteractionEnabled = YES;
    [sinup addTapTarget:self action:@selector(gotoSignUp:)];
    [self.view addSubview:sinup];
    
    [self addKeyboardNotify];
    
}

static int y ;
- (void)forgetPasswordView:(UITapGestureRecognizer *)value{
    UIView *tag = value.view;
    UIView *fgv = [self loadXib:@"UI.xib" withTag:1500];
    p = [[CMPopTipView alloc] initWithCustomView:fgv];
    p.frame = Frm((self.view.w-260)/2, tag.y-135, 260, fgv.h);
    [p presentPointingAtView:tag inView:self.view animated:YES];
    y = p.Y;
    UITextField *fild = [fgv textfiled4Tag:1501];
    fild.placeholder = Lang(@"e-mail");
    fild.delegate = self;
    [fild becomeFirstResponder];
}
- (void)_keyboard_WillShow:(NSNotification *)notify withBoardFrame:(CGRect)frame showTime:(NSTimeInterval)time
{
    int endy = frame.origin.y-p.h-5;
    [UIView animateWithDuration:time animations:^{
         [p setY:endy];
    }];
}

- (void)_keyboard_WillHide:(NSNotification *)notify showTime:(NSTimeInterval)time
{
    [UIView animateWithDuration:time animations:^{
        [p setY:y];
    }];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1501) {
        [VINet post:Fmt(@"/api/account/%@/forgetpassword",textField.text) args:nil target:self succ:@selector(popOK:) error:@selector(shoMstMsg:) inv:self.view];
        //[textField resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)popOK:(id)sender
{
    [VIAlertView showInfoMsg:[@"check_mail" lang]];
    [p dismissAnimated:YES];
}

-(void)shoMstMsg:(id)shoMstMsg
{
    [VIAlertView showErrorMsg:[shoMstMsg stringValueForKey:@"Message"]];
}


-(void)gotoSignUp:(id)sender
{
    [self pushTo:@"VIHtmlViewController" data:@"sigeup.html"];
}

-(void)showMainview:(id)sender
{
    [mail resignFirstResponder];
    [passwd resignFirstResponder];
    
    NSMutableDictionary *post = [NSMutableDictionary dictionary];
    [post setValue:mail.text forKey:@"username"];
    [post setValue:passwd.text forKey:@"password"];
    [post setValue:@"password" forKey:@"grant_type"];
    [VINet post:@"/Token" args:post target:self succ:@selector(logonSucc:) error:@selector(showAlertError:) inv:self.view];
}

- (void)logonSucc:(id)value
{
    [[NSUserDefaults standardUserDefaults] setValue:mail.text forKey:@"last_user"];
    [[NSUserDefaults standardUserDefaults] setValue:[value jsonString] forKey:@"USER_INFO_MATION"];
    [self saveUserInfo:value];
    [self pushTo:@"VINearByViewController"];
}


@end
