//
//  VISignUpViewController.h
//  Shoprise_EN
//
//  Created by mk on 4/1/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import <Shoprize/Shoprize.h>
#import <VICore/VICore.h>

@interface VIHtmlViewController : ShopriseViewController<VIHtmlLoadViewDelegate>

@property(nonatomic,strong) VIHtmlLoadView *htmlview;

@end
