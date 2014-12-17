//
//  VINavigationController.m
//  Shoprise_EN
//
//  Created by mk on 4/3/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VINavigationController.h"
#import <Shoprize/REFrostedContainerViewController.h>
#import <Shoprize/REFrostedViewController.h>


@interface VINavigationController ()

@end

@implementation VINavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)addMenuAction{
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

-(void)showMenu{
    [self.frostedViewController presentMenuViewController];
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.frostedViewController panGestureRecognized:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
