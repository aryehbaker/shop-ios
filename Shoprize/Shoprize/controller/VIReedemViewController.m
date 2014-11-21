//
//  ReedemViewController.m
//  Shoprose
//
//  Created by vnidev on 5/29/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "VIReedemViewController.h"
#import "KUtils.h"

@interface VIReedemViewController ()
{
    UIButton *reedem;
    NSDictionary *extra;
    UIButton *delete;
    
    UIScrollView *ct;

    NSMutableArray *imagelist;
    
    UserSurprise *usersuprise;
    
    BOOL is_en_deal;
}

@end

@implementation VIReedemViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    is_en_deal = NO;
    
    extra = [self getContentValueWithPath:@"VIReedemViewController"];
    
    [self addNav:[extra stringValueForKey:@"StoreName"] left:BACK right:NONE];
    
    ct = [[UIScrollView alloc] initWithFrame:Frm(0, self.nav.endY, self.view.w, Space(self.nav.endY) - 40)];
    ct.backgroundColor = [UIColor clearColor];
    
    NSString *ctx = [[extra stringValueForKey:@"Offer"] killQute];
    UILabel *title = [UILabel initManyLineWithFrame:Frm(10, 20, self.view.w-20, 20) color:@"#252525" font:Bold(18) text:ctx];
    title.text = ctx;
    title.textAlignment = Align;
    
    [ct addSubview:title];
    
    imagelist = [NSMutableArray array];
    
    NSString *mobiid = [extra stringValueForKey:@"MobiPromoId"];
    
    is_en_deal = [[extra stringValueForKey:@"resptype" defaultValue:@""] isEqualToString:@"RESPDEAL"];
    
    NSMutableArray *itms = [NSMutableArray array];
    
    if (!is_en_deal) {
        LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
        NSMutableArray *pics = [helper searchModels:[Picture class] where:@{@"MobiPromoId":mobiid}];
        for (Picture *p in pics) {
            VIAutoPlayItem *it = [[VIAutoPlayItem alloc] initWithURL:p.PictureUrl andValue:nil];
            it.placeImage = [@"no_pic.png" image];
            [itms addObject:it];
            [imagelist addObject:[NSURL URLWithString:p.PictureUrl]];
        }
        NSArray *sups = [[iSQLiteHelper getDefaultHelper] searchModels:[UserSurprise class] where:@{@"MobiPromoId":[extra stringValueForKey:@"MobiPromoId"]}];
        if (sups.count > 0) {
            usersuprise = [sups objectAtIndex:0];
        }
    }else{
        NSArray *pics = [extra arrayValueForKey:@"Pictures"];
        for (NSDictionary *p in pics) {
            VIAutoPlayItem *it = [[VIAutoPlayItem alloc] initWithURL:[p stringValueForKey:@"PictureUrl"] andValue:nil];
            it.placeImage = [@"no_pic.png" image];
            [itms addObject:it];
            [imagelist addObject:[NSURL URLWithString:[p stringValueForKey:@"PictureUrl"]]];
        }
    }
    
    UIView *container = [[UIView alloc] initWithFrame:Frm(10, title.endY+10, self.view.w-20, 200)];
    container.backgroundColor = [@"#ffffff" hexColor];
    container.layer.borderWidth = 1;
    container.layer.borderColor = [@"#B2B2B2" hexColor].CGColor;
    VIAutoPlayPageView *play = [[VIAutoPlayPageView alloc] initWithFrame:Frm(10,10, 280, 180) delegate:self focusImageItems:itms];
    [container addSubview:play];
    [ct addSubview:container];
    
    int endY = container.endY;
    
    NSString *ctx2 = [extra stringValueForKey:@"Description" defaultValue:nil];
    if (ctx2!=nil) {
        UILabel *content = [UILabel initManyLineWithFrame:Frm(20, endY+10, 280, 20) color:@"#252525" font:Regular(16) text:ctx2];
        
        content.text = ctx2;
        content.textAlignment = Align;
        [ct addSubview:content];
        
        endY = content.endY;
    }
    
    reedem = [UIButton buttonWithType:UIButtonTypeCustom];
    reedem.frame = Frm(30,endY + 15, 260, 40);
    reedem.layer.borderWidth = 1;
    reedem.backgroundColor = [@"#F0F0F0" hexColor];
    reedem.layer.cornerRadius = 20;
    reedem.layer.borderColor = [@"#9e9e9e" hexColor].CGColor;
    [reedem setTitle:Lang(@"reedem_button_text") selected:Lang(@"reedem_button_text")];
    reedem.titleLabel.font = Bold(20);
    [reedem setTitleColor:[@"#464646" hexColor] forState:UIControlStateNormal];
    [reedem addTarget:self action:@selector(reedemStart:)];
    [ct addSubview:reedem];
    
    [ct setContentSize:CGSizeMake(ct.w, reedem.endY+15)];
    ct.showsHorizontalScrollIndicator = NO;
    ct.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:ct];
    
    if ([usersuprise.ExpireTime timeIntervalSinceNow] < -24 * 60 * 60) {
        UIView *buttomView = [[UIView alloc] initWithFrame:Frm(0, ct.endY, self.view.w, 40)];
        delete = [[UIButton alloc] initWithFrame:Frm(270, 0, 35, 35)];
        [delete setImage:@"trash.png"  selectd:@"trash.png"];
        [delete addTarget:self action:@selector(removeMobiProms:)];
        [buttomView addSubview:delete];
        [self.view addSubview:buttomView];
    }else{
        [ct addH:40];
    }
    NSString *code = usersuprise.RedemptionCode;
    if (code !=nil ) {
        [self completeReedem:@{@"RedemptionCode": code}];
    }
    
    if (!is_en_deal) {
        usersuprise =[[iSQLiteHelper getDefaultHelper] searchSingle:[UserSurprise class] where:@{@"MobiPromoId":mobiid} orderBy:@"MobiPromoId"];
        if(!([[NSDate now] laterThan:usersuprise.StartTime] && [[NSDate now] earlyThan:usersuprise.ExpireTime]))
        {
            reedem.enabled = NO;
        }
        if([[NSDate now] laterThan:usersuprise.ExpireTime])
        {
            [reedem setTitle:Lang(@"activity_end") forState:UIControlStateNormal];
        }
    }
    
    //英文的Deal
    if (is_en_deal) {
        
        NSString *code = [extra stringValueForKey:@"RedemptionCode"];
        if (code!=nil && code.length>0) {
            [self completeReedem:@{@"RedemptionCode": code}];
        }
    }
}
- (void)foucusImageFrame:(VIAutoPlayPageView *)imageFrame didSelectItem:(VIAutoPlayItem *)item
{
    MHFacebookImageViewer *v = [[MHFacebookImageViewer alloc] init];
    v.imageDatasource = self;
    [v presentFromViewController:self];
}

- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer*) imageViewer
{
    return imagelist.count;
}

- (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer*) imageViewer
{
    return [imagelist objectAtIndex:index];
}

- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer*) imageViewer
{
    return [@"no_pic.png" image];
}

-(void)removeMobiProms:(UIButton *)remove
{
    [self showConfirmWithTitle:@"" msg:@"האם אתה בטוח במחיקה?" callbk:^(BOOL isOk) {
        if (isOk) {
            NSString *mid =  [extra stringValueForKey:@"_extra_/UserSurpriseId"];
            [VINet post:Fmt(@"/api/mobipromos/%@/deletesurprise",mid)  args:nil target:self succ:@selector(DeleOK:) error:@selector(showAlertError:) inv:self.view];
        }
    }];
}

-(void)DeleOK:(id)value
{
    [VIAlertView showInfoMsg:@"מחיקה הושלמה"];
    [[iSQLiteHelper getDefaultHelper] deleteToDB:usersuprise];
    [self pop];
}

- (void)reedemStart:(UIButton *)button
{
    [self showConfirmWithTitle:@"" msg:Lang(@"reedem_cfm") callbk:^(BOOL isOk) {
        if (isOk) {
            NSString *reemId = usersuprise.MobiPromoId;
            if (reemId == nil)
                reemId = [extra stringValueForKey:@"MobiPromoId"];
            [VINet post:Fmt(@"/api/mobipromos/%@/redeem",reemId) args:nil target:self succ:@selector(completeReedem:) error:@selector(showAlertError:) inv:self.view];
        }
    }];
}


- (void)completeReedem:(id)value
{
    NSString *redemCode = [value stringValueForKey:@"RedemptionCode"];
    
    [usersuprise setRedeemed:YES];
    [usersuprise setRedemptionCode:redemCode];
    
    [[iSQLiteHelper getDefaultHelper] insertOrUpdateUsingObj:usersuprise];
    
    UIView *vir = [self loadXib:@"UI.xib" withTag:13000];
    [vir label4Tag:13001].text = Lang(@"reedem_code");
    [vir label4Tag:13002].text = redemCode;
    [vir viewWithTag:13003].backgroundColor = [vir label4Tag:13002].backgroundColor;

    [vir setY:reedem.y];
        
    [reedem removeFromSuperview];
    
    [ct addSubview:vir];
    
    [ct setContentSize:CGSizeMake(ct.w, vir.endY+10)];
    
    [delete removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
