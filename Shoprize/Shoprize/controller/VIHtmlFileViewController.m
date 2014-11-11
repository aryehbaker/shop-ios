//
//  VIAboutViewController.m
//  ShopriseComm
//
//  Created by mk on 4/3/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIHtmlFileViewController.h"

@interface VIHtmlFileViewController ()

@end

@implementation VIHtmlFileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCommentPage:.6];
    
    [self setLightContent];
    [self addNav:_headTitle left:BACK right:MENU];
    
    VIHtmlLoadView *htmlview = [[VIHtmlLoadView alloc] initWithFrame:Frm(0, self.nav.endY,self.view.w,Left_Space(self.nav.endY)) withHtmlName:_htmlFile];
    htmlview.delegate = self;
    [self.view addSubview:htmlview];
    
//    delete
}

- (void)callObjcInWebview:(VIHtmlLoadView*)webview func:(NSString *)funName args:(id)args
{
    if ([funName isEqualToString:@"addNew"]) {
        NSMutableDictionary *p = [NSMutableDictionary dictionary];
        [p setValue:[VINet info:FName] forKey:@"firstname"];
        [p setValue:[VINet info:LName] forKey:@"lastname"];
        [p setValue:[VINet info:Phone] forKey:@"phone"];
        [p setValue:[VINet info:Mail] forKey:@"email"];
        [p setValue:args forKey:@"comments"];
        [VINet post:@"/api/Feedbacks" args:p target:self succ:@selector(postComplete:) error:@selector(showAlertError:) inv:self.view];
    }
    if ([funName isEqualToString:@"contactUs"]) {
        VIHtmlFileViewController *us = [[VIHtmlFileViewController alloc] init];
        us.htmlFile = Lang(@"ctct_us_file");
        us.headTitle = Lang(@"ctct_us_title") ;
        [self push:us];
    }
}

- (void)postComplete:(id)value
{
    [VIAlertView showInfoMsg:Lang(@"thx_feed_back")];
    [self pop:YES];
    
    //[self showAlertError:values];
}

@end
