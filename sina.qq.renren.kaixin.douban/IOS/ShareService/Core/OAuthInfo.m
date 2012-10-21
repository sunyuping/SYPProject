    //
    //  OAuthInfo.m
    //  ShareServiceDemo
    //
    //  Created by Buzzinate Buzzinate on 12-5-15.
    //  Copyright (c) 2012年 Buzzinate Co. Ltd. All rights reserved.
    //

#import "OAuthInfo.h"
#import "SFHFKeychainUtils.h"

#define ACCESS_TOKEN @"accessToken"
#define ACCESS_TOKEN_SECRET @"accessTokenSecret"

@implementation NSString (bsOauthInfo)

+(NSString *)stringWithPlatform:(bsPlatform)platform {
    switch (platform) {
        case kaixin:
        {
        return PLATFORM_KAIXIN;
        }
        case renren: {
            return PLATFORM_RENREN;
        }
        case sohuminiblog: {
            return PLATFORM_SOHUWB;
        }
        case neteasewb: {
            return PLATFORM_NETEASEWB;
        }
        case sinawb :{
            return PLATFORM_SINAWB;
        } 
        case sinawb2: {
            return PLATFORM_SINAWB2;
        }
        case qqwb: {
            return PLATFORM_QQWB;
        }
        default:
            return nil;
    }
}

@end

@implementation OAuthInfo
+(void) save:(NSString *)accessToken tokenSecret:(NSString *)tokenSecret for:(bsPlatform)platformName { 
#if TARGET_IPHONE_SIMULATOR
[[NSUserDefaults standardUserDefaults] setValue: accessToken forKey:[NSString stringWithFormat:@"%@_%@",[NSString stringWithPlatform:platformName],ACCESS_TOKEN]];
[[NSUserDefaults standardUserDefaults] setValue: tokenSecret forKey:[NSString stringWithFormat:@"%@_%@",[NSString stringWithPlatform:platformName],ACCESS_TOKEN_SECRET]];
[[NSUserDefaults standardUserDefaults] synchronize];

#else
[SFHFKeychainUtils storeUsername: [NSString stringWithFormat:@"%@_%@",[NSString stringWithPlatform:platformName],ACCESS_TOKEN] andPassword:accessToken forServiceName:[NSString stringWithPlatform:platformName] updateExisting:TRUE error:nil ];
[SFHFKeychainUtils storeUsername: [NSString stringWithFormat:@"%@_%@",[NSString stringWithPlatform:platformName],ACCESS_TOKEN_SECRET] andPassword:tokenSecret forServiceName:[NSString stringWithPlatform:platformName] updateExisting:TRUE error:nil ];
#endif
}

+(NSString *)readAccessToken:(bsPlatform)platformName {
#if TARGET_IPHONE_SIMULATOR
    NSString *accessToken= [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",[NSString stringWithPlatform:platformName],ACCESS_TOKEN]];
    return accessToken;
#else
    NSString *accessToken = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@_%@",[NSString stringWithPlatform:platformName],ACCESS_TOKEN] andServiceName:[NSString stringWithPlatform:platformName] error:nil];
    return accessToken;
#endif
}

+(NSString *)readAccessSecretToken:(bsPlatform)platformName{
#if TARGET_IPHONE_SIMULATOR
    NSString* accessSecret= [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",[NSString stringWithPlatform:platformName],ACCESS_TOKEN_SECRET]];
    return accessSecret;
#else
    NSString *accessSecret = [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@_%@",[NSString stringWithPlatform:platformName],ACCESS_TOKEN_SECRET]   andServiceName:[NSString stringWithPlatform: platformName] error:nil];
    return accessSecret;
#endif
}

+(void) logout {
#if TARGET_IPHONE_SIMULATOR
    NSArray *keys = [[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] copy];
    for(NSString *key in keys) {
        if ([key hasSuffix: ACCESS_TOKEN_SECRET] || [key hasSuffix:ACCESS_TOKEN_SECRET]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
    }
    [keys release];
#else
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_KAIXIN,ACCESS_TOKEN] andServiceName: PLATFORM_KAIXIN error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_NETEASEWB,ACCESS_TOKEN] andServiceName: PLATFORM_NETEASEWB error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_QQWB,ACCESS_TOKEN] andServiceName: PLATFORM_QQWB error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_RENREN,ACCESS_TOKEN] andServiceName: PLATFORM_RENREN error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_SINAWB,ACCESS_TOKEN] andServiceName: PLATFORM_SINAWB error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_SOHUWB,ACCESS_TOKEN] andServiceName: PLATFORM_SOHUWB error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_SINAWB2,ACCESS_TOKEN] andServiceName: PLATFORM_SINAWB2 error: nil];
    
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_KAIXIN,ACCESS_TOKEN_SECRET] andServiceName: PLATFORM_KAIXIN error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_NETEASEWB,ACCESS_TOKEN_SECRET] andServiceName: PLATFORM_NETEASEWB error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_QQWB,ACCESS_TOKEN_SECRET] andServiceName: PLATFORM_QQWB error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_RENREN,ACCESS_TOKEN_SECRET] andServiceName: PLATFORM_RENREN error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_SINAWB,ACCESS_TOKEN_SECRET] andServiceName: PLATFORM_SINAWB error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_SOHUWB,ACCESS_TOKEN_SECRET] andServiceName: PLATFORM_SOHUWB error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",PLATFORM_SINAWB2,ACCESS_TOKEN_SECRET] andServiceName: PLATFORM_SINAWB2 error: nil];
#endif
}

+(void) logout:(bsPlatform)platformName {  
#if TARGET_IPHONE_SIMULATOR
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_%@",[NSString stringWithPlatform:platformName],@"accessToken"]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%@_%@",[NSString stringWithPlatform:platformName],@"accessTokenSecret"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
#else
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",[NSString stringWithPlatform:platformName],ACCESS_TOKEN] andServiceName: [NSString stringWithPlatform:platformName] error: nil];
    [SFHFKeychainUtils deleteItemForUsername: [NSString stringWithFormat:@"%@_%@",[NSString stringWithPlatform:platformName],ACCESS_TOKEN_SECRET] andServiceName: [NSString stringWithPlatform:platformName] error: nil];
#endif
}
@end
