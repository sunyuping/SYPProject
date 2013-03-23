//
//  SHSEmailAction.m
//  ShareDemo
//
//  Created by mini2 on 29/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SHSEmailAction.h"
#import "DataStatistic.h"
#import "SHSAPIKeys.h"

@implementation SHSEmailAction

@synthesize rootViewController,description,sharedUrl;

- (BOOL)sendAction:(id)content
{
    if([MFMailComposeViewController canSendMail])
        {
        MFMailComposeViewController *mailController=[[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate=self;

        if([[[content class] description] isEqualToString:@"UIImage"])
        {
            NSData *img=UIImageJPEGRepresentation(content, 0.5f);
            [mailController addAttachmentData:img mimeType:@"image/jpeg" fileName:@"image"];
        }
        else
           [mailController setMessageBody:content isHTML:NO];
        
         if(self.rootViewController)
            [self.rootViewController presentModalViewController:mailController animated:YES];
        
        
        [mailController release];
        DataStatistic *stat = [[DataStatistic alloc] init];
        [stat sendStatistic:self.sharedUrl site:@"email"];
        [stat release];
            
                 return YES;
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"请先设置邮件账户" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return NO;
    }
    
   

}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}


- (void)dealloc
{
    self.description=nil;
    [super dealloc];
}

-(NSString *)getURL:(NSString *)url andSite:(NSString *)site 
{
    NSDictionary *config=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceConfig" ofType:@"plist"]];
    NSString *pattern = @"http://www.bshare.cn/burl?url=%@&publisherUuid=%@&site=%@";
    NSString *uuid = PUBLISHER_UUID;
    if (!uuid) {
        uuid = @"";
    }
    if (!site){
        site = @"";
    }
    if (url && [[config objectForKey:@"TrackClickBack"] boolValue]) {
        return [NSString stringWithFormat:pattern,url,uuid,site];
    } else if (url) {
        return [NSString stringWithString:url];
    }
    return @"";
}


@end
