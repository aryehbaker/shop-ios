//
//  BKEGOImage.h
//  DemoImg
//
//  Created by 显宏 黄 on 12-8-30.
//  Copyright (c) 2012年  All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VICore/VIParts.h>
#import <UIKit/UIKit.h>

@interface VIEGOImageView : EGOImageView <EGOImageViewDelegate> {

}

- (id)initWithFrame:(CGRect)frame placeImg:(UIImage *)placeImg url:(NSString *)imgUrl;


@end
