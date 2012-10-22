//
//  AuthorizationViewController.m
//  ShareDemo
//
//  Created by tmy on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SHSAuthorizationController.h"

@implementation SHSAuthorizationController
@synthesize authorizationDelegate=_authorizationDelegate,authorizationURL=_authorizationURL,requestToken;

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [_webView release];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    self.requestToken=nil;
    self.authorizationURL=nil;
    if(_loadView)
        [_loadView release];
    [super dealloc];
}

#pragma mark - View lifecycle


- (void)loadView
{
    _webView=[[UIWebView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    _webView.delegate=self;
    self.view=_webView;
    self.navigationItem.title=@"请求授权";
    
    UIBarButtonItem *cancelBtn=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem=cancelBtn;
    [cancelBtn release];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.authorizationURL]]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)cancel
{
    if([_authorizationDelegate respondsToSelector:@selector(authorizationDidCancel)])
        [_authorizationDelegate authorizationDidCancel];
    [_webView loadHTMLString:nil baseURL:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.view.userInteractionEnabled=NO;
    if(!_loadView)
        _loadView=[[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 130, 100) LoadingViewStyle:LoadingViewStyleStandard];
    _loadView.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    _loadView.title=@"加载中";
    [_loadView showInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"%@",webView.request.URL.description);
    //对新浪微博做特殊处理获取pin码
    if(((NSRange)[webView.request.URL.resourceSpecifier rangeOfString:@"sina"]).length!=0 && [webView.request.URL.path hasSuffix:@"authorize"] && webView.request.URL.query==nil)
    {
        NSString *pin;
        NSString *length=[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].getElementsByTagName('b').length"];
        if([length intValue]==0)
            pin=[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].innerHTML"];
        else
            pin=[webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('span')[0].getElementsByTagName('b')[0].innerHTML"];
        
       if(pin!=nil&& ![pin isEqualToString:@""])
       {
           [_authorizationDelegate authorizationDidFinishWithToken:self.requestToken andVerifier:pin];
           [self.navigationController popViewControllerAnimated:NO];
           [self.navigationController dismissModalViewControllerAnimated:YES];
       }
    }
    else if(((NSRange)[webView.request.URL.resourceSpecifier rangeOfString:@"163"]).length!=0 && [webView.request.URL.path hasSuffix:@"authenticate"]&&((NSRange)[webView.request.URL.resourceSpecifier rangeOfString:@"authorize=1"]).length!=0)  //对网易微博做特殊处理以判断是否授权成功
    {
        [_authorizationDelegate authorizationDidFinishWithToken:self.requestToken andVerifier:@""];
        [self.navigationController popViewControllerAnimated:NO];
        [self.navigationController dismissModalViewControllerAnimated:YES];
    }

    self.view.userInteractionEnabled=YES;
    [_loadView dismiss];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
     
    NSString *queryStr=request.URL.query;
    NSArray *parameters=[queryStr componentsSeparatedByString:@"&"];
    for(NSString *parameterKeyValue in parameters)
    {
        NSArray *keyValue=[parameterKeyValue componentsSeparatedByString:@"="];
        
        if([[keyValue objectAtIndex:0] isEqualToString:@"oauth_verifier"])
        {
            NSString *verifier=[keyValue objectAtIndex:1];
            [_authorizationDelegate authorizationDidFinishWithToken:self.requestToken andVerifier:verifier];
            [self.navigationController popViewControllerAnimated:NO];
            [self.navigationController dismissModalViewControllerAnimated:YES];
            return NO;
        }
    }
   
    return YES;
}

@end
