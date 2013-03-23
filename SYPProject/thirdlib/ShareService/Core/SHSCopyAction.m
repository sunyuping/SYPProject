//
//  SHSCopyAction.m
//  ShareDemo
//
//  Created by mini2 on 29/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SHSCopyAction.h"

@implementation SHSCopyAction

@synthesize rootViewController,description, sharedUrl;

- (BOOL)sendAction:(id)content
{
    if([[[content class] description] isEqualToString:@"UIImage"])
    {
        [UIPasteboard generalPasteboard].image=content;
    }
    else
        [UIPasteboard generalPasteboard].string=content;
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"已拷贝" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [alert release];
    
    return YES;
}



- (void)dealloc
{
    self.description=nil;
    [super dealloc];
}
-(NSString *)getURL:(NSString *)url andSite:(NSString *)site {
    if (!url) {
        return [NSString stringWithString:url];
    }
    return @"";}

@end
