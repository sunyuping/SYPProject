//
//  OpenSdkOauth.m
//  OpenSdkTest
//
//  Created by aine sun on 3/13/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "OpenSdkOauth.h"

/*
 * oauth2.0授权及调用api接口请求的base url
 */
static NSString *oauthRequestBaseURL = @"https://open.t.qq.com/cgi-bin/oauth2/";
static NSString *authPrefix = @"authorize";

/*
 * oauth2.0票据的key
 */
#define oauth2TokenKey @"access_token="

@implementation OpenSdkOauth

@synthesize appKey = _appKey;
@synthesize appSecret = _appSecret;
@synthesize redirectURI = _redirectURI;
@synthesize accessToken = _accessToken;
@synthesize accessSecret = _accessSecret;
@synthesize expireIn = _expireIn;
@synthesize openid = _openid;
@synthesize openkey = _openkey;
@synthesize oauthType = _oauthType;

#pragma -
#pragma mark init members

- (id)initAppKey:appKey appSecret:(NSString *)appSecret
{
	if ([super init]) 
	{
		[_appKey release];
        _appKey = [appKey copy];
		_appSecret = [appSecret copy];
        _redirectURI = [[NSString alloc] initWithString:[OpenSdkBase getRedirectUri]];
	}
	return self;
}

#pragma -
#pragma mark authorize in safari

- (BOOL)doSafariAuthorize:(BOOL)didOpenOtherApp
{
    BOOL didOpenAnotherApp = didOpenOtherApp;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _appKey, @"client_id",
                                   @"token", @"response_type",
                                   _redirectURI, @"redirect_uri",
                                   @"2", @"wap",
                                   nil];
    
	//NSLog(@"appkey is %@", _appKey);
	NSString *authorizeURL = [oauthRequestBaseURL stringByAppendingString:authPrefix];
    //NSLog(@"authorizeurl is %@", authorizeURL);
	
	// 先尝试从safari打开网页
    UIDevice *device = [UIDevice currentDevice];
    if ([device respondsToSelector:@selector(isMultitaskingSupported)] && [device isMultitaskingSupported]) 
    {
        if(!didOpenAnotherApp)
        {
            NSString *appUrl = [OpenSdkBase generateURL:authorizeURL params:params httpMethod:@"GET"];
            //NSLog(@"request url is %@", appUrl);
            didOpenAnotherApp = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
        }
    }
    return didOpenAnotherApp;
}

#pragma -
#pragma mark authorize in webView
- (void) doWebViewAuthorize:(UIWebView *)webView {
    
    _webView = webView;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   _appKey, @"client_id",
                                   @"token", @"response_type",
                                   @"2", @"wap",
                                   _redirectURI, @"redirect_uri",
                                   @"ios", @"appfrom",
                                   nil];
    NSString *authorizeURL = [oauthRequestBaseURL stringByAppendingString:authPrefix];
    
    NSString *loadingURL = [[OpenSdkBase generateURL:authorizeURL params:params httpMethod:nil] retain];
#ifdef Debug
    NSLog(@"request url is %@", loadingURL);
#endif
	NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:loadingURL]];
	
	[webView loadRequest:request];
}

#pragma -
#pragma mark viewController method

- (void)loadView {
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//__conn = new CIMCommonConnection() ;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	
	//delete __conn ;
}


- (void)dealloc {
    [super dealloc];
}

//2012-09-14, ChenXin added
//保存授权数据
- (void)saveAuthorizeData {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:self.accessToken forKey:kTXaccessTokenKey];
    [ud setObject:self.accessSecret forKey:kTXaccessSecretKey];
    [ud setObject:self.openid forKey:kTXopenidKey];
    [ud setObject:self.openkey forKey:kTXopenkeyKey];
    NSInteger now = [[NSDate date] timeIntervalSince1970];
    NSInteger expireSeconds = now + [self.expireIn intValue];
    //NSDate *expireDate = [NSDate dateWithTimeInterval:[self.expireIn floatValue] sinceDate:[NSDate date]];
    [ud setObject:[NSNumber numberWithInt:expireSeconds] forKey:kTXexpireDateKey];
    [ud synchronize];
}

- (void) oauthDidSuccess:(NSString *)accessToken accessSecret:(NSString *)accessSecret openid:(NSString *)openid openkey:(NSString *)openkey expireIn:(NSString *)expireIn {
    self.accessToken = accessToken;
    self.accessSecret = accessSecret;
    self.openid = openid;
    self.openkey = openkey;
    self.expireIn = expireIn;
    //2012-09-14, ChenXin added
    [self saveAuthorizeData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TencentOauthDidSuccess" object:nil];
    //
    
    [OpenSdkBase showMessageBox:@"绑定成功！"];
}

//检查是否登录
+ (BOOL)isLoggedIn {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *accessToken = [ud objectForKey:kTXaccessTokenKey];
    if (accessToken && ![accessToken isEqualToString:@""]) {
        NSInteger expireDate = [ud integerForKey:kTXexpireDateKey];
        NSInteger now = [[NSDate date] timeIntervalSince1970];
        if (expireDate - now > 600) //空出10分钟，以便完成操作
        {
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}
//

- (void) oauthDidFail:(uint16_t)oauthType success:(BOOL)success netNotWork:(BOOL)netNotWork {
    //NSLog(@"oauth type is %d", oauthType);
    if (oauthType == InAuth1 && success ) {
        [OpenSdkBase showMessageBox:@"未获取到票据，授权失败，请认真检查keyWord是否正确"];
    }
    else if(oauthType == InWebView) {
        if (success) {
            [OpenSdkBase showMessageBox:@"未获取到票据，授权失败，请认真检查keyWord是否正确"];
        }
        else {
            if (netNotWork) {
                //[OpenSdkBase showMessageBox:@"无网络连接，请设置网络"];
            }
            else {
                [OpenSdkBase showMessageBox:@"授权失败，请认真检查appKey是否正确"];
            }
        }
    }
    else {
        //NSLog(@"oauth type is %@", oauthType);
    }
}

- (void) refuseOauth:(NSURL *)url {
    NSRange start = [[url absoluteString] rangeOfString:oauth2TokenKey];
    
    start = [[url absoluteString] rangeOfString:@"code="];
    if (start.location != NSNotFound) {
        NSString *code = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:@"code="];
        NSString *type = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:@"checkType="];
        //NSLog(@"code is %@, type is %@", code, type);
        if ([code isEqualToString:@"101"] && [type isEqualToString:@"error"]) {
            
            //NSLog(@"refuse to authorize");
            [OpenSdkBase showMessageBox:@"用户拒绝webView授权"];
        }
    }
}

@end
BOOL QQWeiboIsDeviceIPad()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        return YES;
    }
#endif
    return NO;
}