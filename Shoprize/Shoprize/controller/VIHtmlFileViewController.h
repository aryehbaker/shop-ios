//
//  VIAboutViewController.h
//  ShopriseComm
//
//  Created by mk on 4/3/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "ShopriseViewController.h"

@interface VIHtmlFileViewController : ShopriseViewController<VIHtmlLoadViewDelegate,UIWebViewDelegate>

@property(nonatomic,strong) NSString *htmlFile;
@property(nonatomic,strong) NSString *headTitle;
@property(nonatomic,strong) NSString *from;

@end
