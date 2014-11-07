//
//  RTLabel.h
//  RTLabelProject
//

/**
 * Copyright (c) 2010 Muh Hon Cheng
 * Created by honcheng on 1/6/11.
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject
 * to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR
 * IN CONNECTION WITH THE SOFTWARE OR
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * @author      Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2011	Muh Hon Cheng
 * @version
 *
 *  RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(10,30,300,440)];
 *  [label setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:15]];
 *
 *	NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
 *  [linkAttributes setObject:@"bold" forKey:@"style"];
 *	[linkAttributes setObject:@"blue" forKey:@"color"];
 *	[linkAttributes setObject:@"1" forKey:@"underline"];
 *
 *	NSMutableDictionary *selectedLinkAttributes = [NSMutableDictionary dictionary];
 *	[selectedLinkAttributes setObject:@"bold" forKey:@"style"];
 *	[selectedLinkAttributes setObject:@"red" forKey:@"color"];
 *	[selectedLinkAttributes setObject:@"2" forKey:@"underline"];
 *
 *  <p indent=0>!!!Lorem 
        <font kern=35 underline=2 style=italic color=blue>ipsum</font> dolor \tsit amet, 
        <i>consectetur adipisicing elit, sed do eiusmod tempor</i> 
        <u color=red>incididunt ut</u> 
        <uu color=green>labore et dolore</uu> magna aliqua.
    </p>
    <p indent=20>
        <i>Ut enim ad minim</i> veniam, <b>quis nostrud</b> exercitation 
        <font color=#CCFF00 face=HelveticaNeue-CondensedBold size=30>ullamco laboris <i>nisi</i> ut aliquip</font> 
        <font color='blue' size=30 stroke=1>ex ea commodo consequat.</font> Duis aute irure dolor in 
        <font face=Cochin-Bold size=40>reprehenderit</font>
        <font face=AmericanTypewriter size=20 color=purple>in voluptate velit esse cillum dolore</font> eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat <i>non <font color=cyan>proident,</p> <b>sunt in <u>culpa qui</u> officia</b> deserunt</font> mollit</i> anim id est laborum.\n<p><a href='http://honcheng.com'>clickable link</a></p>
 *
 */

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

typedef enum {
	RTTextAlignmentRight	= kCTRightTextAlignment,
	RTTextAlignmentLeft		= kCTLeftTextAlignment,
	RTTextAlignmentCenter	= kCTCenterTextAlignment,
	RTTextAlignmentJustify	= kCTJustifiedTextAlignment
} RTTextAlignment;

typedef enum {
	RTTextLineBreakModeWordWrapping = kCTLineBreakByWordWrapping,
	RTTextLineBreakModeCharWrapping = kCTLineBreakByCharWrapping,
	RTTextLineBreakModeClip			= kCTLineBreakByClipping,
} RTTextLineBreakMode;

@protocol RTLabelDelegate <NSObject>

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url;

@end

@interface VIRTLabel : UIView {
	NSString				*_text;
	UIFont					*font;
	UIColor					*textColor;
	RTTextAlignment			_textAlignment;
	RTTextLineBreakMode		_lineBreakMode;
	NSString				*_plainText;
	NSMutableArray			*_textComponents;
	CGSize					_optimumSize;
	CGFloat					_lineSpacing;
	NSInteger   			currentSelectedButtonComponentIndex;
	NSDictionary			*linkAttributes;
	NSDictionary			*selectedLinkAttributes;
	id <RTLabelDelegate>	delegate;
	CTFrameRef				frame;
	CFRange					visibleRange;
	NSString				*paragraphReplacement;
}

@property (nonatomic, retain) UIColor				*textColor;
@property (nonatomic, retain) UIFont				*font;
@property (nonatomic, retain) NSDictionary			*linkAttributes;
@property (nonatomic, retain) NSDictionary			*selectedLinkAttributes;
@property (nonatomic, assign) id <RTLabelDelegate>	delegate;
@property (nonatomic, copy) NSString				*paragraphReplacement;

- (NSString *)text;

- (void)setText:(NSString *)text;

- (CGFloat)setTextFormat:(NSString *)fmt,... NS_REQUIRES_NIL_TERMINATION;

- (void)setTextAlignment:(RTTextAlignment)textAlignment;

- (void)setLineBreakMode:(RTTextLineBreakMode)lineBreakMode;

- (CGSize)optimumSize;

- (void)setLineSpacing:(CGFloat)lineSpacing;

- (NSString *)visibleText;

@end
