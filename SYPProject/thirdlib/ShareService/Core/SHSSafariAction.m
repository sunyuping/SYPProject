//
//  SHSSafariAction.m
//  ShareDemo
//
//  Created by mini2 on 29/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SHSAPIKeys.h"
#import "SHSSafariAction.h"

@implementation SHSSafariAction

@synthesize rootViewController,description,sharedUrl;

- (BOOL)sendAction:(id)content
{
    NSString *url=content;
    if(url==nil || [url isEqualToString:@""] || ![url hasPrefix:@"http://"])
        return NO;
    else
        return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
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
