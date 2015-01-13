//
//  VIMenusViewController.m
//  Shoprise_EN
//
//  Created by mk on 4/3/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIMenusViewController.h"

#import <Shoprize/REFrostedContainerViewController.h>
#import <Shoprize/REFrostedViewController.h>
#import <Shoprize/CMPopTipView.h>
#import <Shoprize/VIMenuTableViewCell.h>
#import "VINearByViewController.h"
#import "VIAppDelegate.h"
#import <VICore/VICore.h>
#import "VIAroundMeViewController.h"
#import "VIFavViewController.h"

@interface VIMenusViewController ()
@property (nonatomic,strong) NSArray *datasource;
@property (nonatomic,strong) NSArray *curentData;
@property (nonatomic,assign) NSInteger lastSelected;

@property(nonatomic,strong) UITableView *tableView;

@end

@implementation VIMenusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.datasource = [@"menu.json" jsonOfBundleFile];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:Frm(0,0, self.view.w, self.view.h)];
    image.image = [@"tor1.png" image];
    [self.view addSubview:image];
    
    UIView *v = [[UIView alloc] initWithFrame:image.frame];
    v.backgroundColor = [@"#000000" hexColorAlpha:.6];
    [self.view addSubview:v];
    
    self.tableView = [[UITableView alloc] initWithFrame:Frm(0, 0, self.view.w, self.view.h) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.curentData = self.datasource;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 220.0f)];
        EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 40, 120, 120)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.placeholderImage  = [UIImage imageNamed:@"default_header.png"];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 60.0;
        imageView.layer.borderColor = [@"#ff4747" hexColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        imageView.tag = -2000;
        imageView.imageURL = [NSURL URLWithString:[VINet info:KHead]];
        [imageView setUserInteractionEnabled:YES];
        [imageView addTapTarget:self action:@selector(changeHeadImage:)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 170,200, 40)];
        label.text = [VINet info:LName];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = -102;
        label.font = Bold(28);
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        //[label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        
        UIImageView *ct = [@"my_suprise_ct.png" imageViewForImgSizeAtX:imageView.endX+80 Y:55];
        [view addSubview:ct];
        ct.tag = -1001;
        ct.userInteractionEnabled =YES;
        UILabel *count = [VILabel createLableWithFrame:Frm(ct.endX-23, ct.y+20, 20, 20) color:@"#FFFFFF" font:Black(19) align:CENTER];
        count.text = @"0";
        count.tag = -1000;
        [view addSubview:count];
        [ct addTapTarget:self action:@selector(gotoMysuprise:)];
        
        [view addSubview:label];
        view;
    });
    [self.view addSubview:self.tableView];
}

-(void)gotoMysuprise:(UITapGestureRecognizer *)tap
{
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    [navigationController pushViewController:[[NSClassFromString(@"VIMySupriseViewController") alloc] init] animated:YES];
    [self.frostedViewController hideMenuViewController];
}

- (void)changeHeadImage:(UITapGestureRecognizer *)tap
{
    //tap.view;
    
    UIView *ctn = [[UIView alloc] initWithFrame:Frm(0, 0, 200, 60)];
    ctn.backgroundColor = [UIColor clearColor];
    
    UIButton *change = [[UIButton alloc] initWithFrame:Frm(15, 15,80, 30)];
    change.backgroundColor = [@"#676767" hexColor];
    change.layer.cornerRadius = 8;
    [change setTitle:Lang(@"head_change") selected:Lang(@"head_change")];
    [change addTarget:self action:@selector(ChangeIt:)];
    [change setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    change.titleLabel.font = Bold(16);
    [ctn addSubview:change];
    
    UIButton *delete = [[UIButton alloc] initWithFrame:Frm(change.endX+10, change.y, 80, 30)];
    delete.backgroundColor = [@"#FD2D38" hexColor];
    delete.layer.cornerRadius = 8;
    [delete setTitle:Lang(@"head_delete") selected:Lang(@"head_delete")];
    [delete addTarget:self action:@selector(DeleIt:)];
    [delete setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    delete.titleLabel.font = Bold(16);
    [ctn addSubview:delete];
    
    CMPopTipView *tip = [[CMPopTipView alloc] initWithCustomView:ctn];
    [tip setTopMargin:-5];
    [tip presentPointingAtView:tap.view inView:self.view animated:YES];
}

- (void)ChangeIt:(id)sender
{
    [self takeImage:From_Album_Camera withDel:NO complet:^(IMAGE_ACTION act, UIImage *img, id all) {
        NSDictionary *v = @{@"FormFile": img};
        [VINet post:Fmt(@"/api/pictures/User/%@",[VINet info:KUserId]) args:v target:self succ:@selector(updateInfoOK:) error:@selector(showAlertError:) inv:self.view];
        
    }];
}

- (void)updateInfoOK:(id)info
{
    [self.view egoimageView4Tag:-2000].imageURL = [NSURL URLWithString:[info stringValueForKey:@"FilePath"]];
    id values = [[[[NSUserDefaults standardUserDefaults] stringForKey:@"USER_INFO_MATION"] jsonVal] mutableCopy];
    [values setValue:[info stringValueForKey:@"FilePath"] forKey:@"pictureUrl"];
    [[NSUserDefaults standardUserDefaults] setValue:[values jsonString] forKey:@"USER_INFO_MATION"];
}

- (void)DeleIt:(id)sender
{
    [self.view egoimageView4Tag:-2000].imageURL = nil;
    NSDictionary *v = @{@"FormFile": [self.view egoimageView4Tag:-2000].placeholderImage};
    [VINet post:Fmt(@"/api/pictures/User/%@",[VINet info:KUserId]) args:v target:self succ:@selector(updateInfoOK:) error:@selector(showAlertError:) inv:self.view];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSDictionary *info = [self.curentData objectAtIndex:indexPath.row];
    
    if ([info arrayValueForKey:@"children"] != nil) {
        self.curentData = [info arrayValueForKey:@"children"];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        self.lastSelected = indexPath.row;
        return;
    }
    
    int index = [info intValueForKey:@"index"];
    if (index == 0) {
        self.curentData = self.datasource;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
    UIViewController *v = [navigationController topViewController];
    
    //Home页面
    if (index == 1) {
        NSArray *extra = [navigationController viewControllers];
        for (long i=extra.count; i>0; i--) {
            UIViewController *uv = [extra objectAtIndex:i-1];
            if ([uv isKindOfClass:[VIAroundMeViewController class]]) {
                break;
            }else{
                [navigationController popViewControllerAnimated:NO];
            }
        }
    }
    
    else if (index == 21) {
        [navigationController pushViewController:[[NSClassFromString(@"VIUserProfilesViewController") alloc] init] animated:YES];
    }
    //Intesst
    else if (index == 22) {
        [navigationController pushViewController:[[NSClassFromString(@"FavListViewController") alloc] init] animated:YES];
    }
    else if (index == 23 ) {
        UITableViewCell *tcell = [tableView cellForRowAtIndexPath:indexPath];
        UIButton *checbtn = (UIButton*)[tcell viewWithTag:400];
        checbtn.selected = !checbtn.selected;
        [[NSUserDefaults standardUserDefaults] setBool:checbtn.selected  forKey:@"_close_notification_"];
        
        VIAppDelegate *app = ((VIAppDelegate *)[UIApplication sharedApplication].delegate);
        
        if (checbtn.selected){ //选中为关
            NSArray *nocations = [[UIApplication sharedApplication] scheduledLocalNotifications];
            for (UILocalNotification *l in nocations) {
                NSString *type = [l.userInfo stringValueForKey:@"NotifyType"];
                if (type !=nil && ![type isEqualToString:@"Week"]) {
                    [[UIApplication sharedApplication] cancelLocalNotification:l];
                }
            }
            [app.locationManager stopUpdatingLocation];
            [app stopScan];
            [[NSNotificationCenter defaultCenter] postNotificationName:_TK_Turen_Off_Noti object:@[[VINet info:Mail]]];
        }else{
            [app startScan];
            [app.locationManager startUpdatingLocation];
        }
        return;
    }
    
    else if (index == 24 && ![self checkHtmlName:v htmlName:Lang(@"pliaylice_html")])
    {
        VIHtmlFileViewController *us = [[VIHtmlFileViewController alloc] init];
        us.htmlFile = Lang(@"pliaylice_html");
        us.headTitle = Lang(@"pliaylice_title");
        [navigationController pushViewController:us animated:YES];
    }
    else if (index == 25)
    {
        [self showConfirmWithTitle:@"" msg:Lang(@"logout_confirm") callbk:^(BOOL isOk) {
            if (isOk) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USER_INFO_MATION"];
                [self logout];
                [navigationController popToRootViewControllerAnimated:NO];
            }
        }];
    }
    
    else if (index == 3 && ![NSStringFromClass([v class]) isEqualToString:@"VIMySupriseViewController"])
    {
        [navigationController pushViewController:[[NSClassFromString(@"VIMySupriseViewController") alloc] init] animated:YES];
    }
    
    else if (index == 4 && ![NSStringFromClass([v class]) isEqualToString:@"VIMyStoreViewController"])
    {
        [navigationController pushViewController:[[NSClassFromString(@"VIMyStoreViewController") alloc] init] animated:YES];
    }

    else if (index == 5) {
        [navigationController pushViewController:[[NSClassFromString(@"VIMallsViewController") alloc] init] animated:YES];
    }
    
    else if (index == 6 && ![NSStringFromClass([v class]) isEqualToString:@"VIInviteViewController"]) {
        [navigationController pushViewController:[[NSClassFromString(@"VIInviteViewController") alloc] init] animated:YES];
    }
    
    else if (index == 71 &&  ![self checkHtmlName:v htmlName:Lang(@"about_us_file")])
    {
        VIHtmlFileViewController *us = [[VIHtmlFileViewController alloc] init];
        us.htmlFile = Lang(@"about_us_file");
        us.headTitle = Lang(@"about_us") ;
        [navigationController pushViewController:us animated:YES];
    }
    //联系我们
    else if (index == 72 && ![self checkHtmlName:v htmlName:Lang(@"ctct_us_file")])
    {
        VIHtmlFileViewController *us = [[VIHtmlFileViewController alloc] init];
        us.htmlFile = Lang(@"ctct_us_file");
        us.headTitle = Lang(@"ctct_us_title") ;
        [navigationController pushViewController:us animated:YES];
    }
    else if (index == 73 )
    {
        VIHtmlFileViewController *html = [[VIHtmlFileViewController alloc] init];
        html.headTitle = @"Facebook";
        html.htmlFile = @"https://www.facebook.com/ShopperOnTheGo";
        [navigationController pushViewController:html animated:YES];
    }
    
    else if (index == 74 && ![self checkHtmlName:v htmlName:Lang(@"qa_file")])
    {
        VIHtmlFileViewController *us = [[VIHtmlFileViewController alloc] init];
        us.htmlFile =  Lang(@"qa_file");
        us.headTitle = Lang(@"qa_title");
        [navigationController pushViewController:us animated:YES];
    }
    
    else if (index == 8){
        VIFavViewController *fav = [[VIFavViewController alloc] init];
        [navigationController pushViewController:fav animated:YES];
    }
    
     [self.frostedViewController hideMenuViewController];
    
}

-(BOOL)checkHtmlName:(UIViewController *)ctrl htmlName:(NSString *)html
{
    if ([ctrl isKindOfClass:[VIHtmlFileViewController class]]) {
        return [((VIHtmlFileViewController*) ctrl).htmlFile isEqualToString:html];
    }
    return NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.curentData.count;
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = [self.curentData objectAtIndex:indexPath.row];
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"r_%d_i",[info intValueForKey:@"index"]];
    VIMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[VIMenuTableViewCell alloc] initWithIdentifier:cellIdentifier];
    }
    
    [cell repaint:info];
//
//    if ([Lang(@"lang") isEqualToString:@"he"]) {
//        cell.transform = CGAffineTransformMakeRotation(180 * 0.0174532925);
//        for (UIView *subview in cell.subviews){
//            if (![subview isKindOfClass:[UIImageView class]]) {
//                subview.transform = CGAffineTransformMakeRotation(3.142857142857143);
//            }
//        }
//    }
    
    return cell;
}


@end
