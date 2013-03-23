//
//  RedirectViewController.m
//  ShareDemo
//
//  Created by mini2 on 20/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SHSRedirectViewController.h"

@implementation SHSRedirectViewController

- (id)initWithUrl:(NSString *)url
{
    if(self=[super init])
    {
        _url=[url retain];
    }
    return self;
}

- (void)dealloc
{
    [_webView release];
    [_url release];
    [super dealloc];
}

- (void)loadView
{
    _webView=[[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    _webView.delegate=self;
    _webView.scalesPageToFit=YES;
    self.view=_webView;
       
    UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem=cancelBtn;
    [cancelBtn release];
}

- (void)viewDidLoad
{
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
}

- (void)cancel
{

    [_webView loadHTMLString:nil baseURL:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.navigationItem.title=@"加载中...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.title=@"";
}

@end
