//
//  CCMD5.h
//  esBook
//
//  Created by  on 11-12-26.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#ifndef esBook_CCMD5_h
#define esBook_CCMD5_h

#import <CommonCrypto/CommonDigest.h>



static inline NSString* oc_md5_str(const NSString *input)
{
	if (input == nil || [input length] == 0) {
		return nil;
	}

	const char *cStr = [input UTF8String];
	unsigned char digest[16];
	CC_MD5(cStr, strlen(cStr), digest); // This is the md5 call
	
	NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
	
	for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	
	return  output;
}





#endif
