//
//  VIDealsDetailViewController.m
//  ShopriseComm
//
//  Created by mk on 4/8/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIDealsDetailViewController.h"
#import "VIButton.h"
#import "KUtils.h"
#import <iSQLite/iSQLite.h>
#import "Models.h"
#import "VINavMapViewController.h"

@interface VIDealsDetailViewController ()<VIAutoPlayPageDelegate>
{
    NSString *fullText;
    UIScrollView *contentView;
    
    NSMutableArray *proms;

    int totalHeight;
    
    NSMutableArray *needShown;
    
    MobiPromo *mobipromo;
    
    Store *mobiStore;
}

@end

@implementation VIDealsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.dealid!=nil) {
        [self addNav:@"Detail" left:BACK right:NONE];
        [VINet get:Fmt(@"/api/mobipromos/%@/detail",_dealid)  args:nil target:self succ:@selector(loadOK:) error:@selector(loadFail:) inv:self.view];
    }else{
        NSDictionary *promo = [self getContentValueWithPath:@"VIDealsDetailViewController"];
        mobipromo = [[MobiPromo alloc] initWithDictionary:promo error:nil];
        
        if (self.exculedId == nil) {
            self.exculedId = [NSMutableSet set];
        }
        [self.exculedId addObject:[promo stringValueForKey:@"MobiPromoId"]];
        
        NSString *title = [promo stringValueForKey:@"StoreName"];
        [self addNav:title left:BACK right:NONE];
        self.nav_title.font = Black(22);
        
        self.nav.backgroundColor = [@"#DADADA" hexColor];
        self.view.backgroundColor = self.nav.backgroundColor;
        
        [self loadComplete:promo];
        
    }
}

-(void)loadOK:(id)value {
    NSMutableDictionary *resp = [value mutableCopy];
    NSArray *addr = [resp arrayValueForKey:@"Addresses"];
    if (addr!=nil && addr.count > 0) {
        [resp addEntriesFromDictionary:[addr objectAtIndex:0]];
    }
    
    [self loadComplete:resp];
    mobipromo = [[MobiPromo alloc] initWithDictionary:resp error:nil];

    NSLog(@"%@",value);
}

-(void)loadFail:(id)value {
    [VIAlertView showErrorObj:value];
}
- (void)foucusImageFrame:(VIAutoPlayPageView *)imageFrame didSelectItem:(VIAutoPlayItem *)item
{
    MHFacebookImageViewer *v = [[MHFacebookImageViewer alloc] init];
    v.imageDatasource = self;
    [v presentFromViewController:self];
}

- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer*) imageViewer
{
    return self.imagelist.count;
}

- (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer*) imageViewer
{
    return [self.imagelist objectAtIndex:index];
}
- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer*) imageViewer
{
    return [@"no_pic.png" image];
}

- (void)loadComplete:(NSDictionary *)info
{
    self.nav_title.text = [info stringValueForKey:@"StoreName"];
    
    self.imagelist = [NSMutableArray array];
    
    contentView = [[UIScrollView alloc] initWithFrame:Frm(0, self.nav.endY, 320, Space(self.nav.endY))];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    
    NSString *mobiid = [info stringValueForKey:@"MobiPromoId"];
    
    LKDBHelper *helper = [iSQLiteHelper getDefaultHelper];
    
    BOOL fromPush = self.dealid != nil;
    
    NSMutableArray *pics;
    if (fromPush) {
        
        pics = [NSMutableArray array];
        NSArray *pc = [info arrayValueForKey:@"Pictures"];
        for (NSDictionary *d in pc) {
           [pics addObject:[[Picture alloc] initWithDictionary:d error:nil]];
        }
    }else{
        pics = [helper searchModels:[Picture class] where:@{@"MobiPromoId":mobiid}];
    }
    
    NSMutableArray *itms = [NSMutableArray array];
    for (Picture *p in pics) {
        VIAutoPlayItem *it = [[VIAutoPlayItem alloc] initWithURL:p.PictureUrl andValue:nil];
        it.placeImage = [@"no_pic.png" image];
        [itms addObject:it];
        [self.imagelist addObject:[NSURL URLWithString:p.PictureUrl]];
    }
    
    UIView *bg = [[UIView alloc] initWithFrame:Frm(10, 0, 300, 220)];
    bg.backgroundColor = [@"#ffffff" hexColor];
    
    VIAutoPlayPageView *autoPlay = [[VIAutoPlayPageView alloc] initWithFrame:Frm(8, 8, 284, 204) delegate:self focusImageItems:itms alphaBackFrame:CGRectZero];
    [autoPlay setBackgroundcolorByHex:@"#ffffff"];
    for (UIView *v in [autoPlay subviews]) {
        for (UIView *v2 in [v subviews]){
            if ([v2 isKindOfClass:[UIImageView class]]) {
                [((UIImageView*)v2) setContentMode:UIViewContentModeScaleAspectFit];
            }
        }
    }
    [bg addSubview:autoPlay];
    [contentView addSubview:bg];
    
    if (itms.count != 0) {
        UIImageView *imgs = [@"howmuch.png" imageViewForImgSizeAtX:autoPlay.w - 44 -10 Y:autoPlay.h-21-10];
        UILabel *l = [VILabel createLableWithFrame:Frm(28, 2, 44-28, 25) color:@"#9A9A9A" font:Light(20) align:CENTER];
        l.text = Fmt(@"%ld",(unsigned long)itms.count);
        [imgs addSubview:l];
        [autoPlay addSubview:imgs];
    }
    
    UILabel *describe;
    describe =  [VILabel createManyLines:Frm(15, bg.endY+10, 290, 0) color:@"#2C2C2C" ft:Bold(22) text:[info stringValueForKey:@"Offer"]];
    describe.textAlignment = Align;
    describe.text = [info stringValueForKey:@"Offer"];
    [contentView addSubview:describe];

    fullText = [info stringValueForKey:@"Description" defaultValue:nil];
    int offset = describe.endY;
    if (fullText != nil) {
        UILabel *moretext =  [VILabel createManyLines:Frm(15, offset+10, 290, 0) color:@"#414141" ft:Light(15) text:fullText];
        totalHeight = moretext.h;
        [moretext setH:45];
        moretext.tag = 10000;
        moretext.text= fullText;
        moretext.textAlignment = Align;
        [contentView addSubview:moretext];
        
        offset = moretext.endY;
         if (fullText.length > 100) {
             UIButton *showMore = [[UIButton alloc] initWithFrame:Frm(0, moretext.endY, 100, 30)];
             showMore.titleLabel.textAlignment = Align;
             [showMore setTitle:Lang(@"more_desc") selected:Lang(@"more_desc")];
             showMore.titleLabel.font = Regular(15);
             [showMore setTitleColor:[@"#FA2D38" hexColor] forState:UIControlStateNormal];
             [showMore addTarget:self action:@selector(showFull:)];
             [contentView addSubview:showMore];
             offset = showMore.endY;
         }
    }

    UIView *subItme = [[UIView alloc] initWithFrame:Frm(0,offset+20, 320, 0)];
    subItme.tag = 10001;
    
    NSString *addid = [info stringValueForKey:@"AddressId"];
    
    int x = (subItme.w - 140)/2;
    mobiStore = [[iSQLiteHelper getDefaultHelper] searchSingle:[Store class] where:@{@"AddressId":addid} orderBy:@"AddressId"];
    if (isEn && mobiStore.Lat != 0 && mobiStore.Lon != 0) {
        x = (subItme.w - 70 * 3)/2;
        UIButton *share = [[UIButton alloc] initWithFrame:Frm(x,5, 60, 60)];
        share.backgroundColor = [@"#FA2D38" hexColor];
        share.layer.cornerRadius = 30;
        [share setImage:[@"locfff.png" image] forState:UIControlStateNormal];
        [share setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
        [share addTarget:self action:@selector(whereIam:)];
        [subItme addSubview:share];
        x= x + 80;
    }
    
    UIButton *like = [[UIButton alloc] initWithFrame:Frm(x,5, 60, 60)];
    like.backgroundColor = [@"#FA2D38" hexColor];
    like.layer.cornerRadius = 30;
    like.tag = 200;
    like.titleEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 0);
    UIImageView *v = [@"gray_heart.png" imageViewForImgSizeAtX:10 Y:22];
    [like addTarget:self action:@selector(markIt:)];
    [like addSubview:v];
    [like setTitle:Fmt(@"%d",[info intValueForKey:@"MarkedCount"]) selected:Fmt(@"%d",[info intValueForKey:@"MarkedCount"])];
    like.enabled = ![info boolValueForKey:@"IsMarked" defaultValue:NO];
    
    [subItme addSubview:like];
    
    UIButton *share = [[UIButton alloc] initWithFrame:Frm(like.endX+20, like.y, 60, 60)];
    share.backgroundColor = [@"#FA2D38" hexColor];
    share.layer.cornerRadius = 30;
    [share setImage:[@"share_gray.png" image] forState:UIControlStateNormal];
    [share setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    [share addTarget:self action:@selector(reward:)];
    [subItme addSubview:share];
    
    UILabel *tip = [VILabel createLableWithFrame:Frm(0, share.endY+15, 320, 20) color:@"#FA2D38" font:Bold(15) align:CENTER];
    tip.text = Lang(@"more_by_store");
    [subItme addSubview:tip];
    
    if (!fromPush) {
        NSMutableString *inexp = [NSMutableString string];
        for (NSString *mid in self.exculedId) {
            [inexp appendFormat:@",'%@'",mid];
        }
        NSString *ids = [inexp substringFromIndex:1];
        NSString *sql = Fmt(@"select * from @t where AddressId='%@' and Type='Deal' and MobiPromoId not in(%@)",addid,ids);
        needShown = [helper searchWithSQL:sql toClass:[MobiPromo class]];
    }else{
        NSString *sql = Fmt(@"select * from @t where AddressId='%@' and Type='Deal' ",addid);
        needShown = [helper searchWithSQL:sql toClass:[MobiPromo class]];
    }
   
    if (needShown.count == 0) {
        [tip setHidden:YES];
    }
    
    int height = tip.endY+10;
    int rows = (int)ceilf((needShown.count)/2.0);
    for(int i=0;i<rows;i++)
    {
        int index = i * 2;
        int next = index+1;
        
        MobiPromo *left = [needShown objectAtIndex:index];
        UIView *bigone  = [self loadXib:@"UI.xib" withTag:16000];
        [bigone egoimageView4Tag:16001].placeholderImage = [@"no_pic.png" image];
       
        [bigone egoimageView4Tag:16001].imageURL = [NSURL URLWithString:left.defPicture];
        [bigone label4Tag:16002].text = left.Offer;
        [bigone label4Tag:16003].text = Fmt(@"%d",left.MarkedCount) ;
        [bigone addTapTarget:self action:@selector(seeDetail:)];
        bigone.tag = index;
        [bigone setX:13.3 andY:height+5];
        
        [subItme addSubview:bigone];
        
        if (next+1 < needShown.count) {
            MobiPromo *right = [needShown objectAtIndex:next];
            UIView *bigone2  = [self loadXib:@"UI.xib" withTag:16000];
            [bigone2 egoimageView4Tag:16001].placeholderImage = [@"no_pic.png" image];
            [bigone2 label4Tag:16002].text = right.Offer;
            [bigone2 label4Tag:16003].text = Fmt(@"%d",[right MarkedCount]) ;
            [subItme addSubview:bigone2];
            [bigone2 addTapTarget:self action:@selector(seeDetail:)];
            bigone2.tag = next;
            [bigone2 setX:bigone.endX+13.3 andY:height+5];
            [bigone2 egoimageView4Tag:16001].imageURL = [NSURL URLWithString:right.defPicture];
        }
        height = bigone.endY;
    }

    [subItme setH:height+10];
    [contentView addSubview:subItme];

    [contentView setContentSize:CGSizeMake(320, subItme.endY)];
    
    [self.view addSubview:contentView];
    //Mall Store MobiPromo Data Other
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_add_current_track_" object:
                                          @{@"Type": @"MobiPromo",@"ReferenceId": [info stringValueForKey:@"MobiPromoId"] ,@"StoreAddressId":[info stringValueForKey:@"AddressId"]}];
    if ([info boolValueForKey:@"StoreHasSuprise"]) {
        UIImageView *view = [@"suprise_buge.png" imageViewForImgSizeAtX:self.view.w-31-16 Y:6];
        [[[self.nav subviews] objectAtIndex:0] addSubview:view];
        view.userInteractionEnabled = YES;
        [view addTapTarget:self action:@selector(showInfoMessage:)];
    }
}

- (void)markIt:(id)sender
{
    [VINet post:Fmt(@"/api/mobipromos/%@/mark",mobipromo.MobiPromoId) args:nil target:self succ:@selector(markedComplte:) error:@selector(showAlertError:) inv:self.view];
}

- (void)markedComplte:(id)info
{
    UIButton *t = ((UIButton *)[self.view viewWithTag:200]);
    [t setTitle:Fmt(@"%d",[t.titleLabel.text intValue]+1) selected:Fmt(@"%d",[t.titleLabel.text intValue]+1)];
    [t setEnabled:NO];
    
    [mobipromo setIsMarked:YES];
    [mobipromo setMarkedCount:mobipromo.MarkedCount+1];
    [[iSQLiteHelper getDefaultHelper] insertOrUpdateUsingObj:mobipromo];
    
}
- (void)whereIam:(UIButton*)sneder {
    VINavMapViewController *nav = [[VINavMapViewController alloc] init];
    nav.destination = [[CLLocation alloc] initWithLatitude:mobiStore.Lat longitude:mobiStore.Lon];
    nav.title = mobiStore.StoreName;
    nav.subtitle = mobiStore.Address;
    [self push:nav];
}

- (void)reward:(UIButton*)sneder
{
    sneder.enabled = NO;
    
    NSMutableDictionary *pot = [NSMutableDictionary dictionary];
    [pot setValue:mobipromo.StoreImageUrl forKey:@"picture"];
    [pot setValue:mobipromo.Offer forKey:@"description"];
    [pot setValue:mobipromo.StoreName forKey:@"name"];
    [pot setValue:mobipromo.StoreUrl forKey:@"link"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_share_to_facebook_" object:pot];
    
    double delayInSeconds = 3.0;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^(void){
         sneder.enabled = YES;
    });
    
//    "UserSurpriseId": "a788521e-8368-4b1d-a173-a16e37c6f64c",
//    "MobiPromoId": "d06a6e1c-6783-4040-a6e2-29d21168e0c0",
//    "RewardTime": "2014-06-10T14:41:31.9829757+08:00",
//    "StartTime": "2014-06-10T14:41:31.9829757+08:00",
//    "ExpireTime": "2014-06-10T14:41:31.9829757+08:00",
//    "RedemptionCode": "sample string 6",
//    "Redeemed": false
    
//    [pot setValue:@"d06a6e1c-6783-4040-a6e2-29d21168e0c0" forKey:@"MobiPromoId"];
//    
//    NSArray *proms2 = [Fmt(@"%@/proms",_Cache_dir) jsonOfFilePath];
//    NSDictionary *pp = nil;
//    for (NSDictionary *dict in proms2) {
//        if ([[dict stringValueForKey:@"MobiPromoId"] isEqualToString:@"91e363ec-324c-42ba-b2c4-c078bf38d3b6"]){
//            pp = dict;
//            break;
//        }
//    }
//    
//    if (pp == nil) {
//        return;
//    }
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"_get_a_bigsuprise_" object:pp];
    
    //
}

- (void)seeDetail:(UITapGestureRecognizer *)tap
{
    long index = tap.view.tag;
    VIDealsDetailViewController *d = [[VIDealsDetailViewController alloc] init];
    MobiPromo *mobi = [needShown objectAtIndex:index];
    [d setValueToContent:[mobi toDictionary] forKey:@"VIDealsDetailViewController"];
    [self.exculedId addObject:mobi.MobiPromoId];
    d.exculedId = self.exculedId;
    [self push:d];
}


//TODO 等待优化API
-(void)showFull:(UIButton *)sender
{
    [sender removeFromSuperview];
    
    UILabel *lab = (UILabel *)[self.view viewWithTag:10000];

    //[lab setText:fullText];
    
//    [UIView animateWithDuration:.28 delay:.1 options:UIViewAnimationOptionCurveLinear animations:^{
//        [moretext setH:h];
//        PRINT_FRAME(moretext.frame);
//        [subitm setY:moretext.endY+20];
//    } completion:^(BOOL finished) {
//        if (finished) {
//             [contentView setContentSize:CGSizeMake(contentView.w, subitm.endY)];
//        }
//    }];
    [lab addY:25];
    UIView *subitm = [self.view viewWithTag:10001];
    [UIView animateWithDuration:.35 animations:^{
         [lab setH:totalHeight+10];
         [lab addY:-25];
         [subitm setY:lab.endY+20];
    } completion:^(BOOL finished) {
        if (finished) {
            [contentView setContentSize:CGSizeMake(contentView.w, subitm.endY)];
        }
    }];
}


@end
