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
#import "VIDealsDetailViewController.h"
#import "Ext.h"

@interface VIStoreDetailViewController ()
{
    NSDictionary *storeInfo;
    NSMutableArray *extraProms;
    
    UIButton *btn_showTime;
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
    
    btn_showTime = [[UIButton alloc] initWithFrame:Frm(130, self.nav.endY-8, 60, 20)];
    btn_showTime.layer.cornerRadius = 10;
    btn_showTime.backgroundColor = [@"#5E5E5E" hexColor];
    [btn_showTime setTitle:Lang(@"store_info") forState:UIControlStateNormal];
    btn_showTime.titleLabel.font = Bold(14);
    [btn_showTime addTarget:self action:@selector(showTime:)];
    [self.view addSubview:btn_showTime];

    //check if the store is from favorite
    if([self isFromFavorite]){
        [VINet get:Fmt(@"/api/stores/%@/detail",[storeInfo stringValueForKey:@"AddressId"]) args:nil target:self
              succ:@selector(showMobiFromNet:) error:@selector(showMobiFail:) inv:self.view];
    }else{
        NSString *addId = [storeInfo objectForKey:@"AddressId"];
        NSMutableArray *respPromos = [[iSQLiteHelper getDefaultHelper] searchModels:[MobiPromo class] where:@{@"Type": @"Deal",@"AddressId": addId}];
        [self repaintMobis:respPromos];
        //notifycation
        [[NSNotificationCenter defaultCenter] postNotificationName:@"_add_current_track_" object:
                @{@"Type": @"Store",@"ReferenceId": addId ,@"StoreAddressId":addId}];

        [[iSQLiteHelper getDefaultHelper] rowCount:[MobiPromo class] where:@{@"StoreHasSuprise": @"1",@"AddressId":addId} callback:^(int rowCount) {
            if (rowCount>0) {
                UIImageView *view = [@"suprise_buge.png" imageViewForImgSizeAtX:self.view.w-31-16 Y:6];
                [[[self.nav subviews] objectAtIndex:0] addSubview:view];
                view.userInteractionEnabled = YES;
                [view addTapTarget:self action:@selector(showInfoMessage:)];
            }
        }];
    }
    
}

- (BOOL)isFromFavorite {
    return [storeInfo stringValueForKey:@"MallAddress"] != nil;
}

-(void)showMobiFromNet:(id)resp
{
    NSArray *Promos = [resp arrayValueForKey:@"MobiPromos"];
    NSMutableArray *filter = [Ext doEach:Promos with:^id(id itm) {
        MobiPromo *mob = [MobiPromo initWithDictionary:itm];
        if(![mob isSuprise])
            return mob;
        return nil;
    }];

    [self repaintMobis:filter];
    if (Promos.count!= filter.count) {
        UIImageView *view = [@"suprise_buge.png" imageViewForImgSizeAtX:self.view.w-31-16 Y:6];
        [[[self.nav subviews] objectAtIndex:0] addSubview:view];
        view.userInteractionEnabled = YES;
        [view addTapTarget:self action:@selector(showInfoMessage:)];
    }
}

-(void)showMobiFail:(id)resp
{
    [self repaintMobis:@[]];
}

-(void)repaintMobis:(NSArray *)resp
{
    extraProms = [resp mutableCopy];

    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:Frm(0,btn_showTime.endY+10, self.view.w, self.view.h - btn_showTime.endY-10)];

    if (extraProms.count == 0) {
        UIImageView *img = [@"no_promos.png" imageViewForImgSizeAtX:0 Y:80];
        [scroll addSubview:img];
        UILabel *nop  = [UILabel initWithFrame:Frm(0, img.endY+5, self.view.w, 40) color:@"#8F8F8F" font:Bold(16) align:CENTER];
        nop.text = Lang(@"no_promos");
        [scroll addSubview:nop];
    }
    
    int height = 0;
    if (extraProms.count > 0) {
        MobiPromo *prom = [extraProms objectAtIndex:0];
        UIView *topOne = [self loadXib:@"UI.xib" withTag:15000];
        topOne.tag = 0;
        
        [topOne egoimageView4Tag:15001].placeholderImage = [@"no_pic.png" image];
        [topOne egoimageView4Tag:15001].imageURL = [NSURL URLWithString:[prom defPicture]];
        [topOne label4Tag:15002].text = [prom.Offer killQute];
        [topOne label4Tag:15003].text = Fmt(@"%d",prom.MarkedCount) ;
        topOne.tag = 0;
        [topOne addTapTarget:self action:@selector(seeDetail:)];
        [scroll addSubview:topOne];
        height = topOne.endY;
    }
    
    if (extraProms.count > 1 ) {
        int rows = (int)ceilf((extraProms.count-1)/2.0);
        for(int i=0;i<rows;i++)  {
            int index = 1 + i * 2;
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
            
            [scroll addSubview:bigone];
            
            if (next < extraProms.count) {
                MobiPromo *right = [extraProms objectAtIndex:next];
                UIView *bigone2  = [self loadXib:@"UI.xib" withTag:16000];
                [bigone2 egoimageView4Tag:16001].placeholderImage = [@"no_pic.png" image];
                [bigone2 egoimageView4Tag:16001].imageURL = [NSURL URLWithString:right.defPicture];
                [bigone2 label4Tag:16002].text = right.Offer;
                [bigone2 label4Tag:16003].text = Fmt(@"%d",[right MarkedCount]) ;
                [scroll addSubview:bigone2];
                [bigone2 addTapTarget:self action:@selector(seeDetail:)];
                bigone2.tag = next;
                [bigone2 setX:bigone.endX+13.3 andY:height+5];
                
            }
            height = bigone.endY;
        }
    }
    
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.showsVerticalScrollIndicator = NO;
    [scroll setContentSize:CGSizeMake(self.view.w, height < scroll.h ? scroll.h : height + 10)];
    [self.view addSubview:scroll];

}

- (void)seeDetail:(UITapGestureRecognizer*)tap
{
    long index = tap.view.tag;
    MobiPromo *mob = [extraProms objectAtIndex:index];
    VIDealsDetailViewController *deal = [[VIDealsDetailViewController alloc] init];
    if([self isFromFavorite]){
        //load the data redirect
        deal.dealid = mob.MobiPromoId;
    }else{
        deal.mobipromo = mob;
    }

    [self push:deal];

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
   
    if (isEn) {
        [nav setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [nav setImage:@"ic_action_directions_white.png" selectd:@"ic_action_directions_white.png"];
    }else{
        [nav setTitle:Lang(@"navi_title") selected:Lang(@"navi_title")];
        [nav setTitleColor:[@"#ffffff" hexColor] forState:UIControlStateNormal];
        nav.titleLabel.font = Bold(18);
    }
    
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
