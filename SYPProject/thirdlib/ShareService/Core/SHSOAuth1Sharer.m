//
//  OAuthSharer.m
//  ShareDemo
//
//  Created by tmy on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SHSOAuth1Sharer.h"
#import "SHSAuthorizationController.h"
#import "SFHFKeychainUtils.h"
#import "SHSAPIKeys.h"
#import "OAuthInfo.h"

@implementation SHSOAuth1Sharer

@synthesize name, key, appKey=_appKey,secretKey=_secretKey,requestTokenURL=_requestTokenURL,autherizeURL=_autherizeURL,accessTokenURL=_accessTokenURL,callbackURL=_callbackURL,requestToken=_requestToken,accessToken=_accessToken,rootViewController,delegate,signatureProvider=_signatureProvider,oauthType,pendingShare,sharedText,sharedImage,sharedUrl;

- (id)init
{
    if(self=[super init])
    {
        self.pendingShare=-1;
    }
    
    return self;
}

- (void)dealloc
{
    self.signatureProvider=nil;
    self.appKey=nil;
    self.secretKey=nil;
    self.requestTokenURL=nil;
    self.autherizeURL=nil;
    self.accessTokenURL=nil;
    self.callbackURL=nil;
    self.requestToken=nil;
    self.accessToken=nil;
    [super dealloc];
}

- (void)beginOAuthVerification
{
    [self beginRequestForRequestToken];
}

- (void)beginRequestForRequestToken
{
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidBeginVerification:)]) {
        [self.delegate OAuthSharerDidBeginVerification:self];
    }
    OAConsumer *comsumer=[[OAConsumer alloc] initWithKey:self.appKey secret:self.secretKey] ;
    OAMutableURLRequest *request=[[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_requestTokenURL] consumer:comsumer token:nil realm:nil signatureProvider:_signatureProvider] autorelease];
    [request setHTTPMethod:@"GET"];
    
    if(![self.callbackURL isEqualToString:@""]) {
        [request setOAuthParameterName:@"oauth_callback" withValue:self.callbackURL];
    }
    
    OAAsynchronousDataFetcher *fetcher=[[OAAsynchronousDataFetcher alloc] initWithRequest:request delegate:self didFinishSelector:@selector(tokenRequestTicket:didFinishWithData:) didFailSelector:@selector(tokenRequestTicket:didFailWithError:)];
    [fetcher start];
    [fetcher release];
    [comsumer release];
}

- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if(ticket.didSucceed)
    {
        NSString *responseStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _requestToken=[[OAToken alloc] initWithHTTPResponseBody:responseStr];
        [responseStr release];
        [self beginRequestForAuthorization];
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(OAuthSharerDidFailInVerification:)])
            [self.delegate OAuthSharerDidFailInVerification:self];
    }
}

- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidFailInVerification:)])
        [self.delegate OAuthSharerDidFailInVerification:self];
}

- (void)beginRequestForAuthorization
{
    SHSAuthorizationController *authorizationController=[[SHSAuthorizationController alloc] init];
    authorizationController.authorizationURL=[NSString stringWithFormat:@"%@?oauth_token=%@",_autherizeURL,_requestToken.key];
    authorizationController.requestToken=_requestToken.key;
    authorizationController.authorizationDelegate=self;
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:authorizationController];
    if(self.rootViewController) {
        [self.rootViewController presentModalViewController:navController animated:YES];
    }
    [authorizationController release];
    [navController release];
}

- (void)beginRequestForAccessToken
{
    OAConsumer *comsumer=[[[OAConsumer alloc] initWithKey:_appKey secret:_secretKey] autorelease];
    OAMutableURLRequest *request=[[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_accessTokenURL] consumer:comsumer token:_requestToken realm:nil signatureProvider:_signatureProvider]autorelease];
    [request setHTTPMethod:@"POST"];
    [request setOAuthParameterName:@"oauth_verifier" withValue:_verifier];
    
    OAAsynchronousDataFetcher *fetcher=[[OAAsynchronousDataFetcher alloc] initWithRequest:request delegate:self didFinishSelector:@selector(tokenAccessTicket:didFinishWithData:) didFailSelector:@selector(tokenAccessTicket:didFailWithError:)];
    [fetcher start];
    [fetcher release];
}

- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    if(ticket.didSucceed)
    {
        NSString *responseStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        _accessToken=[[OAToken alloc] initWithHTTPResponseBody:responseStr];
        [responseStr release];
        [self SaveToken];
        
        if([self.delegate respondsToSelector:@selector(OAuthSharerDidFinishVerification:)])
            [self.delegate OAuthSharerDidFinishVerification:self];
        
        switch (self.pendingShare) {
            case ShareTypeText:
                [self shareText:self.sharedText];
                break;
            case ShareTypeTextAndImage:
                [self shareText:self.sharedText andImage:self.sharedImage];
                break;
            default:
                break;
        }
        self.pendingShare=-1;
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(OAuthSharerDidFailInVerification:)])
            [self.delegate OAuthSharerDidFailInVerification:self];
    }
}

- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidFailInVerification:)])
        [self.delegate OAuthSharerDidFailInVerification:self];
}

- (void)SaveToken
{
    [OAuthInfo save:_accessToken.key tokenSecret:_accessToken.secret for:self.getPlatformName ];
    
    //#ifdef TARGET_IPHONE_SIMULATOR  
    //    [[NSUserDefaults standardUserDefaults] setValue:_accessToken.key forKey:[NSString stringWithFormat:@"%@_%@",self.name,@"accessToken"]];
    //    [[NSUserDefaults standardUserDefaults] setValue:_accessToken.secret forKey:[NSString stringWithFormat:@"%@_%@",self.name,@"accessTokenSecret"]];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    //#else
    //    [SFHFKeychainUtils storeUsername: [NSString stringWithFormat:@"%@_%@",self.name,@"accessToken"] andPassword:_accessToken.key forServiceName: self.name updateExisting: YES  error: nil];
    //[SFHFKeychainUtils storeUsername: [NSString stringWithFormat:@"%@_%@",self.name,@"accessTokenSecret"] andPassword:_accessToken.secret forServiceName: //self.name updateExisting: YES  error: nil];
    //#endif
}

-(NSString *)getURL:(NSString *)url andSite:(NSString *)site 
{
    NSDictionary *config=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceConfig" ofType:@"plist"]];
    NSString *pattern = @"http://www.bshare.cn/burl?url=%@&publisherUuid=%@&site=%@";
    NSString *uuid = PUBLISHER_UUID;
    if (!uuid) {
        uuid = @"";
    }
    if (!site){
        site = @"";
    }
    if (url && [[config objectForKey:@"TrackClickBack"] boolValue]) {
        return [NSString stringWithFormat:pattern,url,uuid,site];
    } else if (url) {
        return [NSString stringWithString:url];
    }
    return @"";
}


- (BOOL)isVerified
{
    NSString *accessToken=nil;
    NSString *accessSecret=nil;
    
    //#ifdef TARGET_IPHONE_SIMULATOR
    //    accessToken= [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",self.name,@"accessToken"]];
    //    accessSecret= [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",self.name,@"accessTokenSecret"]];
    //#else
    //    accessToken= [SFHFKeychainUtils getPasswordForUsername: [NSString stringWithFormat:@"%@_%@",self.name,@"accessToken"] andServiceName: self.name error:nil];
    //accessSecret= [SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@_%@",self.name,@"accessTokenSecret"] andServiceName: self.name error:nil];
    //#endif
    accessToken = [OAuthInfo readAccessToken:self.getPlatformName];
    accessSecret = [OAuthInfo readAccessSecretToken:self.getPlatformName];
    
    if(accessToken!=nil && accessSecret!=nil)
    {
        _accessToken=[[OAToken alloc] initWithKey:accessToken secret:accessSecret];
        return YES;
    }
    else
        return NO;
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image;
{
    
}

- (void)shareText:(NSString *)text
{
    
}



#pragma mark - AuthorizationDelegate

- (void)authorizationDidFinishWithToken:(NSString *)token andVerifier:(NSString *)verifier
{
    _verifier=[verifier retain];
    [self beginRequestForAccessToken];
}

- (void)authorizationDidCancel
{
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidCancelVerification:)])
        [self.delegate OAuthSharerDidCancelVerification:self];
}

- (void)authorizationDidFail
{
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidFailInVerification:)])
        [self.delegate OAuthSharerDidFailInVerification:self];
}

@end
