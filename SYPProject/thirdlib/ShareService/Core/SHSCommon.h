//
//  SHSCommon.h
//  ShareDemo
//
//  Created by tmy on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"

//服务认证类型
typedef enum 
{
    OAuthTypeOAuth1WithHeader=0,
    OAuthTypeOAuth1WithQueryString=1,
    OAuthTypeOAuth2=2,
    OAuthTypeNone=5 
}OAuthType;

//分享类型
typedef enum 
{
    ShareTypeText=0,        //仅分享文字
    ShareTypeTextAndImage=1 //分享文字和图片
}ShareType;


@protocol AuthorizationDelegate <NSObject>

@optional
- (void)authorizationDidFinishWithToken:(NSString *)token andVerifier:(NSString *)verifier; //OAuth1.0
- (void)authorizationDidFinishWithAccessToken:(NSString *)token withExpireTime:(NSTimeInterval)expire; //OAuth2.0
- (void)authorizationDidCancel;
- (void)authorizationDidFail;

@end