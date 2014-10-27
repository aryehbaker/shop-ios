//
//  VIAnimation.h
//  VICore
//
//  Created by mk on 13-3-13.
//  Copyright (c) 2013年 app1580.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/**
 *    动画集合
 *    @author mk
 */
@interface VIAnimation : NSObject

/**
 *    这个是一组动画
 *     将一个视图，切换到到后面的时候使用
 *    @returns CAAnimationGroup
 */
+ (CAAnimationGroup *)animationGroupPushedBackward;

/**
 *     将一个视图切换到前面来
 *    @returns CAAnimationGroup
 *  用法 git://github.com/zetachang/DCModalSegue.git
 */
+ (CAAnimationGroup *)animationGroupBringForward;

/**
 *
 *     自动的透明度的变化动画操作.
 *    @returns CABasicAnimation
 */
+ (CABasicAnimation *)translateAnimation;

/**
 *
 *    透明度的变化动画操作.
 *    @returns CABasicAnimation
 */
+ (CABasicAnimation *)translateAnimationFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue;

/**
 *    透明度操作，从一个点到另外一个点
 *    @param fromValue 开始点
 *    @param toValue 结束点
 *    @returns CABasicAnimation
 */
+ (CABasicAnimation *)translateAnimationFrom:(CGPoint)fromValue to:(CGPoint)toValue;

//////////////////////旋转///////////////////////////////

/**
 *    X坐标 从0°旋转到对应的角度
 *    @param angle 目标角度
 *    @returns CABasicAnimation
 */
+ (CABasicAnimation*)rotateAnimationOnXToAngle:(double)angle;

/**
 *    X坐标 从一个角度旋转到对应的角度
 *    @param fromAngle 起始角度
 *    @param toAngle 目标角度
 *    @returns CABasicAnimation
 */
+ (CABasicAnimation*)rotateAnimationOnXFromAngle:(double)fromAngle toAngle:(double)toAngle;

@end

