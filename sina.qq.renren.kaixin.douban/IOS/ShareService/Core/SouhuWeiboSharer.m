//
//  SouhuWeiboSharer.m
//  ShareDemo
//
//  Created by mini2 on 2/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SouhuWeiboSharer.h"
#import "NSMutableURLRequest+FormData.h"
#import "SHSAPIKeys.h"
#import "DataStatistic.h"

#define url @"http://api.t.sohu.com/statuses/update.json"
#define TEXT_IMAGE_URL @"http://api.t.sohu.com/statuses/upload.json"

@implementation SouhuWeiboSharer

- (id)init
{
    if(self=[super init])
    {
        self.appKey=SOHUWEIBO_APP_KEY;
        self.secretKey=SOHUWEIBO_SECRET_KEY;
    }
    
    return self;
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image
{
    self.sharedText=text;
    self.sharedImage=image;
    
    if([self isVerified])
    {
        if([self.delegate respondsToSelector:@selector(OAuthSharerDidBeginShare:)])
            [self.delegate OAuthSharerDidBeginShare:self];
        
        OAConsumer *comsumer=[[[OAConsumer alloc] initWithKey:_appKey secret:_secretKey] autorelease];
        OAMutableURLRequest *request=[[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:TEXT_IMAGE_URL] consumer:comsumer token:_accessToken realm:nil signatureProvider:_signatureProvider]autorelease];
        request.shareType=ShareTypeTextAndImage;
        [request setHTTPMethod:@"POST"];
        NSString *status = [NSString stringWithFormat:@"%@ %@",text,[self getURL:self.sharedUrl andSite:@"sohuminiblog"]] ;
        [request setOAuthParameterName:@"status" withValue:[status URLEncodedString]];
        
        NSDictionary *textField=[NSDictionary dictionaryWithObject:[status URLEncodedString] forKey:@"status"];
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
    
    NSString *status = [NSString stringWithFormat:@"%@ %@",text,[self getURL:self.sharedUrl andSite:@"sohuminiblog"]] ;
        
        OAConsumer *comsumer=[[[OAConsumer alloc] initWithKey:_appKey secret:_secretKey] autorelease];
        OAMutableURLRequest *request=[[[OAMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] consumer:comsumer token:_accessToken realm:nil signatureProvider:_signatureProvider] autorelease];
        [request setHTTPMethod:@"POST"];
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

- (void)shareRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    DataStatistic *stat = [[DataStatistic alloc] init];
    [stat sendStatistic:self.sharedUrl site:@"sohuminiblog"];
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

-(bsPlatform)getPlatformName {
    return sohuminiblog;
}
@end
