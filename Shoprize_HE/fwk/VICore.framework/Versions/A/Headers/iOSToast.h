/*

iOSToast.h

MIT LICENSE

Copyright (c) 2012 Guru Software

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, iOSToastGravity) {
	iOSToastGravityTop = 1000001,
	iOSToastGravityBottom,
	iOSToastGravityCenter
};

typedef NS_ENUM(NSInteger, iOSToastDuration) {
	iOSToastDurationLong = 10000,
	iOSToastDurationShort = 1000,
	iOSToastDurationNormal = 3000
};

typedef NS_ENUM(NSInteger, iOSToastType) {
	iOSToastTypeInfo = -100000,
	iOSToastTypeNotice,
	iOSToastTypeWarning,
	iOSToastTypeError,
	iOSToastTypeNone // For internal use only (to force no image)
};

typedef NS_ENUM(NSInteger, iOSToastImageLocation) {
    iOSToastImageLocationTop,
    iOSToastImageLocationLeft
};

@class iOSToastSettings;

@interface iOSToast : NSObject {
    
	iOSToastSettings *_settings;
	
	NSTimer *timer;
	
	UIView *view;
	NSString *text;
}

- (void) show;
- (void) show:(iOSToastType) type;
- (iOSToast *) setDuration:(NSInteger ) duration;
- (iOSToast *) setGravity:(iOSToastGravity) gravity 
			 offsetLeft:(NSInteger) left
			 offsetTop:(NSInteger) top;
- (iOSToast *) setGravity:(iOSToastGravity) gravity;
- (iOSToast *) setPostion:(CGPoint) position;
- (iOSToast *) setFontSize:(CGFloat) fontSize;
- (iOSToast *) setUseShadow:(BOOL) useShadow;
- (iOSToast *) setCornerRadius:(CGFloat) cornerRadius;
- (iOSToast *) setBgRed:(CGFloat) bgRed;
- (iOSToast *) setBgGreen:(CGFloat) bgGreen;
- (iOSToast *) setBgBlue:(CGFloat) bgBlue;
- (iOSToast *) setBgAlpha:(CGFloat) bgAlpha;

+ (iOSToast *) makeText:(NSString *) text;

-(iOSToastSettings *) theSettings;

@end


@interface iOSToastSettings : NSObject<NSCopying>{
    
	NSInteger duration;
	iOSToastGravity gravity;
	CGPoint postition;
	iOSToastType toastType;
	CGFloat fontSize;
	BOOL useShadow;
	CGFloat cornerRadius;
	CGFloat bgRed;
	CGFloat bgGreen;
	CGFloat bgBlue;
	CGFloat bgAlpha;
	NSInteger offsetLeft;
	NSInteger offsetTop;

	NSDictionary *images;
	
	BOOL positionIsSet;
}


@property(assign) NSInteger duration;
@property(assign) iOSToastGravity gravity;
@property(assign) CGPoint postition;
@property(assign) CGFloat fontSize;
@property(assign) BOOL useShadow;
@property(assign) CGFloat cornerRadius;
@property(assign) CGFloat bgRed;
@property(assign) CGFloat bgGreen;
@property(assign) CGFloat bgBlue;
@property(assign) CGFloat bgAlpha;
@property(assign) NSInteger offsetLeft;
@property(assign) NSInteger offsetTop;
@property(readonly) NSDictionary *images;
@property(assign) iOSToastImageLocation imageLocation;


- (void) setImage:(UIImage *)img forType:(iOSToastType) type;
- (void) setImage:(UIImage *)img withLocation:(iOSToastImageLocation)location forType:(iOSToastType)type;
+ (iOSToastSettings *) getSharedSettings;
						  
@end