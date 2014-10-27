//
//  VTHttpFile.h
//  daxi
//
//  Created by mk on 13-9-28.
//  Copyright (c) 2013年 Vega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VIHttpFile : NSObject
@property(nonatomic,retain) NSData *data;
@property(nonatomic,retain) NSString *fileName;
@property(nonatomic,retain) NSString *mimeType;

-(id)initWith:(NSData *)data name:(NSString *)filename;
-(id)initWithImage:(UIImage *)image;
-(id)initWithPath:(NSString *)path;

@end
