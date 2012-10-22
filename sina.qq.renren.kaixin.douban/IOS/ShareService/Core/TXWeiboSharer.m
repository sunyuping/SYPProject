//
//  TXWeiboSharer.m
//  ShareDemo
//
//  Created by mini2 on 2/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TXWeiboSharer.h"
#import "TXWeiboRequest.h"
#import "NSMutableURLRequest+FormData.h"
#import "SHSAPIKeys.h"
#import "DataStatistic.h"


#define url @"http://open.t.qq.com/api/t/add"
#define TEXT_IMAGE_URL @"http://open.t.qq.com/api/t/add_pic"

@implementation TXWeiboSharer

- (id)init
{
    if(self=[super init])
    {
        self.appKey=TXWEIBO_APP_KEY;
        self.secretKey=TXWEIBO_SECRET_KEY;
    }
    
    return self;
}

- (void)beginRequestForRequestToken
{
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidBeginVerification:)])
        [self.delegate OAuthSharerDidBeginVerification:self];
    
    OAConsumer *comsumer=[[[OAConsumer alloc] initWithKey:_appKey secret:_secretKey] autorelease];
    TXWeiboRequest *request=[[[TXWeiboRequest alloc] initWithURL:[NSURL URLWithString:_requestTokenURL] consumer:comsumer token:nil realm:nil signatureProvider:_signatureProvider] autorelease];
    
    [request setHTTPMethod:@"GET"];
    
    if(![self.callbackURL isEqualToString:@""])
        [request setOAuthParameterName:@"oauth_callback" withValue:self.callbackURL];
    
    
    OAAsynchronousDataFetcher *fetcher=[[OAAsynchronousDataFetcher alloc] initWithRequest:request delegate:self didFinishSelector:@selector(tokenRequestTicket:didFinishWithData:) didFailSelector:@selector(tokenRequestTicket:didFailWithError:)];
    [fetcher start];
    [fetcher release];
}

- (void)beginRequestForAccessToken
{
    OAConsumer *comsumer=[[[OAConsumer alloc] initWithKey:_appKey secret:_secretKey] autorelease];
    TXWeiboRequest *request=[[[TXWeiboRequest alloc] initWithURL:[NSURL URLWithString:_accessTokenURL] consumer:comsumer token:_requestToken realm:nil signatureProvider:_signatureProvider] autorelease];
    [request setHTTPMethod:@"POST"];
    [request setOAuthParameterName:@"oauth_verifier" withValue:_verifier];
    
    OAAsynchronousDataFetcher *fetcher=[[OAAsynchronousDataFetcher alloc] initWithRequest:request delegate:self didFinishSelector:@selector(tokenAccessTicket:didFinishWithData:) didFailSelector:@selector(tokenAccessTicket:didFailWithError:)];
    [fetcher start];
    [fetcher release];
}


- (void)shareText:(NSString *)text andImage:(UIImage *)image;
{
    self.sharedText=text;
    self.sharedImage=image;
    
    if([self isVerified])
    {
        if([self.delegate respondsToSelector:@selector(OAuthSharerDidBeginShare:)])
            [self.delegate OAuthSharerDidBeginShare:self];
        
        OAConsumer *comsumer=[[[OAConsumer alloc] initWithKey:_appKey secret:_secretKey] autorelease];
        TXWeiboRequest *request=[[[TXWeiboRequest alloc] initWithURL:[NSURL URLWithString:TEXT_IMAGE_URL] consumer:comsumer token:_accessToken realm:nil signatureProvider:_signatureProvider] autorelease];
        request.shareType=ShareTypeTextAndImage;
        [request setHTTPMethod:@"POST"];
        NSString *status = [NSString stringWithFormat:@"%@ %@",text,[self getURL:self.sharedUrl andSite:@"qqmb"]] ;
        [request setOAuthParameterName:@"content" withValue:status];
        
        NSDictionary *textField=[NSDictionary dictionaryWithObject:status forKey:@"content"];
        NSDictionary *fileField=[NSDictionary dictionaryWithObject:UIImageJPEGRepresentation(image, 0.6) forKey:@"pic"];
        [request setFormDataWithTextField:textField withFileField:fileField];
        
        
        OAAsynchronousDataFetcher *fetcher=[[OAAsynchronousDataFetcher alloc] initWithRequest:request delegate:self didFinishSelector:@selector(shareRequestTicket:didFinishWithData:) didFailSelector:@selector(shareRequestTicket:didFailWithError:)];
        [fetcher start];
        [fetcher release];

    }
    else
    {
        self.pendingShare=ShareTypeTextAndImage;
        [self beginOAuthVerification];
    }
}

- (void)shareText:(NSString *)text
{
    self.sharedText=text;
    
      if([self isVerified])
      {
          if([self.delegate respondsToSelector:@selector(OAuthSharerDidBeginShare:)])
              [self.delegate OAuthSharerDidBeginShare:self];
          
          OAConsumer *comsumer=[[[OAConsumer alloc] initWithKey:_appKey secret:_secretKey] autorelease];
          TXWeiboRequest *request=[[[TXWeiboRequest alloc] initWithURL:[NSURL URLWithString:url] consumer:comsumer token:_accessToken realm:nil signatureProvider:_signatureProvider]autorelease];
          request.shareType=ShareTypeText;
          [request setHTTPMethod:@"POST"];
          NSString *status = [NSString stringWithFormat:@"%@ %@",text,[self getURL:self.sharedUrl andSite:@"qqmb"]] ;
          [request setOAuthParameterName:@"content" withValue:status];
          
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

- (void)shareRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    DataStatistic *stat = [[DataStatistic alloc] init];
    [stat sendStatistic:self.sharedUrl site:@"qqmb"];
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
        [self.delegate OAuthSharerDidFailShare:self];}

-(bsPlatform)getPlatformName {
    return qqwb;
}

@end
