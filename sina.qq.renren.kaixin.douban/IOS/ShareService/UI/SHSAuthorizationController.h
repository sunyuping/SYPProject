//
//  AuthorizationViewController.h
//  ShareDemo
//
//  Created by tmy on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSCommon.h"
#import "LoadingView.h"

//为OAuth1.0提供用户授权
@interface SHSAuthorizationController : UIViewController<UIWebViewDelegate>
{
    id<AuthorizationDelegate> _authorizationDelegate;
    UIWebView *_webView;
    NSString *_authorizationURL;
    LoadingView *_loadView;
}

@property (nonatomic,assign) id<AuthorizationDelegate> authorizationDelegate;
@property (nonatomic,retain) NSString * authorizationURL;
@property (nonatomic,retain) NSString *requestToken;

- (void)cancel;

@end
