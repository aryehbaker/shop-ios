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

    NSDictionary *mobi_promo;

    UIButton *redeem;
 
    NSMutableArray *load_itms;
}

@end

@implementation VIDealsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //from push
    if (self.dealid!=nil) {
        [self addNav:@"Detail" left:BACK right:NONE];
        [VINet get:Fmt(@"/api/mobipromos/%@/detail",_dealid)  args:nil target:self succ:@selector(loadOK:) error:@selector(loadFail:) inv:self.view];
    }
    else{
        //otherwish from another way
        if (_mobipromo!=nil)
            mobi_promo  = [_mobipromo toDictionary];
        if (_mobipromoar != nil)
            mobi_promo  = [_mobipromoar toDictionary];
        
        
        if (self.exculedId == nil) {
            self.exculedId = [NSMutableSet set];
        }
        [self.exculedId addObject:[mobi_promo stringValueForKey:@"MobiPromoId"]];
        
        NSString *title = [mobi_promo stringValueForKey:@"StoreName"];
        
        [self addNav:title left:BACK right:NONE];

        self.nav.backgroundColor = [@"#DADADA" hexColor];
        self.view.backgroundColor = self.nav.backgroundColor;
        
        [self loadComplete:mobi_promo];
    }
}

-(void)loadOK:(id)value {
    NSMutableDictionary *resp = [value mutableCopy];
    NSArray *addr = [resp arrayValueForKey:@"Addresses"];
    if (addr!=nil && addr.count > 0) {
        [resp addEntriesFromDictionary:[addr objectAtIndex:0]];
    }
    
    mobi_promo = value;
    [self loadComplete:resp];
    
}

-(void)loadFail:(id)value {
    [self showAlertError:value];
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
    
    contentView = [[UIScrollView alloc] initWithFrame:Frm(0, self.nav.endY, self.view.w, Space(self.nav.endY))];
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
    
    load_itms = [NSMutableArray array];
    for (Picture *p in pics) {
        VIAutoPlayItem *it = [[VIAutoPlayItem alloc] initWithURL:p.PictureUrl andValue:nil];
        it.placeImage = [@"no_pic.png" image];
        [load_itms addObject:it];
        [self.imagelist addObject:[NSURL URLWithString:p.PictureUrl]];
    }
    
    UIView *bg = [[UIView alloc] initWithFrame:Frm(10, 0, 300, 220)];
    bg.backgroundColor = [@"#ffffff" hexColor];
    
    VIAutoPlayPageView *autoPlay = [[VIAutoPlayPageView alloc] initWithFrame:Frm(8, 8, 284, 204) delegate:self focusImageItems:load_itms alphaBackFrame:CGRectZero];
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
    
    if (load_itms.count != 0) {
        UIImageView *imgs = [@"howmuch.png" imageViewForImgSizeAtX:autoPlay.w - 44 -10 Y:autoPlay.h-21-10];
        UILabel *l = [VILabel createLableWithFrame:Frm(28, 2, 44-28, 25) color:@"#9A9A9A" font:Light(20) align:CENTER];
        l.text = Fmt(@"%ld",(unsigned long)load_itms.count);
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

    //下面一块的子视图
    UIView *subItme = [[UIView alloc] initWithFrame:Frm(0,offset+20, self.view.w, 0)];
    subItme.tag = 10001;
    
    NSString *addid = [info stringValueForKey:@"AddressId" defaultValue:@"0"];
    
    //默认没有redeem按钮
    int y = 5;
    if (isEn) {
        redeem = [[UIButton alloc] initWithFrame:Frm(.2 * subItme.w, 5, .6*subItme.w, 40) font:FontB(16) title:@"Redeem" color:@"#FA2D38"];
        [subItme addSubview:redeem];
        redeem.backgroundColor =[@"#ffffff" hexColor];
        redeem.layer.cornerRadius = 10;
        [redeem addTarget:self action:@selector(redeemProm:)];
        y = redeem.endY+40;
        
        if ([mobi_promo stringValueForKey:@"ExpireDate"]!=nil && ![[[mobi_promo stringValueForKey:@"ExpireDate"] parse:@"yyyy-MM-dd HH:mm:ss"] laterThan:[NSDate date]])
        {
            [redeem setTitle:@"Expire" forState:UIControlStateNormal];
            [redeem setEnabled:NO];
        }
    }

    int x = (subItme.w - 140)/2;
    
    if (isEn && [info doubleValueForKey:@"Lat"] > 0) {
        x = (subItme.w - 70 * 3)/2;
        UIButton *share = [[UIButton alloc] initWithFrame:Frm(x,y, 60, 60)];
        share.backgroundColor = [@"#FA2D38" hexColor];
        share.layer.cornerRadius = 30;
        [share setImage:[@"locfff.png" image] forState:UIControlStateNormal];
        [share setImageEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
        [share addTarget:self action:@selector(whereIam:)];
        [subItme addSubview:share];
        x= x + 80;
    }
    
    UIButton *like = [[UIButton alloc] initWithFrame:Frm(x,y, 60, 60)];
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
    
    UILabel *tip = [VILabel createLableWithFrame:Frm(0, share.endY+15, self.view.w, 20) color:@"#FA2D38" font:Bold(15) align:CENTER];
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
   
    if (_hideMore || needShown.count == 0) {
        [tip setHidden:YES];
        needShown = [NSMutableArray array];
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

    [contentView setContentSize:CGSizeMake(self.view.w, subItme.endY)];
    
    [self.view addSubview:contentView];
    //Mall Store MobiPromo Data Other
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_add_current_track_" object:
                                          @{@"Type": @"MobiPromo",@"ReferenceId": [info stringValueForKey:@"MobiPromoId" defaultValue:@""] ,@"StoreAddressId":[info stringValueForKey:@"AddressId" defaultValue:@""]}];
    if ([info boolValueForKey:@"StoreHasSuprise"]) {
        UIImageView *view = [@"suprise_buge.png" imageViewForImgSizeAtX:self.view.w-31-16 Y:6];
        [[[self.nav subviews] objectAtIndex:0] addSubview:view];
        view.userInteractionEnabled = YES;
        [view addTapTarget:self action:@selector(showInfoMessage:)];
    }
}

//激活redeem
-(void)redeemProm:(UIButton *)sender
{
    NSString *dealid = [mobi_promo stringValueForKey:@"MobiPromoId"];
    [self redeemDeail:dealid complete:@selector(whenRedeemComplete:)];
}

-(void)whenRedeemComplete:(id)resp
{
    NSString *code = [resp stringValueForKey:@"RedemptionCode"];
    [redeem setTitle:code selected:code];
    [redeem setEnabled:NO];
}

- (void)markIt:(id)sender {
    NSString *dealid = [mobi_promo stringValueForKey:@"MobiPromoId"];
    [VINet post:Fmt(@"/api/mobipromos/%@/mark",dealid) args:nil target:self succ:@selector(markedComplte:) error:@selector(showAlertError:) inv:self.view];
}

- (void)markedComplte:(id)info
{
    UIButton *t = ((UIButton *)[self.view viewWithTag:200]);
    [t setTitle:Fmt(@"%d",[t.titleLabel.text intValue]+1) selected:Fmt(@"%d",[t.titleLabel.text intValue]+1)];
    [t setEnabled:NO];
    NSMutableDictionary *rspVal = [mobi_promo mutableCopy];
    [rspVal setValue:[NSNumber numberWithBool:YES] forKey:@"IsMarked"];
    [rspVal setValue:[NSNumber numberWithInt:[mobi_promo intValueForKey:@"MarkedCount"] +1] forKey:@"MarkedCount"];
    if(_mobipromoar!=nil)
        [[iSQLiteHelper getDefaultHelper] insertOrUpdateDB:[MobiPromoAR class] value:rspVal];
    else
        [[iSQLiteHelper getDefaultHelper] insertOrUpdateDB:[MobiPromo class] value:rspVal];
}
- (void)whereIam:(UIButton*)sneder {
    VINavMapViewController *nav = [[VINavMapViewController alloc] init];
    double lat = [mobi_promo doubleValueForKey:@"Lat"];
    double lon = [mobi_promo doubleValueForKey:@"Lon"];
    nav.destination = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    nav.title = [mobi_promo stringValueForKey:@"StoreName"];
    nav.subtitle = [mobi_promo stringValueForKey:@"Address"];
    [self push:nav];
}

- (void)reward:(UIButton*)sneder
{
    sneder.enabled = NO;
    NSString *imageURL = nil;
    if (load_itms.count> 0) {
        VIAutoPlayItem *item = [load_itms objectAtIndex:0];
        imageURL = item.imageURL;
    }
    
    NSMutableDictionary *pot = [NSMutableDictionary dictionary];
    [pot setValue:imageURL forKey:@"picture"];
    [pot setValue:[mobi_promo stringValueForKey:@"Description"] forKey:@"description"];
    [pot setValue:[mobi_promo stringValueForKey:@"StoreName"] forKey:@"name"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"_share_to_facebook_" object:pot];
    
    double delayInSeconds = 3.0;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^(void){
         sneder.enabled = YES;
    });
}

- (void)seeDetail:(UITapGestureRecognizer *)tap
{
    long index = tap.view.tag;
    MobiPromo *mobi = [needShown objectAtIndex:index];
    
    VIDealsDetailViewController *deal = [[VIDealsDetailViewController alloc] init];
    deal.mobipromo = mobi;
    
    [self.exculedId addObject:mobi.MobiPromoId];
    deal.exculedId = self.exculedId;
    
    [self push:deal];
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
