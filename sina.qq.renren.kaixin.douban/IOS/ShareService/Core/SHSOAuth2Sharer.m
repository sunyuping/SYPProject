//
//  SHSOAuth2Sharer.m
//  ShareDemo
//
//  Created by tmy on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SHSOAuth2Sharer.h"
#import "SHSAuthorization2Controller.h"
#import "SHSAPIKeys.h"
#import "OAuthInfo.h"

@implementation SHSOAuth2Sharer
@synthesize oauthType,name,key,delegate,rootViewController,autherizeURL=_autherizeURL,callbackURL,appKey=_appKey,secretKey=_secretKey,accessToken=_accessToken,pendingShare,sharedText,sharedImage, sharedUrl;


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
    self.appKey=nil;
    self.secretKey=nil;
    self.autherizeURL=nil;
    self.callbackURL=nil;
    self.accessToken=nil;
    [super dealloc];
}

- (void)beginOAuthVerification
{
    [self beginRequestForAccessToken];
}

- (void)beginRequestForAccessToken
{
//    SHSAuthorization2Controller *authorizationController=[[SHSAuthorization2Controller alloc] init];
//    authorizationController.authorizationURL=[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token",_autherizeURL,_appKey,self.callbackURL];
//    authorizationController.authorizationDelegate=self;
//    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:authorizationController];
//    if(self.rootViewController)
//        [self.rootViewController presentModalViewController:navController animated:YES];
//    [authorizationController release];
//    [navController release];
}

- (void)SaveToken
{
    [OAuthInfo save:_accessToken.key tokenSecret:[[NSNumber numberWithFloat:_expireTime] stringValue] for:self.getPlatformName];
}


- (BOOL)isVerified
{
    NSString *accessToken=nil;
    NSTimeInterval expireTime=0;
    NSTimeInterval now=[NSDate timeIntervalSinceReferenceDate];
//#ifdef TARGET_IPHONE_SIMULATOR
//    accessToken= [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",self.name,@"accessToken"]];
//    expireTime= [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@",self.name,@"expireTime"]] floatValue];
//#else
//    accessToken= [SFHFKeychainUtils getPasswordForUsername: [NSString stringWithFormat:@"%@_%@",self.name,@"accessToken"] andServiceName: _name error:nil];
//    expireTime= [[SFHFKeychainUtils getPasswordForUsername:[NSString stringWithFormat:@"%@_%@",self.name,@"expireTime"] andServiceName: _name error:nil] floatValue];
//#endif
    
    accessToken = [OAuthInfo readAccessToken:self.getPlatformName];
    expireTime = [[OAuthInfo readAccessSecretToken:self.getPlatformName]floatValue];
    
    if(accessToken!=nil && expireTime!=0 && now<expireTime)
    {
        _accessToken=[[OAToken alloc] initWithKey:accessToken secret:@""];
        _expireTime=expireTime;
        return YES;
    }
    else
        return NO;
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


- (void)shareText:(NSString *)text
{
    
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image
{
    
}

#pragma mark - AuthorizationDelegate


- (void)authorizationDidFinishWithAccessToken:(NSString *)token withExpireTime:(NSTimeInterval)expire
{
    _accessToken=[[OAToken alloc] initWithKey:token secret:@""];
    _expireTime=[NSDate timeIntervalSinceReferenceDate]+expire;
    [self SaveToken];
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidFinishVerification:)])
        [self.delegate OAuthSharerDidFinishVerification:self];
    
    switch (self.pendingShare) {
        case ShareTypeText:
            [self shareText:self.sharedText];
            break;
        default:
            break;
    }
    self.pendingShare=-1;
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
