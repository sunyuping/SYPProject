//
//  SHSSMSAction.m
//  ShareServiceDemo
//
//  Created by tmy on 12-4-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SHSSMSAction.h"
#import "DataStatistic.h"
#import "SHSAPIKeys.h"

@implementation SHSSMSAction
@synthesize rootViewController,description,sharedUrl;

- (BOOL)sendAction:(id)content
{
   if(NSClassFromString(@"MFMessageComposeViewController"))
   {
       if([MFMessageComposeViewController canSendText])
       {
           MFMessageComposeViewController *smsController=[[MFMessageComposeViewController alloc] init];
           smsController.messageComposeDelegate=self;
           smsController.body=content;
           
           if(self.rootViewController)
               [self.rootViewController presentModalViewController:smsController animated:YES];
           
           [smsController release];
           
           DataStatistic *stat = [[DataStatistic alloc] init];
           [stat sendStatistic:self.sharedUrl site:@"email"];
           [stat release];
       }
       else 
       {
           UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"该设备无法发送短信" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
           [alert show];
           [alert release];
       }
   }
    else 
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:",content]]];
        DataStatistic *stat = [[DataStatistic alloc] init];
        [stat sendStatistic:self.sharedUrl site:@"email"];
        [stat release];
    }
    

    
    return YES;
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissModalViewControllerAnimated:YES];
    if(result==MessageComposeResultSent)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"短信发送成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
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
