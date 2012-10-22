    //
    //  ViewController.m
    //  ShareDemo
    //
    //  Created by tmy on 11-11-22.
    //  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
    //

#import "ViewController.h"
#import "OAuthInfo.h"
#import "SHSendView.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame=[UIScreen mainScreen].applicationFrame;
    shareController=[[SHSShareViewController alloc] initWithRootViewController:self];
    shareController.shareType=ShareTypeText;
    shareController.sharedtitle=@"google";
    shareController.sharedText=@"hahaha";
    shareController.sharedURL=@"http://www.google.com";
    shareController.sharedImageURL=@"http://a4.att.hudong.com/74/08/01300000831741129317080840244.jpg";
    shareController.sharedImage=imageView.image;
    
    
}

- (void)viewDidUnload
{
    [textField release];
    textField = nil;
    [imageView release];
    imageView = nil;
    [imageSwith release];
    imageSwith = nil;
    [super viewDidUnload];
        // Release any retained subviews of the main view.
        // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)share:(id)sender 
{
        //    [OAuthInfo logout];
    shareController=[[SHSShareViewController alloc] initWithRootViewController:self];
    shareController.shareType=ShareTypeText;
    shareController.sharedtitle=@"google";
    shareController.sharedText=@"hahaha";
    shareController.sharedURL=@"http://www.google.com";
    shareController.sharedImageURL=@"http://a4.att.hudong.com/74/08/01300000831741129317080840244.jpg";
    shareController.sharedImage=imageView.image;
    [textField resignFirstResponder];
    shareController.sharedText=textField.text;
    
    shareController.shareType=imageSwith.on?ShareTypeTextAndImage:ShareTypeText;
    
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        [shareController showShareView];
    else
        [shareController showShareViewFromRect:CGRectMake(190, 900, 1, 1)];

    
}

-(IBAction)cancel:(id)sender {
    [textField resignFirstResponder];
}


-(void)showEditor:(id)sender {
    SHSendView * sendView = [[SHSendView alloc] initWithText:@"Hello World" image:imageView.image andRootViewController:self];
    [sendView show:YES];
    [sendView release];
}

- (void)dealloc {
    [textField release];
    [imageView release];
    [imageSwith release];
    [super dealloc];
}
@end
