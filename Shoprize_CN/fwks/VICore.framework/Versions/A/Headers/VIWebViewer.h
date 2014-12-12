//
//  VIWebViewer.h
//  VICore
//
//  Created by mk on 13-11-20.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VIWebViewer : UIView

@property(nonatomic,retain) UIWebView *browView;
@property(nonatomic,retain) NSURL *currentURL;
@property(nonatomic,retain) NSMutableArray *history;


- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame andUrl:(NSURL *)url;

- (void)hideToolBar:(BOOL)hide;

- (void)startLoad:(NSURL *)loadurl;

- (void)startLoadHtmlData:(NSString *)htmlContent;

@end
