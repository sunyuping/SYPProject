    //
    //  SinaWeiboSharer2.m
    //  ShareServiceDemo
    //
    //  Created by Buzzinate Buzzinate on 12-7-1.
    //  Copyright (c) 2012年 Buzzinate Co. Ltd. All rights reserved.
    //

#import "SinaWeiboSharer2.h"
#import "SHSAuthorization2Controller.h"
#import "SHSAPIKeys.h"
#import "DataStatistic.h"

@implementation SinaWeiboSharer2
@synthesize request=_request;

- (id)init {
    
    if (self=[super init]) {
        self.appKey = SINAWEIBO_APP_KEY;
        self.secretKey = SINAWEIBO_SECRET_KEY;
    }
    return self;
}

- (void)dealloc
{
    [self.request disconnect];
    self.request = nil;
    [super dealloc];
}

- (void)beginRequestForAccessToken
{
    SHSAuthorization2Controller *authorizationController=[[SHSAuthorization2Controller alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token",self.autherizeURL,self.appKey,[self.callbackURL URLEncodedString ]];
    authorizationController.authorizationURL= url;
    authorizationController.authorizationDelegate=self;
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:authorizationController];
    if(self.rootViewController)
        [self.rootViewController presentModalViewController:navController animated:YES];
    [authorizationController release];
    [navController release];
}


-(void)shareText:(NSString *)text {
    self.sharedText=text;
    
    if([self isVerified])
        {
        if([self.delegate respondsToSelector:@selector(OAuthSharerDidBeginShare:)])
            [self.delegate OAuthSharerDidBeginShare:self];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
        
            //NSString *sendText = [text URLEncodedString];
        NSString *status = [[NSString alloc]initWithFormat:@"%@ %@",text,self.sharedUrl];
        [params setObject:(status ? status : @"") forKey:@"status"];
        [self.request disconnect];
        self.request = [WBRequest requestWithAccessToken:[self.accessToken key]
                                                     url:[NSString stringWithFormat:@"%@%@", kWBSDKAPIDomain, @"statuses/update.json"]
                                              httpMethod:@"POST"
                                                  params:params
                                            postDataType:kWBRequestPostDataTypeNormal
                                        httpHeaderFields:nil
                                                delegate:self];
        [self.request connect];
        
        }
    else
        {
        self.pendingShare=ShareTypeText;
        [self beginOAuthVerification];
        }
    
}

-(void)shareText:(NSString *)text andImage:(UIImage *)image {
    self.sharedText=text;
    self.sharedImage=image;
    
    if([self isVerified])
        {
        
        if([self.delegate respondsToSelector:@selector(OAuthSharerDidBeginShare:)])
            [self.delegate OAuthSharerDidBeginShare:self];
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:2];
        NSString *status = [[NSString alloc]initWithFormat:@"%@ %@",text,self.sharedUrl];
            //NSString *sendText = [text URLEncodedString];
        
        [params setObject:(status ? status : @"") forKey:@"status"];
        [self.request disconnect];
        
        if (image)
            {
            [params setObject:image forKey:@"pic"];
            self.request = [WBRequest requestWithAccessToken:[self.accessToken key]
                                                         url:[NSString stringWithFormat:@"%@%@", kWBSDKAPIDomain, @"statuses/upload.json"]
                                                  httpMethod:@"POST"
                                                      params:params
                                                postDataType:kWBRequestPostDataTypeMultipart
                                            httpHeaderFields:nil
                                                    delegate:self];
            }
        else
            {
            
            self.request = [WBRequest requestWithAccessToken:[self.accessToken key]
                                                         url:[NSString stringWithFormat:@"%@%@", kWBSDKAPIDomain, @"statuses/update.json"]
                                                  httpMethod:@"POST"
                                                      params:params
                                                postDataType:kWBRequestPostDataTypeNormal
                                            httpHeaderFields:nil
                                                    delegate:self];
            }
        
        [self.request connect];
        
        }
    else
        {
        self.pendingShare=ShareTypeTextAndImage;
        [self beginOAuthVerification];
        }
}


#pragma mark - WBRequestDelegate Methods

- (void)request:(WBRequest *)request didFinishLoadingWithResult:(id)result
{

    if([self.delegate respondsToSelector:@selector(OAuthSharerDidFinishShare:)])
        [self.delegate OAuthSharerDidFinishShare:self];
    
    DataStatistic *stat = [[DataStatistic alloc] init];
    [stat sendStatistic:self.sharedUrl site:@"sinaminiblog"];
    [stat release];
}

- (void)request:(WBRequest *)request didFailWithError:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidFailShare:)])
        [self.delegate OAuthSharerDidFailShare:self];
}

-(bsPlatform)getPlatformName {
    return sinawb2;
}

@end
