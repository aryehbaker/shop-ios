//
//  KUtils.m
//  Shoprose
//
//  Created by vnidev on 7/9/14.
//  Copyright (c) 2014 vnidev.com. All rights reserved.
//

#import "KUtils.h"
#import <VICore/VICore.h>
#import "Fonts.h"

@implementation KUtils

- (NSString *)rtlTxt:(id)input
{
    if (input == nil) {
        return @"";
    }
    return [input rtlTxt];
}

+ (UIView *)makeDialog:(NSString *)hour addr:(NSString *)addr tel:(NSString *)tel
{
    UIView *continer = [[UIView alloc] initWithFrame:Frm(0, 0, 260, 0)];
    
    UIFont *reg = Regular(16);
    UIFont *blk = Bold(16);
    
    UILabel *h =  [UILabel initManyLineWithFrame:Frm(10, 20, 160, 0) color:@"#252525" font:reg text:hour];
    [h setText:hour];
    [h setRTL];
    [continer addSubview:h];
    
    UILabel *ht = [[UILabel alloc] initWithFrame:Frm(h.endX+3, h.y, continer.w-20-h.w, 15)];
    ht.text = [@"open_hour" lang];
    ht.font = blk;
    [continer addSubview:ht];
    
    if(isEn){
        [ht setTextAlignment:NSTextAlignmentRight];
        [ht setX:10];
        [h setX:ht.endX+5];
    }
    
    h = [UILabel initManyLineWithFrame:Frm(10, h.endY+5, h.w, 0) color:@"#252525" font:reg text:addr];
    [h setText:addr];
    [h setRTL];
    [continer addSubview:h];
    ht = [[UILabel alloc] initWithFrame:Frm(ht.x, h.y, continer.w-20-h.w, 15)];
    ht.text = [@"addr_txt" lang];
    ht.font = blk;
    [continer addSubview:ht];
    
    if(isEn){
        [ht setTextAlignment:NSTextAlignmentRight];
        [ht setX:10];
        [h setX:ht.endX+5];
    }
    
    h = [UILabel initManyLineWithFrame:Frm(10, h.endY+5, h.w, 0) color:@"#0066ff" font:reg text:tel];
    [h setText:tel];
    [h setRTL];
    [h setUserInteractionEnabled:YES];
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:tel];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    h.attributedText = content;
    
    [h addTapTarget:self action:@selector(callMe:)];
    [continer addSubview:h];
    ht = [[UILabel alloc] initWithFrame:Frm(ht.x, h.y, continer.w-20-h.w, 15)];
    ht.text = [@"tel_txt" lang];
    ht.font = blk;
    [continer addSubview:ht];
    
    if(isEn){
        [ht setTextAlignment:NSTextAlignmentRight];
        [ht setX:10];
        [h setX:ht.endX+5];
    }

    UIButton *nav = [[UIButton alloc] initWithFrame:Frm((continer.w-40)/2, h.endY+15, 40, 40)];
    nav.tag = 4010;
    nav.backgroundColor = [@"#ff4747" hexColor];
    [continer addSubview:nav];
    
    [continer setH:nav.endY+15];
    
    return continer;
}

static NSString *telnum;
static KUtils *k;

+(void)callMe:(UITapGestureRecognizer *)l{
    NSString *call = ((UILabel *) l.view).text;
    if (call.length < 6) {
        return;
    }
    telnum = call;
    
    k = [[KUtils alloc] init];
    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"" message:Fmt(Lang(@"make_a_call"),call) delegate:k cancelButtonTitle:@"בטל" otherButtonTitles:@"התקשר", nil];
    [alt show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:Fmt(@"tel:%@",telnum)]];
    }
}

@end

@implementation NSString(RTL)

-(NSString *) rtlTxt
{
    return [@"\u200F" stringByAppendingString:self];
}

- (BOOL)like:(NSString *)input
{
    NSString *old = [self lowercaseString];
    NSString *newone = [input lowercaseString];
    return [old hasString:newone];
}

- (NSString *)killQute
{
    return [[self stringByReplacingOccurrencesOfString:@"[" withString:@""] stringByReplacingOccurrencesOfString:@"]" withString:@""];
}

- (NSDate *)toLocalDate
{
    if (self==nil || self.length==0) {
        return nil;
    }
    if ([self hasPrefix:@"9999-12-31"]) {
        return nil;
    }
    NSString *timeFmt = @"yyyy-MM-dd'T'HH:mm:ss";
    NSString *time = self;
    if (self.length==10) {
        timeFmt = @"yyyy-MM-dd";
    }
    if (self.length>=19) {
        time = [self substringToIndex:19];
    }
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
	timeFormatter.dateFormat = timeFmt;
    timeFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDate *adate = [timeFormatter dateFromString:time];
    return adate;
}

@end

@implementation UILabel(RTL)
- (void)setRTL
{
    self.text = [[self text] rtlTxt];
    self.textAlignment = Align;
}
@end

@implementation UIView (Extra2)
- (UIButton *)button4Tag:(NSInteger)tag
{
    return (UIButton *)[self viewWithTag:tag];
}
@end


@implementation NSMutableDictionary (ExtraNotNull)

- (void)setNotNullKey:(NSString *)key value:(id)value
{
    if (key!=nil && ![key isEqualToString:@""]) {
        [self setValue:value == nil ? @"" : value forKey:key];
    }
}

@end