//
//  OAuthSharer.h
//  ShareDemo
//
//  Created by tmy on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHSCommon.h"
#import "SHSOAuthSharer.h"


@interface SHSOAuth1Sharer : NSObject<AuthorizationDelegate,SHSOAuthSharerProtocol>
{
    id<OASignatureProviding> _signatureProvider;
    NSString *_appKey;
    NSString *_secretKey;
    NSString *_verifier;
    OAToken *_requestToken;
    OAToken *_accessToken;
    NSString *_requestTokenURL;
    NSString *_autherizeURL;
    NSString *_accessTokenURL;
    NSString *_callbackURL;
}
@property (nonatomic,retain) id<OASignatureProviding> signatureProvider;
@property (nonatomic,retain) NSString *appKey;
@property (nonatomic,retain) NSString *secretKey;
@property (nonatomic,retain) NSString *requestTokenURL;
@property (nonatomic,retain) NSString *autherizeURL;
@property (nonatomic,retain) NSString *accessTokenURL;
@property (nonatomic,retain) NSString *callbackURL;
@property (nonatomic,retain) OAToken *requestToken;
@property (nonatomic,retain) OAToken *accessToken;


- (void)beginRequestForRequestToken;
- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;

- (void)beginRequestForAuthorization;

- (void)beginRequestForAccessToken;
- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;

@end


