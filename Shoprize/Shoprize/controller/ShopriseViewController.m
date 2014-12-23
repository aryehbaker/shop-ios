//
//  ShopriseViewController.m
//  ShopriseComm
//
//  Created by mk on 4/1/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "ShopriseViewController.h"
#import "VIDealsDetailViewController.h"
#import "CMPopTipView.h"
#import "KUtils.h"


@interface ShopriseViewController ()<UITextFieldDelegate>
{
    UIView *searchView;
    
}
@property(nonatomic) BOOL lightContent;
@end

@implementation ShopriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [@"#DADADA" hexColor];
    
#ifdef __IPHONE_7_0
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#endif
    
}

- (id)AppDelegate {
     return [UIApplication sharedApplication].delegate;
}

- (void)whenSearchKey:(NSString *)search {
    
}

- (void)addNav:(NSString *)title left:(BarItem)left right:(BarItem)right
{
    int y = [UIDevice isGe:7] ? 20 : 0;
    self.nav = [[UIView alloc] initWithFrame:Frm(0, 0, self.view.w, [UIDevice isGe:7] ? 64 : 44)];
    self.nav.backgroundColor = [UIColor clearColor];
    self.nav.tag = -99;
    UIView *tacks = [[UIView alloc] initWithFrame:Frm(0, y, self.view.w, 44)];
    if (title != nil) {
        if ([title hasPrefix:@"@"]) {
            UIImageView *imagev = [[title substringFromIndex:1] imageViewForImgSizeAtX:0 Y:0];
            [imagev setY:(44-imagev.h) /2];
            [imagev setX:(tacks.w - imagev.w)/2];
            [imagev setUserInteractionEnabled:YES];
            [tacks addSubview:imagev];
            [imagev addTapTarget:self action:@selector(doCenterIconClick:)];
        }else{
            self.nav_title = [UILabel initWithFrame:Frm(50, 0, 220, 44) color:self.lightContent ? @"#ffffff" :  @"#000000" font:Bold(20) align:CENTER | MIDDLE];
            self.nav_title.font = isHe ? FontB(20) : [Fonts PekanLight:20];
            self.nav_title.textAlignment = NSTextAlignmentCenter;
            [tacks addSubview:_nav_title];
            [_nav_title setUserInteractionEnabled:YES];
            _nav_title.text = title;
        }
    }

    [self.nav addSubview:tacks];

    if (left == BACK) {
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.tag = -10010;
        back.frame = Frm(10,2, 40, 40);
        [back setImage:[self.lightContent ? @"back_w.png" : @"back.png" image] forState:UIControlStateNormal];
        [back setImageEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
        [back addTarget:self action:@selector(navpop:)];
        [tacks addSubview:back];
        self.leftOne = back;
    }
    
    if (left == SEARCH) {
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.frame = Frm(10, 2, 40, 40);
        back.tag = -10;
        [back setImage:[@"search_meun.png" image] forState:UIControlStateNormal];
        [back setImageEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
        [back addTarget:self action:@selector(showSearchFiled:)];
        [tacks addSubview:back];
        self.leftOne = back;
    }
    if (left == Around) {
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.frame = Frm(10, 2, 40, 40);
        back.tag = -10;
        [back setImage:[@"aroundme.png" image] forState:UIControlStateNormal];
        [back setImageEdgeInsets:UIEdgeInsetsMake(4, 3, 4, 3)];
        [tacks addSubview:back];
        self.leftOne = back;
    }
    
    if (right == MENU) {
        UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
        menu.frame = Frm(self.view.w-50, 2, 40, 40);
        [menu setImage:[ self.lightContent ? @"menu_w.png" : @"menu.png" image] forState:UIControlStateNormal];
        [menu addTarget:self action:@selector(showMenu:)];
        [tacks addSubview:menu];
    }
    
    if (left == MapIt) {
        UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
        menu.frame = Frm(10, 2, 40, 40);
        [menu setImage:[@"mapit.png" image] forState:UIControlStateNormal];
        [tacks addSubview:menu];
        self.leftOne = menu;
    }
    
    if (right == Done) {
        UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
        menu.frame = Frm(self.view.w-50, 2, 40, 40);
        [menu setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
        [menu setImage:[@"checked_right_check.png" image] forState:UIControlStateNormal];
        [tacks addSubview:menu];
        self.rightOne = menu;
    }
    
    if (right == Route) {
        UIButton *menu = [UIButton buttonWithType:UIButtonTypeCustom];
        menu.frame = Frm(self.view.w-50, 2, 40, 40);
        [menu setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
        [menu setImage:[@"showrote.png" image] forState:UIControlStateNormal];
        [tacks addSubview:menu];
        self.rightOne = menu;
    }
    
    
    [self.view addSubview:self.nav];
}

-(void)navpop:(UIButton *)btn
{
    NSArray *ctrls = [self.navigationController viewControllers];
    if (ctrls.count > 2 && [[ctrls lastObject] isKindOfClass:[VIDealsDetailViewController class]]
        &&
        [[ctrls objectAtIndex:ctrls.count-2] isKindOfClass:[VIDealsDetailViewController class]])
    {
        for (long index=ctrls.count-1;index>=0;index--)
        {
            UIViewController *target = [ctrls objectAtIndex:index];
            UIViewController *preOne = nil;
            if (index>1) {
                preOne = [ctrls objectAtIndex:index-1];
            }
            if (preOne!=nil && [preOne isKindOfClass:[VIDealsDetailViewController class]]) {
                continue;
            }
            [self.navigationController popToViewController:target animated:NO];
            break;
        }
    }else{
        [self pop];
    }
}

- (void)showSearchFiled:(UIButton *)sender
{
    if(searchView!=nil){
        [UIView animateWithDuration:.38 animations:^{
            searchView.y = -searchView.h;
            searchView.alpha = 0;
            self.nav_title.alpha = 1;
        } completion:^(BOOL finished) {
            if (finished) {
                [searchView removeFromSuperview];
                searchView = nil;
            }
        }];
        [self whenSearchKey:nil];
    }else{
        searchView = [self loadXib:@"UI.xib" withTag:17000];
        searchView.backgroundColor = sender == nil? [UIColor clearColor] : [@"#DADADA" hexColor];
        searchView.alpha = 0;
        UITextField *t = [searchView textfiled4Tag:17001];
        t.placeholder = Lang(@"search_by_key");
        if (sender==nil) {
            t.textColor = [@"#ffffff" hexColor];
        }else{
            t.textColor = [@"#1C1C1C" hexColor];
        }
        t.textAlignment = Align;
        t.returnKeyType = UIReturnKeyDone;
        t.delegate = self;
        [t becomeFirstResponder];
        
        [searchView setX:sender == nil? 50 : self.nav_title.x andY:-searchView.h];
        [[[self.nav subviews] objectAtIndex:0] addSubview:searchView];
        [UIView animateWithDuration:.38 animations:^{
            searchView.y = self.nav_title.y;
            searchView.alpha = 1;
            self.nav_title.alpha = 0;
        } completion:^(BOOL finished) {
           
        }];
    }
}

- (void)hideSearchFiled:(UIButton *)sender
{
    [UIView animateWithDuration:.38 animations:^{
        searchView.y = -searchView.h;
        searchView.alpha = 0;
        self.nav_title.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [searchView removeFromSuperview];
            searchView = nil;
        }
    }];
    [self whenSearchKey:nil];
}

- (BOOL)isSearchFiledShow
{
    return searchView != nil;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self whenSearchKey:nil];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location==0 && [string isEqualToString:@""]) {
        [self whenSearchKey:nil];
    }else if(range.location!=0 && range.length!=0 && [string isEqualToString:@""]){
        [self whenSearchKey:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    }else{
        [self whenSearchKey:Fmt(@"%@%@",textField.text,string) ];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)setLightContent{
    self.lightContent = YES;
}

- (void)showAlertError:(id)value {
    if ([value isKindOfClass:[NSDictionary class]]) {
        if ([value stringValueForKey:@"Message"] != nil) {
             [VIAlertView showErrorMsg:[value stringValueForKey:@"Message"]];
        }
        if ([value stringValueForKey:@"message"] != nil) {
            [VIAlertView showErrorMsg:[value stringValueForKey:@"message"]];
        }
    }
    if ([value isKindOfClass:[NSString class]]) {
        [VIAlertView showErrorMsg:value];
    }
}

- (void)doLeftClick:(id)sender { }

- (void)doCenterIconClick:(id)sender{}

- (void)showMenu:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:_NS_NOTIFY_SHOW_MENU object:nil];
}

- (void)addCommentPage:(float)alpha{
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:Frm(0,0, self.view.w, self.view.h)];
    if (isEn) {
        image.image = [@"tor1.png" image];
    }else{
       image.image = [@"tor_1.png" image];
    }
    
    [self.view addSubview:image];
 
    UIView *v = [[UIView alloc] initWithFrame:image.frame];
    v.backgroundColor = [@"#000000" hexColorAlpha:alpha];
    [self.view addSubview:v];
    
}

- (void)showInfoMessage:(UITapGestureRecognizer *)tap
{
    UIView *inms = [[UIView alloc] initWithFrame:Frm(0, 0, 200, 130)];
    UILabel *lab = [ UILabel initWithFrame:Frm(15, 15, 170, 100) color:@"#000000" font:Bold(14) align:CENTER];
    lab.text = Lang(@"store_has_sup");    lab.numberOfLines = 0;
    [lab autoHeight];
    [inms addSubview:lab];
    
    CMPopTipView *pop = [[CMPopTipView alloc] initWithCustomView:inms];
    pop.backgroundColor =[@"#ffffff" hexColorAlpha:.9];
    pop.borderColor = [@"#B1B1B1" hexColor];
    pop.cornerRadius = 3;
    
    [pop presentPointingAtView:tap.view inView:self.view animated:YES];
}

- (BOOL)isEmpty:(id)value {
    if (value == nil) {
        return YES;
    }
    if ([Fmt(@"%@",value) isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

- (void)redeemDeail:(NSString *)dealId complete:(SEL)complete
{
    [self showConfirmWithTitle:@"" msg:[@"deal_redeem_confirm" lang] callbk:^(BOOL isOk) {
        if (isOk) {
            [VINet post:Fmt(@"/api/mobipromos/%@/redeem",dealId) args:nil target:self succ:complete error:@selector(showAlertError:) inv:self.view];
        }
    }];
}

@end

@implementation  VILabel

+(UILabel *)createLableWithFrame:(CGRect)frm color:(NSString *)color font:(UIFont *)ft align:(TxtOpt)opt
{
    return [UILabel initWithFrame:frm color:color font:ft align:opt];
}

+(UILabel *)createManyLines:(CGRect)frm color:(NSString *)color ft:(UIFont *)ft text:(NSString *)text {
    return [UILabel initManyLineWithFrame:frm color:color font:ft text:text];
}

@end
