//
//  VTBaseViewController+ImagePicker.h
//  VTCore
//
//  Created by mk on 13-10-28.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <VICore/VICtrls.h>
#import <VICore/VIMacro.h>

@interface VIBaseViewController (ImagePicker)

/* 设置当前选取照片的时候是否可以编辑 */
- (void)setImageEditable:(BOOL)isEnable;

/*!
 *  @param type 选择图片的来源
 *  @param  dele 是否有清除按钮
 *  @param  complet 回调函数
 *      -> act 操作类型
 *      -> img 编辑后的图片
 *      -> all 所有的信息
 */
- (void)takeImage:(IMAGE_FROM)from withDel:(BOOL)dele complet:(void(^)(IMAGE_ACTION act,UIImage *img,id all))complet;

@end

//使用外置的方法
@interface UIImagePickerRender : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic,assign) UIViewController *root;

- (void)takeFromCamera;
- (void)takeFromAlbum;
- (void)invokeBlock:(IMAGE_ACTION) act img:(UIImage *)img all:(id)info;

@end
