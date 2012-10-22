//
//  RenRenSharer.m
//  ShareDemo
//
//  Created by mini2 on 2/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RenRenSharer.h"
#import "SHSAuthorization2Controller.h"
#import "SHSAPIKeys.h"
#import "DataStatistic.h"

#define url @"http://api.renren.com/restserver.do"

@implementation RenRenSharer

- (id)init
{
    if(self=[super init])
    {
        _responseData=[[NSMutableData alloc] init];
        self.appKey=RENREN_APP_KEY;
        self.secretKey=RENREN_SECRET_KEY;
    }
    
    return self;
}


- (void)dealloc
{
    if(_responseData)
      [_responseData release];
    [super dealloc];
}

- (void)beginRequestForAccessToken
{
    SHSAuthorization2Controller *authorizationController=[[SHSAuthorization2Controller alloc] init];
    authorizationController.authorizationURL=[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=status_update",_autherizeURL,_appKey,self.callbackURL];
    authorizationController.authorizationDelegate=self;
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:authorizationController];
    if(self.rootViewController)
        [self.rootViewController presentModalViewController:navController animated:YES];
    [authorizationController release];
    [navController release];
}


- (void)shareText:(NSString *)text
{
    self.sharedText=text;
    
    if([self isVerified])
    {
        if([self.delegate respondsToSelector:@selector(OAuthSharerDidBeginShare:)])
            [self.delegate OAuthSharerDidBeginShare:self];
        
        NSString *method=@"status.set";
        NSString *status = [NSString stringWithFormat:@"%@ %@",text,[self getURL:self.sharedUrl andSite:@"renren"]] ;
        NSString * sigBaseString=[NSString stringWithFormat:@"access_token=%@method=%@status=%@v=1.0%@",_accessToken.key,method,status,_secretKey];
        NSString *sig=[self md5:sigBaseString];
        NSString *postStr=[NSString stringWithFormat:@"access_token=%@&sig=%@&method=%@&status=%@&v=1.0",_accessToken.key,sig,method,[status URLEncodedString]];
        NSMutableURLRequest *request=[[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]] autorelease];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[postStr dataUsingEncoding:NSUTF8StringEncoding]];
        NSURLConnection *con=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        [con release];
        DataStatistic *stat = [[DataStatistic alloc] init];
        [stat sendStatistic:self.sharedUrl site:@"renren"];
        [stat release];
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

-(NSString *)md5:(NSString *)str { 
    const char *cStr = [str UTF8String]; 
    unsigned char result[16]; 
    CC_MD5( cStr, strlen(cStr), result ); 
    return [NSString stringWithFormat: 
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7], 
            result[8], result[9], result[10], result[11], 
            result[12], result[13], result[14], result[15] 
            ]; 
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_responseData appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSString *responseStr=[[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    if([self.delegate respondsToSelector:@selector(OAuthSharerDidFinishShare:)])
        [self.delegate OAuthSharerDidFinishShare:self];
}

-(bsPlatform)getPlatformName {
    return renren;
}


@end
