//
//  NSAttributedString+Attributes.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "NSAttributedString_Attributes.h"
#include <CommonCrypto/CommonDigest.h>

@implementation NSString (RRFramework)
+(NSString*) RR_stringWithCString:(const char *)bytes {
    return [NSString stringWithCString:bytes encoding:NSUTF8StringEncoding];
}
+(NSString*) RR_stringWithCString:(const char *)bytes length:(NSUInteger)length {
    NSString* result = [[NSString alloc] initWithBytes:bytes length:length encoding:NSStringEncodingConversionAllowLossy];
    return [result autorelease];
}
-(NSString*) RR_stringFromMD5 {
    if([self length] == 0) {
        return nil;
    }
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++) {
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return [outputString autorelease];
}
@end

@implementation NSAttributedString (OHCommodityConstructors)
+(id)attributedStringWithString:(NSString*)string {
	return string ? [[[self alloc] initWithString:string] autorelease] : nil;
}
+(id)attributedStringWithAttributedString:(NSAttributedString*)attrStr {
	return attrStr ? [[[self alloc] initWithAttributedString:attrStr] autorelease] : nil;
}

-(CGSize)sizeConstrainedToSize:(CGSize)maxSize {
	return [self sizeConstrainedToSize:maxSize fitRange:NULL];
}
-(CGSize)sizeConstrainedToSize:(CGSize)maxSize fitRange:(NSRange*)fitRange {
	CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
	CFRange fitCFRange = CFRangeMake(0,0);
	CGSize sz = CTFramesetterSuggestFrameSizeWithConstraints(framesetter,CFRangeMake(0,0),NULL,maxSize,&fitCFRange);
	if (framesetter) CFRelease(framesetter);
	if (fitRange) *fitRange = NSMakeRange(fitCFRange.location, fitCFRange.length);
	return CGSizeMake( floorf(sz.width+1) , floorf(sz.height+1) ); // take 1pt of margin for security
}
@end


@implementation NSMutableAttributedString (OHCommodityStyleModifiers)

-(void)setFont:(UIFont*)font {
	[self setFontName:font.fontName size:font.pointSize];
}
-(void)setFont:(UIFont*)font range:(NSRange)range {
	[self setFontName:font.fontName size:font.pointSize range:range];
}
-(void)setFontName:(NSString*)fontName size:(CGFloat)size {
	[self setFontName:fontName size:size range:NSMakeRange(0,[self length])];
}
-(void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range {
	// kCTFontAttributeName
	CTFontRef aFont = CTFontCreateWithName((CFStringRef)fontName, size, NULL);
	if (!aFont) return;
	[self removeAttribute:(NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTFontAttributeName value:(id)aFont range:range];
	CFRelease(aFont);
}
-(void)setFontFamily:(NSString*)fontFamily size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic range:(NSRange)range {
	// kCTFontFamilyNameAttribute + kCTFontTraitsAttribute
	CTFontSymbolicTraits symTrait = (isBold?kCTFontBoldTrait:0) | (isItalic?kCTFontItalicTrait:0);
	NSDictionary* trait = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:symTrait] forKey:(NSString*)kCTFontSymbolicTrait];
	NSDictionary* attr = [NSDictionary dictionaryWithObjectsAndKeys:
						  fontFamily,kCTFontFamilyNameAttribute,
						  trait,kCTFontTraitsAttribute,nil];
	
	CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attr);
	if (!desc) return;
	CTFontRef aFont = CTFontCreateWithFontDescriptor(desc, size, NULL);
	CFRelease(desc);
	if (!aFont) return;
    
	[self removeAttribute:(NSString*)kCTFontAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTFontAttributeName value:(id)aFont range:range];
	CFRelease(aFont);
}

-(void)setTextColor:(UIColor*)color {
	[self setTextColor:color range:NSMakeRange(0,[self length])];
}
-(void)setTextColor:(UIColor*)color range:(NSRange)range {
	// kCTForegroundColorAttributeName
	[self removeAttribute:(NSString*)kCTForegroundColorAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
}

-(void)setTextIsUnderlined:(BOOL)underlined {
	[self setTextIsUnderlined:underlined range:NSMakeRange(0,[self length])];
}
-(void)setTextIsUnderlined:(BOOL)underlined range:(NSRange)range {
	int32_t style = underlined ? (kCTUnderlineStyleSingle|kCTUnderlinePatternSolid) : kCTUnderlineStyleNone;
	[self setTextUnderlineStyle:style range:range];
}
-(void)setTextUnderlineStyle:(int32_t)style range:(NSRange)range {
	[self removeAttribute:(NSString*)kCTUnderlineStyleAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTUnderlineStyleAttributeName value:[NSNumber numberWithInt:style] range:range];
}

-(void)setTextBold:(BOOL)isBold range:(NSRange)range {
	NSUInteger startPoint = range.location;
	NSRange effectiveRange;
	do {
		// Get font at startPoint
		CTFontRef currentFont = (CTFontRef)[self attribute:(NSString*)kCTFontAttributeName atIndex:startPoint effectiveRange:&effectiveRange];
		// The range for which this font is effective
		NSRange fontRange = NSIntersectionRange(range, effectiveRange);
		// Create bold/unbold font variant for this font and apply
		CTFontRef newFont = CTFontCreateCopyWithSymbolicTraits(currentFont, 0.0, NULL, (isBold?kCTFontBoldTrait:0), kCTFontBoldTrait);
		if (newFont) {
			[self removeAttribute:(NSString*)kCTFontAttributeName range:fontRange]; // Work around for Apple leak
			[self addAttribute:(NSString*)kCTFontAttributeName value:(id)newFont range:fontRange];
			CFRelease(newFont);
		} else {
			NSString* fontName = [(NSString*)CTFontCopyFullName(currentFont) autorelease];
			NSLog(@"[OHAttributedLabel] Warning: can't find a bold font variant for font %@. Try another font family (like Helvetica) instead.",fontName);
		}
		////[self removeAttribute:(NSString*)kCTFontWeightTrait range:fontRange]; // Work around for Apple leak
		////[self addAttribute:(NSString*)kCTFontWeightTrait value:(id)[NSNumber numberWithInt:1.0f] range:fontRange];
		
		// If the fontRange was not covering the whole range, continue with next run
		startPoint = NSMaxRange(effectiveRange);
	} while(startPoint<NSMaxRange(range));
}

-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode {
	[self setTextAlignment:alignment lineBreakMode:lineBreakMode range:NSMakeRange(0,[self length])];
}
-(void)setTextAlignment:(CTTextAlignment)alignment lineBreakMode:(CTLineBreakMode)lineBreakMode range:(NSRange)range {
	// kCTParagraphStyleAttributeName > kCTParagraphStyleSpecifierAlignment
	CTParagraphStyleSetting paraStyles[2] = {
		{.spec = kCTParagraphStyleSpecifierAlignment, .valueSize = sizeof(CTTextAlignment), .value = (const void*)&alignment},
		{.spec = kCTParagraphStyleSpecifierLineBreakMode, .valueSize = sizeof(CTLineBreakMode), .value = (const void*)&lineBreakMode},
	};
	CTParagraphStyleRef aStyle = CTParagraphStyleCreate(paraStyles, 2);
	[self removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(id)aStyle range:range];
	CFRelease(aStyle);
}

@end

