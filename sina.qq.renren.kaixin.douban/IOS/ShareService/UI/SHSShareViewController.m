//
//  ShareViewController.m
//  ShareDemo
//
//  Created by tmy on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SHSShareViewController.h"
#import "SHSMoreViewController.h"
#import "SHSRedirectSharer.h"
#import "SHSRedirectViewController.h"
#import "OAuthInfo.h"


@interface SHSShareViewController ()
- (void)loadViewDidDismissed;
- (void)loadViewDelayClose;
- (void)loadConfig;
@end


@implementation SHSShareViewController
@synthesize  shareType,rootViewController=_rootViewController,sharedtitle,sharedText,sharedURL,sharedImage,sharedImageURL;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super init];
    if (self) {
        _rootViewController=rootViewController;
        _menuItems=[[NSMutableArray alloc] init];
        _moreServices=[[NSMutableArray alloc] init];
        _moreActions=[[NSMutableArray alloc] init];
        [self loadConfig];
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
    [_menuItems release];
    [_moreServices release];
    [_moreActions release];
    if(_loadView)
        [_loadView release];
    self.sharedtitle=nil;
    self.sharedText=nil;
    self.sharedURL=nil;
    self.sharedImageURL=nil;
    [super dealloc];
}

#pragma mark - View lifecycle


- (void)loadView
{
    self.view=[[[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    self.view.backgroundColor=[UIColor clearColor];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
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

- (void)loadConfig
{

    NSDictionary *config=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceConfig" ofType:@"plist"]];
    NSArray *services=[config objectForKey:@"OAuthServices"];
    NSArray *actions=[config objectForKey:@"Actions"];
    NSArray *redirectServices=[config objectForKey:@"RedirectServices"];
    
    for(int i=0; i<[services count];i++)
    {
        NSDictionary *dict=[services objectAtIndex:i];
        id<SHSOAuthSharerProtocol> sharer=nil;
        OAuthType type=[[dict objectForKey:@"oauthType"] intValue]; 
        BOOL isMore=[[dict objectForKey:@"isMore"] boolValue];
        switch (type) {
            case OAuthTypeOAuth1WithHeader:
            case OAuthTypeOAuth1WithQueryString:
            {
                SHSOAuth1Sharer * serviceSharer=[[[NSClassFromString([dict objectForKey:@"name"]) alloc] init] autorelease];
                serviceSharer.key=[dict objectForKey:@"key"];
                serviceSharer.name=[dict objectForKey:@"title"];
                serviceSharer.requestTokenURL=[dict objectForKey:@"requestTokenURL"];
                serviceSharer.autherizeURL=[dict objectForKey:@"authorizeURL"];
                serviceSharer.accessTokenURL=[dict objectForKey:@"accessTokenURL"];
                serviceSharer.callbackURL=[dict objectForKey:@"callbackURL"];
                serviceSharer.rootViewController=_rootViewController;
                serviceSharer.delegate=self;
                serviceSharer.signatureProvider=[[[OAHMAC_SHA1SignatureProvider alloc] init] autorelease];
                serviceSharer.oauthType=type;
                sharer=serviceSharer;
            }
                break;
            case OAuthTypeOAuth2:
            {
                SHSOAuth2Sharer * serviceSharer=[[[NSClassFromString([dict objectForKey:@"name"]) alloc] init] autorelease];
                serviceSharer.key=[dict objectForKey:@"key"];
                serviceSharer.name=[dict objectForKey:@"title"];
                serviceSharer.autherizeURL=[dict objectForKey:@"authorizeURL"];
                serviceSharer.callbackURL=[dict objectForKey:@"callbackURL"];
                serviceSharer.rootViewController=_rootViewController;
                serviceSharer.delegate=self;
                serviceSharer.oauthType=type;
                sharer=serviceSharer;
            }
                break;
            default:
                break;
        }
        
        if(!isMore)
            [_menuItems addObject:sharer];
        else
            [_moreServices addObject:sharer]; 
    }
    
    for(int j=0;j<[actions count];j++)
    {
        NSDictionary *dict=[actions objectAtIndex:j];
        NSString *name=[dict objectForKey:@"name"];
        NSString *description=[dict objectForKey:@"description"];
        BOOL isMore=[[dict objectForKey:@"isMore"] boolValue];
        id<SHSActionProtocol> action=[[NSClassFromString([NSString stringWithFormat:@"SHS%@Action",name]) alloc] init];
        action.description=description;
        action.rootViewController=_rootViewController;
        if(isMore)
            [_moreActions addObject:action];
        else
            [_menuItems addObject:action];
        
        [action release];
    }
    
    for(NSDictionary *dict in redirectServices)
    {
        SHSRedirectSharer *redirectSharer=[[SHSRedirectSharer alloc] init];
        redirectSharer.title=[dict objectForKey:@"title"];
        redirectSharer.name=[dict objectForKey:@"name"];
        [_moreServices addObject:redirectSharer];
        [redirectSharer release];
    }
    
}

- (void)loadViewDelayClose
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(loadViewDidDismissed)];
    _loadView.alpha=0;
    _loadView.transform=CGAffineTransformMakeScale(1.7f, 1.7f);
    [UIView commitAnimations];
}

- (void)loadViewDidDismissed
{
    [_loadView dismiss];
    [_loadView release];
    _loadView=nil;
}

- (void)showShareView
{
    //[OAuthInfo logout];
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"分享到" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    
    for(id item in _menuItems)
    {
        if([[[item class] description] hasSuffix:@"Action"])
            [actionSheet addButtonWithTitle:((id<SHSActionProtocol>)item).description];
        else
        {
            [actionSheet addButtonWithTitle:((id<SHSOAuthSharerProtocol>)item).name];
        }
    }
    [actionSheet addButtonWithTitle:@"更多"];
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
    [actionSheet showInView:_rootViewController.view];
    [actionSheet release];
}

- (void)showShareViewFromRect:(CGRect)rect
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"分享到" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    
    for(id item in _menuItems)
    {
        if([[[item class] description] hasSuffix:@"Action"])
            [actionSheet addButtonWithTitle:((id<SHSActionProtocol>)item).description];
        else
        {
            [actionSheet addButtonWithTitle:((id<SHSOAuthSharerProtocol>)item).name];
        }
    }
    [actionSheet addButtonWithTitle:@"更多"];
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
    [actionSheet showFromRect:rect inView:_rootViewController.view animated:YES];
    [actionSheet release];

}

#pragma mark - SHSOAuthShareDelegate

- (void)OAuthSharerDidBeginVerification:(id<SHSOAuthSharerProtocol>)oauthSharer
{
    if(!_loadView)
        _loadView=[[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 130, 100) LoadingViewStyle:LoadingViewStyleStandard];
    _loadView.titleLabel.font=[UIFont boldSystemFontOfSize:13];
    _loadView.title=@"加载中";
    
    _loadView.alpha=0;
    _loadView.transform=CGAffineTransformMakeScale(1.7f, 1.7f);
    [_loadView showInView:_rootViewController.view];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    _loadView.alpha=1;
     _loadView.transform=CGAffineTransformMakeScale(1, 1);
    [UIView commitAnimations];
}

- (void)OAuthSharerDidFinishVerification:(id<SHSOAuthSharerProtocol>)oauthSharer
{
    [self loadViewDidDismissed];
}

- (void)OAuthSharerDidCancelVerification:(id<SHSOAuthSharerProtocol>)oauthSharer
{
    [self loadViewDidDismissed];
}

- (void)OAuthSharerDidFailInVerification:(id<SHSOAuthSharerProtocol>)oauthSharer
{
    [self loadViewDidDismissed];
    
    if(!_loadView)
        _loadView=[[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 130, 100) LoadingViewStyle:LoadingViewStyleTilte];
    _loadView.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    _loadView.title=@"用户授权失败";
    
    _loadView.alpha=0;
    _loadView.transform=CGAffineTransformMakeScale(1.7f, 1.7f);
    [_loadView showInView:_rootViewController.view];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    _loadView.alpha=1;
    _loadView.transform=CGAffineTransformMakeScale(1, 1);
    [UIView commitAnimations];
      [self performSelector:@selector(loadViewDelayClose) withObject:nil afterDelay:1];
}

- (void)OAuthSharerDidBeginShare:(id<SHSOAuthSharerProtocol>)oauthSharer
{
    if(!_loadView)
        _loadView=[[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 130, 100) LoadingViewStyle:LoadingViewStyleTilte];
    _loadView.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    _loadView.title=@"分享中";
    
    _loadView.alpha=0;
    _loadView.transform=CGAffineTransformMakeScale(1.7f, 1.7f);
    [_loadView showInView:_rootViewController.view];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    _loadView.alpha=1;
    _loadView.transform=CGAffineTransformMakeScale(1, 1);
    [UIView commitAnimations];
}

- (void)OAuthSharerDidFinishShare:(id<SHSOAuthSharerProtocol>)oauthSharer
{
    _loadView.title=@"分享成功!";
    [self performSelector:@selector(loadViewDelayClose) withObject:nil afterDelay:1];
}

- (void)OAuthSharerDidFailShare:(id<SHSOAuthSharerProtocol>)oauthSharer
{
    _loadView.title=@"分享失败!";
    [self performSelector:@selector(loadViewDelayClose) withObject:nil afterDelay:1];
}

#pragma mark- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{      
    if(buttonIndex==actionSheet.numberOfButtons-1)
        return;
    
    if(buttonIndex==actionSheet.numberOfButtons-2)
    {
        SHSMoreViewController *moreController=[[[SHSMoreViewController alloc] init] autorelease];
        moreController.moreServices=_moreServices;
        moreController.moreActions=_moreActions;
        moreController.parentController=self;
        UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:moreController];
        moreController.navigationItem.title=@"更多";
        [_rootViewController presentModalViewController:nav animated:YES];
        [nav release];
        return;
    }
    
    id item=[_menuItems objectAtIndex:buttonIndex];
    
    
    
    
    if(!self.sharedText || [self.sharedText isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"必须指定要分享的内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }

    
    if(self.shareType==ShareTypeText)
    {  
        if([[[item class] description] hasSuffix:@"Sharer"] || [[[item class] description]hasSuffix:@"Sharer2"])  {
            [((id<SHSOAuthSharerProtocol>)item) setSharedUrl:self.sharedURL];
            [((id<SHSOAuthSharerProtocol>)item) shareText:self.sharedText];
            
        }
        else {
            [((id<SHSActionProtocol>)item) setSharedUrl:self.sharedURL];
            [((id<SHSActionProtocol>)item) sendAction:self.sharedText];
            
        }
    }
    else
    {
        if(!self.sharedImage)
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"必须指定要分享的图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
            return;
        }
        if([[[item class] description] hasSuffix:@"Sharer"] || [[[item class] description] hasSuffix:@"Sharer2"]) {
            [((id<SHSOAuthSharerProtocol>)item) setSharedUrl:self.sharedURL];
            [((id<SHSOAuthSharerProtocol>)item) shareText:self.sharedText andImage:self.sharedImage]; 
            
        }
        else {
             [((id<SHSActionProtocol>)item) setSharedUrl:self.sharedURL];
            [((id<SHSActionProtocol>)item) sendAction:self.sharedImage];
           
        }
    }
    
}

-(NSString *)getTrackUrl:(NSString *)source trackCB:(BOOL)trackCB site:(NSString *)site
{
    NSString *pattern = @"http://www.bshare.cn/burl?url=%@&publisherUuid=%@&site=%@";
    NSString *uuid = PUBLISHER_UUID;
    if (!uuid) {
        uuid = @"";
    }
    if (!site){
        site = @"";
    }
    if (source && trackCB) {
        return [NSString stringWithFormat:pattern,source,uuid,site];
    }
    return [NSString stringWithString:source];
}

- (void) logout {
    
}

@end
