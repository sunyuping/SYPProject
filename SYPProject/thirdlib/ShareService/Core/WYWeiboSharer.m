//
//  163WeiboSharer.m
//  ShareServiceDemo
//
//  Created by tmy on 12-1-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WYWeiboSharer.h"
#import "SHSAPIKeys.h"
#import "DataStatistic.h"

#define url @"http://api.t.163.com/statuses/update.json"


@implementation WYWeiboSharer
- (id)init
{
    if(self=[super init])
    {
        self.appKey=WYWEIBO_APP_KEY;
        self.secretKey=WYWEIBO_SECRET_KEY;
    }
    
    return self;
}

- (void)shareText:(NSString *)text
{
    self.sharedText=text;
    
    if([self isVerified])
    {
        if([self.delegate respondsToSelector:@selector(OAuthSharerDidBeginShare:)])
            [self.delegate OAuthSharerDidBeginShare:self];
        
        OAConsumer *comsumer=[[[OAConsumer alloc] initWithKey:_appKey secret:_secretKey] autorelease];
        OAMutableURLRequest *request=[[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] consumer:comsumer token:_accessToken realm:nil signatureProvider:_signatureProvider] autorelease];
        [request setHTTPMethod:@"POST"];
        NSString *status = [NSString stringWithFormat:@"%@ %@",text,[self getURL:self.sharedUrl andSite:@"neteasemb"]] ;

        [request setOAuthParameterName:@"status" withValue:[status URLEncodedString]];
        request.shareType=ShareTypeText;
        
        OAAsynchronousDataFetcher *fetcher=[[OAAsynchronousDataFetcher alloc] initWithRequest:request delegate:self didFinishSelector:@selector(shareRequestTicket:didFinishWithData:) didFailSelector:@selector(shareRequestTicket:didFailWithError:)];
        [fetcher start];
        [fetcher release];
        
    }
    else
    {   
        self.pendingShare=ShareTypeText;
        [self beginOAuthVerification];
    }
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image
{
    [self shareText:text];
}

- (void)shareRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    DataStatistic *stat = [[DataStatistic alloc] init];
    [stat sendStatistic:self.sharedUrl site:@"neteasemb"];
    [stat release];
    
    NSString *responseStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [responseStr release];
    self.sharedText=nil;
    self.sharedImage=nil;
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidFinishShare:)])
        [self.delegate OAuthSharerDidFinishShare:self];
}

- (void)shareRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error
{
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidFailShare:)])
        [self.delegate OAuthSharerDidFailShare:self];
}

- (void)beginRequestForAccessToken
{
    OAConsumer *comsumer=[[[OAConsumer alloc] initWithKey:_appKey secret:_secretKey] autorelease];
    OAMutableURLRequest *request=[[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:_accessTokenURL] consumer:comsumer token:_requestToken realm:nil signatureProvider:_signatureProvider] autorelease];
    [request setHTTPMethod:@"POST"];
    
    OAAsynchronousDataFetcher *fetcher=[[OAAsynchronousDataFetcher alloc] initWithRequest:request delegate:self didFinishSelector:@selector(tokenAccessTicket:didFinishWithData:) didFailSelector:@selector(tokenAccessTicket:didFailWithError:)];
    [fetcher start];
    [fetcher release];
}


-(bsPlatform)getPlatformName {
    return neteasewb;
}

@end
