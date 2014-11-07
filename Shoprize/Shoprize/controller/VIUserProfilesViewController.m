//
//  VIUserProfilesViewController.m
//  Shoprose
//
//  Created by vnidev on 5/28/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "VIUserProfilesViewController.h"
#import "CMPopTipView.h"
#import "VIHtmlFileViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>

@interface VIUserProfilesViewController ()
{
    UIScrollView *formView;
    CGRect initFrm;
    
    CMPopTipView *p;
    
    NSDictionary *dict;
    
    UIView *full;
    UIDatePicker *pick;
}

@end

@implementation VIUserProfilesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCommentPage:.6];
    [self setLightContent];
    [self addNav:nil left:BACK right:MENU];
    formView = [[UIScrollView alloc] initWithFrame:Frm(0, self.nav.endY, 320, Space(self.nav.endY))];
    formView.showsVerticalScrollIndicator = NO;
    formView.showsHorizontalScrollIndicator = NO;
    
    initFrm = formView.frame;
    UIView *view  = [self loadXib:@"UI.xib" withTag:10000];
    
    [[view textfiled4Tag:10001] setEnabled:NO];
    [view textfiled4Tag:10001].text = [VINet info:Mail];
   
    [view textfiled4Tag:10002].text = [VINet info:FName];
    [view textfiled4Tag:10002].placeholder = Lang(@"fm_FirstName");
    [[view textfiled4Tag:10002] setValue:[@"#FBFDFB" hexColor] forKeyPath:@"_placeholderLabel.textColor"];//修改颜色
    
    [view textfiled4Tag:10003].text = [VINet info:LName];
    [view textfiled4Tag:10003].placeholder = Lang(@"fm_LastName");
    [[view textfiled4Tag:10003] setValue:[@"#FBFDFB" hexColor] forKeyPath:@"_placeholderLabel.textColor"];//修改颜色
    
    [view textfiled4Tag:10004].text = [VINet info:Phone];
    [view textfiled4Tag:10004].placeholder = Lang(@"fm_Phone");
    [[view textfiled4Tag:10004] setValue:[@"#FBFDFB" hexColor] forKeyPath:@"_placeholderLabel.textColor"];//修改颜色
    
    
    NSString *m = [VINet info:Kbirth];
    if (![m isEqualToString:@""]) {
        NSArray *m2 = [m componentsSeparatedByString:@" "];
        m = [m2 objectAtIndex:0];
        if ([m hasString:@"-"]) {
            m  = [[m parse:@"yyyy-MM-dd"] format:@"dd/MM/yyyy"];
        }else{
            m  = [[m parse:@"MM/dd/yyyy"] format:@"dd/MM/yyyy"];
        }
    }
    
    [view textfiled4Tag:10005].text = m ;
    [view textfiled4Tag:10005].placeholder = Lang(@"fm_Brith");
    [[view textfiled4Tag:10005] setValue:[@"#FBFDFB" hexColor] forKeyPath:@"_placeholderLabel.textColor"];//修改颜色

    [view textfiled4Tag:10010].placeholder = Lang(@"fm_gender");
    [[view textfiled4Tag:10010] setValue:[@"#FBFDFB" hexColor] forKeyPath:@"_placeholderLabel.textColor"];//修改颜色
    [[view textfiled4Tag:10010] setText:[VINet info:Sex]];

    
    [formView addSubview:view];
    [formView setContentSize:CGSizeMake(320, view.h)];
    [self renderView];
    [self.view addSubview:formView];
    [self addKeyboardNotify];
    
}

- (void)_keyboard_WillHide:(NSNotification *)notify showTime:(NSTimeInterval)time{
    [UIView animateWithDuration:time animations:^{
        formView.frame = initFrm;
    }];
}

-(void)_keyboard_WillShow:(NSNotification *)notify withBoardFrame:(CGRect)frame showTime:(NSTimeInterval)time{
    [UIView animateWithDuration:time animations:^{
        [formView setH: initFrm.size.height - frame.size.height];
    }];
}

- (void)renderView
{
    UITextField *email = [formView textfiled4Tag:10001];
    email.placeholder = Lang(@"fm_email");
    
    UITextField *fisrtname = [formView textfiled4Tag:10002];
    fisrtname.placeholder = Lang(@"fm_FirstName");
    UITextField *lasttname = [formView textfiled4Tag:10003];
    lasttname.placeholder = Lang(@"fm_LastName");
    UITextField *phonenum = [formView textfiled4Tag:10004];
    phonenum.placeholder = Lang(@"fm_Phone");
    UITextField *birth = [formView textfiled4Tag:10005];
    birth.placeholder = Lang(@"fm_Brith");
    UITextField *gemder = [formView textfiled4Tag:10010];
    gemder.placeholder = Lang(@"fm_gender");
    
    email.textAlignment = Align;
    fisrtname.textAlignment = Align;
    lasttname.textAlignment = Align;
    phonenum.textAlignment = Align;
    birth.textAlignment = Align;
    gemder.textAlignment = Align;
    
    email.delegate = self;
    fisrtname.delegate = self;
    lasttname.delegate = self;
    phonenum.delegate = self;
    birth.delegate = self;
    gemder.delegate = self;
    
    UIButton *saveInfo = [formView button4Tag:10006];
    saveInfo.layer.cornerRadius = saveInfo.h / 2;
    [saveInfo setTitle:Lang(@"save_user_info") selected:Lang(@"save_user_info")];
    [saveInfo addTarget:self action:@selector(updateInfo:)];
    
    UIButton *changepwd = [formView button4Tag:10007];
    changepwd.layer.cornerRadius = changepwd.h / 2;
    [changepwd addTarget:self action:@selector(showChgpwdUI:)];
    [changepwd setTitle:Lang(@"chg_user_passwd") selected:Lang(@"chg_user_passwd")];
    
    UIButton *logout = [formView button4Tag:10008];
    [logout setHidden:YES];
    logout.layer.borderWidth = 1;
    [logout addTarget:self action:@selector(showlogout:)];
    logout.layer.cornerRadius = changepwd.h / 2;
    logout.layer.borderColor = [@"#995859" hexColor].CGColor;
    logout.backgroundColor = [@"#ffffff" hexColorAlpha:.4];
    [logout setTitle:Lang(@"user_logout") selected:Lang(@"user_logout")];
    
    UIButton *delet = [formView button4Tag:10009];
    [delet setTitle:Lang(@"del_user_accoutn") selected:Lang(@"del_user_accoutn")];
    [delet addTarget:self action:@selector(showDeleteView:)];
}

- (void)updateInfo:(UIButton *)btn
{
    UITextField *fisrtname = [formView textfiled4Tag:10002];
    UITextField *lasttname = [formView textfiled4Tag:10003];
    UITextField *phonenum = [formView textfiled4Tag:10004];
    UITextField *birth = [formView textfiled4Tag:10005];
    UITextField *gender = [formView textfiled4Tag:10010];
    
    NSString *msg = Fmt(@"%%@ %@",isHe ? @" עליך להזין " : @"Required");
    
    if ([fisrtname isEmptyValue]) {
        [VIAlertView showErrorMsg:Fmt(msg,Lang(@"fm_FirstName"))]; return;
    }
    if ([lasttname isEmptyValue]) {
        [VIAlertView showErrorMsg:Fmt(msg,Lang(@"fm_LastName"))]; return;
    }
    if ([phonenum isEmptyValue]) {
        [VIAlertView showErrorMsg:Fmt(msg,Lang(@"fm_Phone"))]; return;
    }
    if ([birth isEmptyValue]) {
        [VIAlertView showErrorMsg:Fmt(msg,Lang(@"fm_Brith"))]; return;
    }
    if ([gender isEmptyValue]) {
        [VIAlertView showErrorMsg:Fmt(msg,Lang(@"fm_gender"))]; return;
    }
    
    NSMutableDictionary *mt = [NSMutableDictionary dictionary];
    [mt setValue:fisrtname.text forKey:@"FirstName"];
    [mt setValue:lasttname.text forKey:@"LastName"];
    [mt setValue:gender.text forKey:@"Gender"];
    [mt setValue:phonenum.text forKey:@"Phone"];
    NSString *data = [[birth.text parse:@"dd/MM/yyyy"] formatDefalut];
    if (data != nil) {
         [mt setValue:data forKey:@"BirthDate"];
    } else{
         [mt setValue:@"01/01/1970" forKey:@"BirthDate"];
    }
    
    dict = mt;
    
    [VINet post:@"/api/Account/Profile" args:dict target:self succ:@selector(updateInfoComplete:) error:@selector(showAlertError:) inv:self.view];
}

- (void)updateInfoComplete:(id)val
{
    NSMutableDictionary *pm = [[self getLoginInfo] mutableCopy];
    [pm setValue:[dict stringValueForKey:@"FirstName"] forKey:@"firstName"];
    [pm setValue:[dict stringValueForKey:@"LastName"] forKey:@"lastName"];
    [pm setValue:[dict stringValueForKey:@"Phone"] forKey:@"phone"];
    [pm setValue:[dict stringValueForKey:@"BirthDate" ] forKey:@"birthday"];
    [pm setValue:[dict stringValueForKey:@"Gender"] forKey:@"gender"];
    [self saveUserInfo:pm];
    
    [[NSUserDefaults standardUserDefaults] setValue:[pm jsonString] forKey:@"USER_INFO_MATION"];
    
    [VIAlertView showInfoMsg:Lang(@"update_complte")];
}

- (void)showChgpwdUI:(UIButton*)click{
    [self textFieldShouldReturn:nil];
    
    UIView *passwd = [self loadXib:@"UI.xib" withTag:11000];
    
    [passwd textfiled4Tag:11001].placeholder = Lang(@"form_passwd");
    [[passwd textfiled4Tag:11001] setValue:[@"#1B1B1B" hexColor] forKeyPath:@"_placeholderLabel.textColor"];//修改颜色
    [passwd textfiled4Tag:11001].delegate = self;
    
    [passwd textfiled4Tag:11002].placeholder = Lang(@"form_newPasswd");
    [[passwd textfiled4Tag:11002] setValue:[@"#1B1B1B" hexColor] forKeyPath:@"_placeholderLabel.textColor"];//修改颜色
    [passwd textfiled4Tag:11002].delegate = self;
    
    [passwd textfiled4Tag:11003].placeholder = Lang(@"form_configmpwd");
    [[passwd textfiled4Tag:11003] setValue:[@"#1B1B1B" hexColor] forKeyPath:@"_placeholderLabel.textColor"];//修改颜色
    [passwd textfiled4Tag:11003].delegate = self;
    
    UIButton *btn = [passwd button4Tag:11004];
    btn.layer.cornerRadius = btn.h/2;
    [btn setTitle:Lang(@"form_modify_comit") selected:Lang(@"form_modify_comit")];
    [btn addTarget:self action:@selector(submitPassword:)];
    
    passwd.backgroundColor = [UIColor clearColor];
    
    UIButton *fl = [[UIButton alloc] initWithFrame:Frm(0, 0, passwd.w, passwd.H)];
    [fl addSubview:passwd];
    
    p = [[CMPopTipView alloc] initWithCustomView:fl];
    [p presentPointingAtView:click inView:self.view animated:YES];
}

- (void)submitPassword:(id)sender
{
    UITextField *old = [self.view textfiled4Tag:11001];
    UITextField *new1 = [self.view textfiled4Tag:11002];
    UITextField *new2 = [self.view textfiled4Tag:11003];
    if (![new1.text isEqual:new2.text]) {
        [VIAlertView showErrorMsg:Lang(@"form_passwd_not_same")];
        return;
    }
    
    [old resignFirstResponder];
    [new1 resignFirstResponder];
    [new2 resignFirstResponder];
    
    [VINet  post:@"/api/Account/ChangePassword" args:
        @{@"OldPassword": old.text,@"NewPassword":new1.text,@"ConfirmPassword":new2.text}
    target:self succ:@selector(updateOk:) error:@selector(showAlertError:) inv:self.view];
    
}

-(void)updateOk:(id)value
{
    [VIAlertView showInfoMsg:Lang(@"form_update_complete")];
    [p dismissAnimated:YES];
}

- (void)showDeleteView:(UIButton*)click
{
    [self textFieldShouldReturn:nil];
    UIView *cts = [[UIView alloc] initWithFrame:Frm(0, 0, 270, 0)];
    UILabel *title = [VILabel createLableWithFrame:Frm(15, 15, 240, 25) color:@"#1C1C1C" font:Black(18) align:RIGHT];
    title.text = Lang(@"delete_accout_title");
    [cts addSubview:title];
    
    NSString *tx = Lang(@"delete_accout_ctnt");
    UILabel *ctx = [VILabel createManyLines:Frm(15, title.endY, 240, 0) color:@"#323232" ft:Regular(15) text:tx];
    ctx.textAlignment = Align;
    ctx.text = tx;
    [cts addSubview:ctx];
    
    UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
    [dele setBackgroundcolorByHex:@"#FC494D"];
    [dele setTitle:Lang(@"delete_account_button_text") selected:Lang(@"delete_account_button_text")];
    dele.frame = Frm(45, ctx.endY+5, 80,30);
    dele.layer.cornerRadius = 15;
    dele.titleLabel.font = Bold(15);
    [dele addTarget:self action:@selector(deleteMe:)];
    [dele setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    [cts addSubview:dele];
    
    UIButton *ctsus = [UIButton buttonWithType:UIButtonTypeCustom];
    ctsus.frame = Frm(dele.endX+5,dele.y,80, 30);
    ctsus.layer.cornerRadius = 15;
    ctsus.titleLabel.font = Bold(15);
    [ctsus addTarget:self action:@selector(contaactUs:)];
    [ctsus setTitle:Lang(@"menu_sub_ctus") selected:Lang(@"menu_sub_ctus")];
    [ctsus setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    [ctsus setBackgroundcolorByHex:@"#464646"];
    [cts addSubview:ctsus];
    
    cts.backgroundColor = [UIColor clearColor];
    [cts setH:ctsus.endY+5];
    
    p = [[CMPopTipView alloc] initWithCustomView:cts];
    [p presentPointingAtView:click inView:self.view animated:YES];
}

-(void)deleteMe:(UIButton *)sender
{
    [VINet post:Fmt(@"/api/Account/%@/Delete",[VINet info:Mail]) args:nil target:self succ:@selector(logoutNow:) error:@selector(showAlertError:) inv:self.view];
}

- (void)logoutNow:(id)value
{
    [VIAlertView showInfoMsg:Lang(@"update_complte")];
    [self logoutAction];
}

-(void)contaactUs:(UIButton *)sender
{
    VIHtmlFileViewController *us = [[VIHtmlFileViewController alloc] init];
    us.htmlFile = Lang(@"ctct_us_file");
    us.headTitle = Lang(@"ctct_us_title");
    us.from = @"delete";
    [self.navigationController pushViewController:us animated:YES];
}

- (void)showlogout:(UIButton*)click
{
    [self showConfirmWithTitle:@"" msg:Lang(@"logout_confirm") callbk:^(BOOL isOk) {
        if (isOk) {
            [self logoutAction];
        }
    }];
}

- (void)logoutAction{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USER_INFO_MATION"];
    [self logout];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    for(int i=1;i<=5;i++){
        [[formView textfiled4Tag:10000+i] resignFirstResponder];
    }
    [[formView textfiled4Tag:10010] resignFirstResponder];
    
    for(int i=1;i<=3;i++){
        [[formView textfiled4Tag:11000+i] resignFirstResponder];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag == 10005)
    {
    
        NSDate *cd = [textField.text parse:@"dd/MM/yyyy"];
        full = [[UIView alloc] initWithFrame:self.view.frame];
        
        pick = [[UIDatePicker alloc] init];
        [pick setBackgroundColor:[UIColor whiteColor]];
        [pick setDatePickerMode:UIDatePickerModeDate];
        [pick setY:self.view.h - (pick.h+40)];
        [full addSubview:pick];
        [pick setDate:cd];
        UIView *buttom = [[UIView alloc] initWithFrame:Frm(0, pick.endY, pick.w, 40)];
        buttom.backgroundColor = [UIColor whiteColor];
        UIButton *l1 = [[UIButton alloc] initWithFrame:Frm(0, 0, self.view.w/3, 40) font:FontS(14) title:@"Cancel" color:@"#000000"];
        [buttom addSubview:l1];
        UIButton *l2 = [[UIButton alloc] initWithFrame:Frm(l1.endX, 0, l1.w, l1.h) font:FontS(14) title:@"Clear" color:@"#000000"];
        [buttom addSubview:l1];
        UIButton *l3 = [[UIButton alloc] initWithFrame:Frm(l2.endX, 0, l1.w, l1.h) font:FontS(14) title:@"Done" color:@"#000000"];
        [buttom addSubview:l1];
        [buttom addSubview:l2];
        [buttom addSubview:l3];
        [full addSubview:buttom];
        [l1 addTarget:self action:@selector(doCancel:)];
        [l2 addTarget:self action:@selector(doClear:)];
        [l3 addTarget:self action:@selector(doDone:)];
        
        [self.view addSubview:full];
        
        return NO;
    }
    if(textField.tag == 10010)
    {
        int h = [UIApplication sharedApplication].keyWindow.bounds.size.height;
        UIView *v = [self loadXib:@"UI.xib" withTag:1600];
        [v setFrame:Frm(0, h - v.h, self.view.w, v.h)];
        [self.view addSubview:v];
        
        NSString *tx = [self.view textfiled4Tag:10010].text;
        
        [[v button4Tag:100] addTarget:self action:@selector(closeAndChose:)];
        [[v button4Tag:100] setTitle:Lang(@"fm_boy") selected:Lang(@"fm_boy")];
        if ([Lang(@"fm_boy") isEqualToString:tx]) {
            [v button4Tag:100].selected = YES;
        }
        
        [[v button4Tag:101] addTarget:self action:@selector(closeAndChose:)];
        [[v button4Tag:101] setTitle:Lang(@"fm_girl") selected:Lang(@"fm_girl")];
        if ([Lang(@"fm_girl") isEqualToString:tx]) {
            [v button4Tag:101].selected = YES;
        }
        
        return NO;
    }
    return YES;
}

-(void)doCancel:(id)btn
{
    [UIView animateWithDuration:.38 animations:^{
        [full setY:300];
    } completion:^(BOOL finished) {
        if (finished) {
            [full removeFromSuperview];
        }
    }];
}
-(void)doClear:(id)btn
{
    [[self.view textfiled4Tag:10005] setText:@""];
    [self doCancel:btn];
}
-(void)doDone:(id)btn
{
    [[self.view textfiled4Tag:10005] setText:[[pick date] format:@"dd/MM/yyyy"]];
    [self doCancel:btn];
}

-(void)closeAndChose:(UIButton *)btn
{
    [self.view textfiled4Tag:10010].text = [@[Lang(@"fm_boy"),Lang(@"fm_girl")] objectAtIndex:btn.tag - 100];
    
    UIView *v = [self.view viewWithTag:1600];
    [UIView animateWithDuration:.38 animations:^{
        [v setY:self.view.h];
    } completion:^(BOOL finished) {
        [v removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
