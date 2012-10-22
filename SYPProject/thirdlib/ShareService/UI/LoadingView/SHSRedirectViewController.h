//
//  RedirectViewController.h
//  ShareDemo
//
//  Created by mini2 on 20/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHSRedirectViewController : UIViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    NSString *_url;
}

- (id)initWithUrl:(NSString *)url;

- (void)cancel;
@end
