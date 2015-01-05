//
//  VIDealsDetailViewController.h
//  ShopriseComm
//
//  Created by mk on 4/8/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "ShopriseViewController.h"
#import "MHFacebookImageViewer.h"

@interface VIDealsDetailViewController : ShopriseViewController<MHFacebookImageViewerDatasource>

//这个值是JSON转化过后的内容
@property(nonatomic,strong) MobiPromo *mobipromo;
@property(nonatomic,strong) MobiPromoAR *mobipromoar;

@property(nonatomic,strong) NSMutableSet *exculedId;
@property(nonatomic,strong) NSMutableArray *imagelist;

@property(nonatomic,strong) NSString *dealid;
@property(nonatomic,assign) BOOL hideMore;
@property(nonatomic,assign) BOOL showRedeem;

@end
