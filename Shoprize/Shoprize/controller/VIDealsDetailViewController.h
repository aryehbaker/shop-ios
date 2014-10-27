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

@property(nonatomic,strong) NSMutableSet *exculedId;
@property(nonatomic,strong) NSMutableArray *imagelist;

@end
