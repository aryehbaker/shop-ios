//
//  VIBigSuprise.m
//  Shoprise_EN
//
//  Created by vnidev on 5/29/14.
//  Copyright (c) 2014 techwuli. All rights reserved.
//

#import "VIBigSuprise.h"
#import <VICore/VICore.h>
#import <QuartzCore/QuartzCore.h>

@interface VIBigSuprise()
{
    BOOL _isSliding;
    UISlider *sliblck;
}
@property(nonatomic,strong) NSDictionary *info;
@end


@implementation VIBigSuprise

- (id)initWithFrame:(CGRect)frame dict:(id)value
{
    self = [super initWithFrame:frame];
    if (self) {
        _isSliding = false;
        self.info = value;
        
        self.backgroundColor = [@"#000000" hexColorAlpha:.6];
        
        UIImageView *boom = [[UIImageView alloc] initWithFrame:Frm((self.w - 240)/2, 100, 240, 240)];
        boom.image = [self createImage:value];
        
        initFrame = boom.frame; //初始化参数
        velocity = CGSizeMake(20, 20); //从1扩充到280 在到240
        
        [boom setHidden:YES];
        [self addSubview:boom];
        boom.tag =100;
        
        UIView *slider = [[UIView alloc] initWithFrame:Frm(30, boom.endY+ (IS_RETINA_4 ? 60 : 30), 260, 55)];
        slider.layer.borderColor = [@"#727272" hexColor].CGColor;
        slider.layer.borderWidth = 1;
        slider.layer.cornerRadius = 55/2;
        slider.backgroundColor = [@"#ffffff" hexColorAlpha:.7];
        
        UILabel *sliderTxt = [VILabel createLableWithFrame:Frm(10, 5, 220, 45) color:@"#464646" font:_FontPekanBold(22) align:RIGHT];
        sliderTxt.text = @"לפרטי ההפתעה - החלק";
        sliderTxt.shadowColor = [@"#fefdfd" hexColorAlpha:.5];
        sliderTxt.shadowOffset = CGSizeMake(1, -1.0);
        [slider addSubview:sliderTxt];
        
        sliblck = [[UISlider alloc] initWithFrame:Frm(slider.x-5,slider.Y,slider.w+10,55)];
        sliblck.minimumValue = 1;
        sliblck.maximumValue = 50;
        sliblck.continuous = YES;
        [sliblck setMaximumTrackImage:[self clearPixel] forState:UIControlStateNormal];
        [sliblck setMinimumTrackImage:[self clearPixel] forState:UIControlStateNormal];
        [sliblck setThumbImage:[@"slider_icon.png" image] forState:UIControlStateNormal];
       
        [sliblck addTarget:self action:@selector(sliderUp:) forControlEvents:UIControlEventTouchUpInside];
        [sliblck addTarget:self action:@selector(sliderUp:)  forControlEvents:UIControlEventTouchUpOutside];
        [sliblck addTarget:self action:@selector(sliderDown:)  forControlEvents:UIControlEventTouchDown];
        [sliblck addTarget:self action:@selector(sliderChange:)  forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:slider];
        [self addSubview:sliblck];
        
    }
    return self;
}

- (UIImage *)createImage:(NSDictionary *) value
{
    UIView *contentView = [[UIView alloc] initWithFrame:Frm(0,0, 240, 240)];
    UIImageView *imagev = [@"boom_bg.png" imageViewForImgSizeAtX:0 Y:0];
    [contentView addSubview:imagev];
    NSString *offer = [value stringValueForKey:@"Offer"];
    NSString *regValue = [offer stringByMatching:@"\\[[^\\]]*\\]"];
    if (regValue != nil) {
        NSArray *comp = [offer componentsSeparatedByString:regValue];
        NSString *row0 = [comp objectAtIndex:0];
       
        UILabel *f1 = [VILabel createLableWithFrame:Frm(50, 76/2, 140, 50) color:@"#ffffff" font:FontS(18) align:CENTER];
        f1.text = row0;
        f1.numberOfLines = 2;
        f1.lineBreakMode = NSLineBreakByWordWrapping;
        [contentView addSubview:f1];
        
        UILabel *f3 = [VILabel createLableWithFrame:Frm(34, f1.endY, 170, (120-f1.endY)*2) color:@"#ffffff" font:_FontPekanBlack(100) align:CENTER];
        f3.text = [regValue substringWithRange:NSMakeRange(1, regValue.length-2)];
        
        f3.minimumScaleFactor = 0.7;
        f3.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        f3.adjustsFontSizeToFitWidth = YES;
        [contentView addSubview:f3];
        
        NSString *com2 = [comp objectAtIndex:1];
        UILabel *f4 = [VILabel createLableWithFrame:Frm(f1.x,f3.endY,f1.w,f1.h) color:@"#ffffff" font:f1.font align:CENTER];
        f4.text = com2;
        f4.numberOfLines = 2;
        [contentView addSubview:f4];
    }else{
        UILabel *f = [VILabel createLableWithFrame:Frm(50, 35, 140, 25*6) color:@"#ffffff" font:FontS(19) align:CENTER];
        f.numberOfLines = 6;
        f.lineBreakMode = NSLineBreakByWordWrapping;
        f.text  = offer;
        [contentView addSubview:f];
    }
    
    UIGraphicsBeginImageContextWithOptions(contentView.frame.size, NO, 0);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(context, 0, 0);
    [contentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return renderedImage;
}

- (UIImage *) clearPixel {
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)sliderUp:(UISlider *)sender
{
    if (_isSliding) {
        _isSliding = NO;
    }
    if (sliblck.value == sender.maximumValue) {
        [self hideMe:self.info];
    }else{
        [sliblck setValue:1 animated: YES];
    }
}

- (void) sliderDown:(UISlider *)sender {
	_isSliding = YES;
}

- (void) sliderChange:(UISlider *)sender
{
    if (sender.value == sender.maximumValue) {
        
    }
}

-(void)hideMe:(id)info
{
    UIView *boom = [self viewWithTag:100];
    [UIView animateWithDuration:.5 animations:^{
        boom.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 1, 0);
        boom.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
                [[self delegate] openIt:info];
                [self removeFromSuperview];
        }
    }];
}

static float maxWH = 280;
static float dampingCoefficient = 5;

- (void)boomAnnimation:(CADisplayLink *)displayLink{
    
    UIView *boom = [self viewWithTag:100];
    
    CGSize displacement = CGSizeMake(boom.frame.size.width - initFrame.size.width,boom.frame.size.height - initFrame.size.height);
    //控件收到的力
    CGSize kx = CGSizeMake(maxWH * displacement.width, maxWH * displacement.height);
    //控件受到的阻力
    CGSize bv = CGSizeMake(dampingCoefficient	* velocity.width, dampingCoefficient * velocity.height);
    //加速度
    CGSize acceleration = CGSizeMake((kx.width + bv.width) / 1, (kx.height + bv.height) / 1);
    
    velocity.width -= (acceleration.width * displayLink.duration);
    velocity.height -= (acceleration.height * displayLink.duration);
    
    //设置控件新位置
    CGSize newSize = boom.frame.size;
    
    newSize.width += (velocity.width * displayLink.duration);
    newSize.height += (velocity.height * displayLink.duration);
    
    [boom setFrame:CGRectMake(boom.x, boom.y, newSize.width, newSize.height)];
}

-(void)openSuprise
{
    UIView *boom = [self viewWithTag:100];
    [boom setFrame:CGRectMake((self.w - 20)/2, boom.y+110, 20, 20)];
    [boom setHidden:NO];
    boom.alpha = 1;
    
    [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.5f options:0 animations:^{
        boom.transform = CGAffineTransformMakeScale(12, 12);
        boom.alpha = 1;
    } completion:^(BOOL finished) {
        boom.transform = CGAffineTransformMakeScale(1, 1);
        boom.frame = initFrame;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self hideMe:nil];
        });
    }];
}

@end
