//
//  SHSOAuth2Sharer.h
//  ShareDemo
//
//  Created by tmy on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHSOAuthSharer.h"
#import "SHSCommon.h"

@interface SHSOAuth2Sharer : NSObject<SHSOAuthSharerProtocol,AuthorizationDelegate>
{
    NSString *_appKey;
    NSString *_secretKey;
    NSString *_autherizeURL;
    OAToken *_accessToken;
    NSTimeInterval _expireTime;
}

@property (nonatomic,retain) NSString *appKey;
@property (nonatomic,retain) NSString *secretKey;
@property (nonatomic,retain) NSString *autherizeURL;
@property (nonatomic,retain) OAToken *accessToken;
@property (nonatomic,retain) NSString *callbackURL;
- (void)beginRequestForAccessToken;
@end
