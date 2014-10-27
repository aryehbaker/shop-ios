//
//  VITutorialViewController.m
//  ShopriseComm
//
//  Created by mk on 4/3/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VITutorialViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface VITutorialViewController ()
{
    UIScrollView *contentView;
}
@property(nonatomic,strong) NSArray *paths;
@end

@implementation VITutorialViewController

-(id)initWithPath:(NSArray *)paths
{
    self = [super init];
    if (self) {
        self.paths = paths;
        
        [[ NSNotificationCenter defaultCenter ] addObserver:self selector : @selector (layoutControllerSubViews) name : UIApplicationDidChangeStatusBarFrameNotification object : nil ];
        
    }
    return self;
}

-(void)layoutControllerSubViews
{
    [UIView animateWithDuration:.2 animations:^{
          [[self.view button4Tag:10086] setY:self.view.h-40];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
   
    contentView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.backgroundColor = [UIColor clearColor];
    contentView.pagingEnabled = YES;
    contentView.delegate = self;
    int statrX = 0;
    
    for (NSString *path in self.paths) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:Frm(statrX,0, 320, 568)];
        image.image = [path image];
        [contentView addSubview:image];
        UIView *top = [[UIView alloc] initWithFrame:image.frame];
        top.backgroundColor = [@"#000000" hexColorAlpha:.4];
        [contentView addSubview:top];
        statrX+= 320;
    }
    [contentView setContentSize:CGSizeMake(320*self.paths.count, self.view.h)];
    [self.view addSubview:contentView];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:Frm((320-16*4-24)/2, self.view.h - 130, 16, 16)];
    [btn setImage:[@"normal.png" image] forState:UIControlStateNormal];
    [btn setImage:[@"hightlight.png" image] forState:UIControlStateSelected];
    btn.tag = 100;
    btn.userInteractionEnabled = NO;
    btn.selected = YES;
    [self.view addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:Frm(btn.endX+8, btn.Y, 16, 16)];
    [btn setImage:[@"normal.png" image] forState:UIControlStateNormal];
    btn.tag = 101;
    btn.userInteractionEnabled = NO;
    [btn setImage:[@"hightlight.png" image] forState:UIControlStateSelected];
    [self.view addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:Frm(btn.endX+8, btn.Y, 16, 16)];
    [btn setImage:[@"normal.png" image] forState:UIControlStateNormal];
    btn.tag = 102;
    btn.userInteractionEnabled = NO;
    [btn setImage:[@"hightlight.png" image] forState:UIControlStateSelected];
    [self.view addSubview:btn];
    
    btn = [[UIButton alloc] initWithFrame:Frm(btn.endX+8, btn.Y, 16, 16)];
    [btn setImage:[@"normal.png" image] forState:UIControlStateNormal];
    btn.tag = 103;
    btn.userInteractionEnabled = NO;
    [btn setImage:[@"hightlight.png" image] forState:UIControlStateSelected];
    [self.view addSubview:btn];

    
    UIButton *skip = [[UIButton alloc] initWithFrame:Frm(110, self.view.h-110, 100, 40)];
    [skip setTitle:Lang(@"index_skip") hightTitle:Lang(@"index_skip")];
    skip.titleLabel.font = FontPekanBold(18);
    [skip setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    [self.view addSubview:skip];
    [skip addTarget:self action:@selector(skipNow:)];
    
    UIButton *reg = [[UIButton alloc] initWithFrame:Frm(0, self.view.h-40, 320, 40)];
    [reg setBackgroundcolorByHex:@"#FD2D38"];
    reg.tag = 10086;
    reg.titleLabel.font = FontPekanBold(19);
    [reg setTitle:Lang(@"index_signup_signin") hightTitle:Lang(@"index_signup_signin")];
    [reg setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    [self.view addSubview:reg];
    [reg addTarget:self action:@selector(loginVe:)];
   
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.view button4Tag:100].selected = NO;
    [self.view button4Tag:101].selected = NO;
    [self.view button4Tag:102].selected = NO;
    [self.view button4Tag:103].selected = NO;
    
    [self.view button4Tag:100+ ((int)scrollView.contentOffset.x / scrollView.w) ].selected = YES;
}

-(void)loginVe:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userHasUsed"];
    [UIView animateWithDuration:.38 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

-(void)skipNow:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"userHasUsed"];
    [UIView animateWithDuration:.38 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)addView:(UIView *)view page:(int)page
{
    [view setX:view.x + page * self.view.w];
    [contentView addSubview:view];
}

@end
