//
//  SHSAuthorization2Controller.h
//  ShareDemo
//
//  Created by tmy on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSCommon.h"
#import "LoadingView.h"

//为OAuth2.0提供用户授权
@interface SHSAuthorization2Controller : UIViewController<UIWebViewDelegate>
{
    id<AuthorizationDelegate> _authorizationDelegate;
    UIWebView *_webView;
    NSString *_authorizationURL;
    LoadingView *_loadView;
}

@property (nonatomic,assign) id<AuthorizationDelegate> authorizationDelegate;
@property (nonatomic,retain) NSString * authorizationURL;

- (void)cancel;

@end
