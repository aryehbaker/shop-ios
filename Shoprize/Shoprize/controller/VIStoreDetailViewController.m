//
//  VIStoreDetailViewController.m
//  ShopriseComm
//
//  Created by mk on 4/10/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIStoreDetailViewController.h"
#import "CMPopTipView.h"
#import "KUtils.h"
#import "VINavMapViewController.h"

@interface VIStoreDetailViewController ()
{
    NSDictionary *storeInfo;
    NSMutableArray *extraProms;
}

@end

@implementation VIStoreDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    storeInfo = [self getContentValueWithPath:@"VIStoreDetailViewController"];
    
    //这个是从推送跳入的
    NSDictionary *dctfp = [self getContentValueWithPath:@"push_in"];
    if (dctfp!= nil) {
        NSString *storeID = [dctfp stringValueForKey:@"Udid"];
        Store *st= [[iSQLiteHelper getDefaultHelper] searchSingle:[Store class] where:@{@"AddressId": storeID} orderBy:@"StoreId"];
        storeInfo = [st toDictionary];
    }

    [self addNav:[storeInfo stringValueForKey:@"StoreName"] left:BACK right:NONE];
    
    UIButton *small = [[UIButton alloc] initWithFrame:Frm(130, self.nav.endY-8, 60, 20)];
    small.layer.cornerRadius = 10;
    small.backgroundColor = [@"#5E5E5E" hexColor];
    [small setTitle:Lang(@"store_info") forState:UIControlStateNormal];
    small.titleLabel.font = Bold(14);
    [small addTarget:self action:@selector(showTime:)];
    [self.view addSubview:small];

    UIScrollView *scrll = [[UIScrollView alloc] initWithFrame:Frm(0,small.endY+10, 320, self.view.h - small.endY-10)];
    
    NSString *addid = [storeInfo objectForKey:@"AddressId"];
    extraProms = [[iSQLiteHelper getDefaultHelper] searchModels:[MobiPromo class] where:@{@"Type": @"Deal",@"AddressId":addid}];
    
    if (extraProms.count == 0) {
        UIImageView *img = [@"no_promos.png" imageViewForImgSizeAtX:0 Y:80];
        [scrll addSubview:img];
        UILabel *nop  = [UILabel initWithFrame:Frm(0, img.endY+5, 320, 40) color:@"#8F8F8F" font:Bold(16) align:CENTER];
        nop.text = Lang(@"no_promos");
        [scrll addSubview:nop];
    }
    
    int height = 0;
    if (extraProms.count > 0) {
        MobiPromo *prom = [extraProms objectAtIndex:0];
        UIView *bigone  = [self loadXib:@"UI.xib" withTag:15000];
        bigone.tag = 0;
        
        [bigone egoimageView4Tag:15001].placeholderImage = [@"no_pic.png" image];
        [bigone egoimageView4Tag:15001].imageURL = [NSURL URLWithString:[prom defPicture]];
        [bigone label4Tag:15002].text = [prom.Offer killQute];
        [bigone label4Tag:15003].text = Fmt(@"%d",prom.MarkedCount) ;
        bigone.tag = 0;
        [bigone addTapTarget:self action:@selector(seeDetail:)];
        [scrll addSubview:bigone];
        height = bigone.endY;
    }
    
    if (extraProms.count > 1 ) {
        int rows = (int)ceilf((extraProms.count-1)/2.0);
        for(int i=0;i<rows;i++)  {
            int index = 1+ i * 2;
            int next = index+1;
            
            MobiPromo *left = [extraProms objectAtIndex:index];
            UIView *bigone  = [self loadXib:@"UI.xib" withTag:16000];
            
            [bigone egoimageView4Tag:16001].placeholderImage = [@"no_pic.png" image];
            
            [bigone egoimageView4Tag:16001].imageURL = [NSURL URLWithString:left.defPicture];
            [bigone label4Tag:16002].text = left.Offer;
            [bigone label4Tag:16003].text = Fmt(@"%d",left.MarkedCount) ;

            [bigone addTapTarget:self action:@selector(seeDetail:)];
            bigone.tag = index;
            [bigone setX:13.3 andY:height+5];
            
            [scrll addSubview:bigone];
            
            if (next+1 < extraProms.count) {
                MobiPromo *right = [extraProms objectAtIndex:next];
                UIView *bigone2  = [self loadXib:@"UI.xib" withTag:16000];
                [bigone2 egoimageView4Tag:16001].placeholderImage = [@"no_pic.png" image];
                [bigone2 egoimageView4Tag:16001].imageURL = [NSURL URLWithString:right.defPicture];
                [bigone2 label4Tag:16002].text = right.Offer;
                [bigone2 label4Tag:16003].text = Fmt(@"%d",[right MarkedCount]) ;
                [scrll addSubview:bigone2];
                [bigone2 addTapTarget:self action:@selector(seeDetail:)];
                bigone2.tag = next;
                [bigone2 setX:bigone.endX+13.3 andY:height+5];
                
            }
            height = bigone.endY;
        }
    }
    
    [[iSQLiteHelper getDefaultHelper] rowCount:[MobiPromo class] where:@{@"StoreHasSuprise": @"1",@"AddressId":addid} callback:^(int rowCount) {
        if (rowCount>0) {
            UIImageView *view = [@"suprise_buge.png" imageViewForImgSizeAtX:self.view.w-31-16 Y:6];
            [[[self.nav subviews] objectAtIndex:0] addSubview:view];
            view.userInteractionEnabled = YES;
            [view addTapTarget:self action:@selector(showInfoMessage:)];
        }
    }];
    
    scrll.showsHorizontalScrollIndicator = NO;
    scrll.showsVerticalScrollIndicator = NO;
    [scrll setContentSize:CGSizeMake(320,height<scrll.h ? scrll.h : height+10)];
    [self.view addSubview:scrll];
    
    //notifycation
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_add_current_track_" object:
     @{@"Type": @"Store",@"ReferenceId": addid ,@"StoreAddressId":addid}];
}

- (void)seeDetail:(UITapGestureRecognizer*)tap
{
    long index = tap.view.tag;
    MobiPromo *mob = [extraProms objectAtIndex:index];
    [self pushTo:@"VIDealsDetailViewController" data:[mob toDictionary]];
}

- (void)showTime:(id)sender
{
    // TODO 显示数组信息的第一个
    NSString *oh = [storeInfo stringValueForKey:@"OpenHours" defaultValue:@"none"];
    NSString *add = [storeInfo stringValueForKey:@"Address" defaultValue:@"none"];
    NSString *tel = [storeInfo stringValueForKey:@"Phone" defaultValue:@"none"];
    UIView *load =  [KUtils makeDialog:oh addr:add tel:tel];
    
    load.backgroundColor = [UIColor clearColor];
    
    CMPopTipView *pop = [[CMPopTipView alloc] initWithCustomView:load];
    pop.backgroundColor =[@"#ffffff" hexColorAlpha:.9];
    pop.tag = -100;
    pop.hasShadow = YES;
    pop.has3DStyle = NO;
    pop.borderColor = [@"#B1B1B1" hexColor];
    pop.cornerRadius = 1;
    
    [[load button4Tag:4010] addTarget:self action:@selector(Mapit:)];
    
    [pop presentPointingAtView:self.nav_title inView:self.view animated:YES];
  
    UIButton *nav = [load button4Tag:4010];
    nav.layer.cornerRadius = nav.w /2 ;
    [nav setTitle:Lang(@"navi_title") selected:Lang(@"navi_title")];
    [nav setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
    nav.titleLabel.font = Bold(18);
    
}

-(void)Mapit:(UIButton *)btn
{
    VINavMapViewController *map = [[VINavMapViewController alloc] init];
    map.destination = [[CLLocation alloc] initWithLatitude:[storeInfo doubleValueForKey:@"Lat"] longitude:[storeInfo doubleValueForKey:@"Lon"]];
    map.title = [storeInfo  stringValueForKey:@"StoreName"];
    map.subtitle = [storeInfo  stringValueForKey:@"Address"];
    [self push:map];
}


@end
