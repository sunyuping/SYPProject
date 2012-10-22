//
//  SHSRedirectSharer.m
//  ShareDemo
//
//  Created by mini2 on 2/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SHSRedirectSharer.h"
#import "SHSAPIKeys.h"
#define SHARE_URL @"http://api.bshare.cn/share_r/%@.11?url=%@&title=%@&summary=%@&pic=%@&&publisherUuid=%@"

@implementation SHSRedirectSharer
@synthesize title=_title,name=_name;

- (void)dealloc
{
    self.title=nil;
    self.name=nil;
    [super dealloc];
}

- (NSString *)getShareUrlWithTitle:(NSString *)title withText:(NSString *)text withURL:(NSString *)URL withImageURL:(NSString *)imageURL
{
    if(!title)
        title=@"";
    
    if(!imageURL)
        imageURL=@"";
    NSString *publisherUuid = PUBLISHER_UUID;
    if (!publisherUuid){
        publisherUuid=@"";
    }
    [publisherUuid autorelease];
    
    NSString *url=[NSString stringWithFormat:SHARE_URL,_name,[URL URLEncodedString],[title URLEncodedString],[text URLEncodedString],[imageURL URLEncodedString], publisherUuid];
     NSLog(@"redirect url = %@",url);
    return url;
}


-(NSString *)getURL:(NSString *)url 
{
    NSDictionary *config=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceConfig" ofType:@"plist"]];
    NSString *pattern = @"http://www.bshare.cn/burl?url=%@&publisherUuid=%@&site=%@";
    NSString *uuid = PUBLISHER_UUID;
    NSString *site = [self name];
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
