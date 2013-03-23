//
//  OAuthInfo.h
//  ShareServiceDemo
//
//  Created by Buzzinate Buzzinate on 12-5-15.
//  Copyright (c) 2012年 Buzzinate Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PLATFORM_KAIXIN @"kaixin"
#define PLATFORM_RENREN @"renren"
#define PLATFORM_SOHUWB @"sohuminiblog"
#define PLATFORM_NETEASEWB @"neteasewb"
#define PLATFORM_QQWB @"qqwb"
#define PLATFORM_SINAWB @"sinawb"
#define PLATFORM_SINAWB2 @"sinawb2"
typedef enum {
    kaixin,renren,sohuminiblog,neteasewb,qqwb,sinawb,sinawb2
} bsPlatform;

@interface NSString (bsOauthInfo) 
+(NSString *) stringWithPlatform:(bsPlatform)platform;
@end

@interface OAuthInfo : NSObject
+(void) save:(NSString *) accessToken tokenSecret:(NSString *)tokenSecret for:(bsPlatform)platformName;
+(NSString *)readAccessToken:(bsPlatform)platformName;
+(NSString *)readAccessSecretToken:(bsPlatform)platformName;
+(void) logout:(bsPlatform)platformName;
+(void) logout;
@end
