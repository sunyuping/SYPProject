//
//  NSStringAddition.m
//  XYCore
//
//  Created by sunyuping on 13-1-23.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "NSStringAddition.h"
#import <CommonCrypto/CommonDigest.h>



@implementation NSString(Query)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)escapeForPost {
	NSArray *escapeChars = [NSArray arrayWithObjects:@"&", nil];
	
	NSArray *replaceChars = [NSArray arrayWithObjects:@"\\&", nil];
	
	int len = [escapeChars count];
	
	NSString *tempStr = self;
	
	if (tempStr == nil) {
		return nil;
	}
	
	NSMutableString *temp = [tempStr mutableCopy];
	
	int i;
	for (i = 0; i < len; i++) {
		
		[temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
							  withString:[replaceChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
	}
	
	NSString *outStr = [NSString stringWithString: temp];
	
	[temp release];
	
	return outStr;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*) urlEncode:(NSStringEncoding)stringEncoding {
	
	NSArray *escapeChars = [NSArray arrayWithObjects:/*@";", */@"/", /*@"?", */@":",
							/*@"@", @"&", @"=", */@"+", /*@"$", @",", @"!",
                                                         @"'", @"(", @")", @"*", */@"-", nil];
	
	NSArray *replaceChars = [NSArray arrayWithObjects:/*@"%3B", */@"%2F", /*@"%3F", */@"%3A",
							 /*@"%40", @"%26", @"%3D",*/@"%2B", /*@"%24", @"%2C", @"%21",
                                                                 @"%27", @"%28", @"%29", @"%2A", */@"%2D", nil];
	
	int len = [escapeChars count];
	
	NSString *tempStr = [self stringByAddingPercentEscapesUsingEncoding:stringEncoding];
	
	if (tempStr == nil) {
		return nil;
	}
	
	NSMutableString *temp = [tempStr mutableCopy];
	
	int i;
	for (i = 0; i < len; i++) {
		
		[temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
							  withString:[replaceChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
	}
	
	NSString *outStr = [NSString stringWithString: temp];
	
	[temp release];
	
	return outStr;
}
- (NSString *)stringByReplaceString:(NSString *)rs withCharacter:(char)c {
	NSMutableString *ms = [NSMutableString stringWithCapacity:[self length]];
    
	int l = [self length];
	NSRange range;
	NSString *tmps;
	for (int i = 0; i<l; ) {
		tmps = [self substringFromIndex:i];
		range = [tmps rangeOfString:rs];
		if (range.length > 0) {
			[ms appendFormat:@"%@%c",[tmps substringToIndex:range.location],c];
			i += range.location + range.length;
		}else {
			[ms appendString:tmps];
			break;
		}
        
	}
    
	return ms;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*) urlEncode2:(NSStringEncoding)stringEncoding
{
	
	NSArray *escapeChars = [NSArray arrayWithObjects:@";", @"/", @"?", @":",
							@"@", @"&", @"=", @"+", @"$", @",", @"!",
                            @"'", @"(", @")", @"*", @"-", @"~", @"_", nil];
	
	NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B", @"%2F", @"%3F", @"%3A",
							 @"%40", @"%26", @"%3D", @"%2B", @"%24", @"%2C", @"%21",
                             @"%27", @"%28", @"%29", @"%2A", @"%2D", @"%7E", @"%5F", nil];
	
	int len = [escapeChars count];
	
	NSString *tempStr = [self stringByAddingPercentEscapesUsingEncoding:stringEncoding];
	
	if (tempStr == nil) {
		return nil;
	}
	
	NSMutableString *temp = [tempStr mutableCopy];
	
	int i;
	for (i = 0; i < len; i++) {
		
		[temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
							  withString:[replaceChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
	}
	
	NSString *outStr = [NSString stringWithString: temp];
	
	[temp release];
	
	return outStr;
}

- (NSString*) urlDecode:(NSStringEncoding)stringEncoding
{
    
	NSArray *escapeChars = [NSArray arrayWithObjects:@";", @"/", @"?", @":",
							@"@", @"&", @"=", @"+", @"$", @",", @"!",
                            @"'", @"(", @")", @"*", @"-", @"~", @"_", nil];
	
	NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B", @"%2F", @"%3F", @"%3A",
							 @"%40", @"%26", @"%3D", @"%2B", @"%24", @"%2C", @"%21",
                             @"%27", @"%28", @"%29", @"%2A", @"%2D", @"%7E", @"%5F", nil];
	
	int len = [escapeChars count];
	
	NSMutableString *temp = [self mutableCopy];
	
	int i;
	for (i = 0; i < len; i++) {
		
		[temp replaceOccurrencesOfString:[replaceChars objectAtIndex:i]
							  withString:[escapeChars objectAtIndex:i]
								 options:NSLiteralSearch
								   range:NSMakeRange(0, [temp length])];
	}
	NSString *outStr = [NSString stringWithString: temp];
	[temp release];
	
	return [outStr stringByReplacingPercentEscapesUsingEncoding:stringEncoding];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*) md5
{
	const char *cStr = [self UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
    if(cStr)
    {
        CC_MD5( cStr, strlen(cStr), result );
        return [[NSString stringWithFormat:
                 @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                 result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
                 ] lowercaseString];
    }
    else {
        return nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*) queryIdentifier {
	NSString* str = [self stringByReplacingOccurrencesOfString:@"&" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"=" withString:@""];
	str = [NSString stringWithFormat:@"%@", [str urlEncode:NSUTF8StringEncoding]];
	return str;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

+ (NSString *)queryStringFromQueryDictionary:(NSDictionary *)query withURLEncode:(BOOL)doURLEncode{
	if (!query) {
		return nil;
	}
	
	NSMutableString *buffer = [[NSMutableString alloc] initWithCapacity:0];
	// 将查询字典参数拼接成字符串,URL Encode
	for (id key in query) {
		NSString* value = [NSString stringWithFormat:@"%@",[query objectForKey:key]];
		if (doURLEncode) {
			value = [value urlEncode2:NSUTF8StringEncoding];
		}
		[buffer appendString:[NSString stringWithFormat:@"&%@=%@", key, value]];
	}
	
	NSString* ret = [buffer substringFromIndex:1]; // 去掉第一个'&'
	[buffer release];
	
	return ret;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
+ (NSString*)componentsJoinedByDictionary:(NSDictionary *)dic
								seperator:(NSString *)seperator {
	if (!dic || dic.count == 0) {
		return nil;
	}
	NSArray *allkeys = [dic allKeys];
	NSMutableString *ms = [NSMutableString string];
	for (NSString *key in allkeys) {
		[ms appendFormat:@"%@%@=%@", seperator, key, [dic objectForKey:key]];
	}
	return [ms substringFromIndex:1];
}


// Trim whitespace
- (NSString *)trim {
	NSInteger len = [self length];
	if (len == 0) {
		return self;
	}
	const char *data = [self UTF8String];
	NSInteger start;
	for (start = 0; start < len && data[start] <= 32; ++start) {
		// just advance
	}
	NSInteger end;
	for (end = len - 1; end > start && data[end] <= 32; --end) {
		// just advance
	}
	return [self substringWithRange:NSMakeRange(start, end - start + 1)];
}

- (NSString *) stringTrimAsNewsfeed {
	// 去掉换行.
	NSString *content = self;
	content = [content stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
	content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
	// 去掉空格
	while ([content rangeOfString:@"  "].location != NSNotFound) {
		content = [content stringByReplacingOccurrencesOfString:@"  " withString:@" "];
	};
	content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return content;
}

- (NSNumber*) stringToNumber
{
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	NSNumber *number = [numberFormatter numberFromString:self];
	[numberFormatter release];
	return number;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByFilterForStatusFromRest {
	NSString* dest = [self stringByReplacingOccurrencesOfString:@"&shy;" withString:@""];
	
	NSMutableCharacterSet* cs = [[NSMutableCharacterSet alloc] init];
	[cs addCharactersInRange:NSMakeRange(0x00ad, 1)];
	dest = [dest stringByTrimmingCharactersInSet:cs];
	[cs release];
	return dest;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)stringByTrimmingWhitespace {
	
	NSMutableString* ms = [NSMutableString stringWithString:self];
	unichar preChar = ' '; // 前一个字符.
	unichar ch;
	int size = self.length;
	for (int i = 0; i < size;) {
		ch = [ms characterAtIndex:i];
		if (' ' == preChar && ' ' == ch) {
			[ms deleteCharactersInRange:NSMakeRange(i, 1)];
			size--;
		} else if ('\n' == ch) {
			[ms deleteCharactersInRange:NSMakeRange(i, 1)];
			size--;
		} else {
			i++;
			preChar = ch;
		}
	}
	return ms;
}


- (NSString*)fillUniqueId:(NSInteger)uniqueId
{
    
    NSMutableString * strToReplace = [[[NSMutableString alloc] initWithString:self] autorelease];
    
    [strToReplace replaceOccurrencesOfString:@"{UNIQUEID}" withString:[NSString stringWithFormat:@"%d",uniqueId] options:NSASCIIStringEncoding range:NSMakeRange(0, [strToReplace length])];
    
    
    return strToReplace;
}

-(NSInteger)CountWord{
    int i,n=[self length],l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[self characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(NSInteger)ceilf((float)(a+b)/2.0);
}

-  (int)getCharLength{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
    
}

//为了方便图片的显示增加借口
-(NSString*)getUrlBySize:(NSInteger)size{
    if ([self length] <= 0) {//防止下面逻辑处理崩溃
        return @"";
    }
    NSMutableString *sizeurl = [NSMutableString stringWithCapacity:([self length]+8)];
    NSRange dotPosition = [self rangeOfString:@"." options:NSBackwardsSearch];
    [sizeurl appendFormat:@"%@_%d%@",[self substringToIndex:dotPosition.location],size,[self substringWithRange:NSMakeRange(dotPosition.location, self.length - dotPosition.location)]];
    return sizeurl;
    
}


+ (NSString *) preParseER:(NSString*)string {
	if (TRUE) {
		//return string;
	}
	NSMutableString *ms = [[NSMutableString alloc] init];
	int length = string.length;
	unichar ch;
	for (int i = 0; i < length; i++) {
		ch = [string characterAtIndex:i];
		if ('<' == ch) {
            //			[ms appendFormat:@"&lt;", @"%@"];
            [ms appendFormat:@"%@", @"&lt;"];
		} else if ('>' == ch) {
            //			[ms appendFormat: @"&gt;",@"%@"];
			[ms appendFormat: @"%@", @"&gt;"];
		} else if ('"' == ch) {
            //			[ms appendFormat:@"&quot;", @"%@"];
			[ms appendFormat: @"%@", @"&quot;"];
		} else if ('&' == ch) {
            //			[ms appendFormat:@"&amp;", @"%@"];
			[ms appendFormat: @"%@", @"&amp;"];
        }else if('\'' == ch){
            //            [ms appendFormat:@"&apos;",@"%@"];
            [ms appendFormat: @"%@", @"&apos;"];
		} else {
			[ms appendFormat:@"%C", ch];
		}
	}
    NSString *restring = [NSString stringWithString:ms];
    [ms release];
	return restring;
}


@end
