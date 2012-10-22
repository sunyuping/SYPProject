    //
    //  AsyncOp.m
    //  ShareServiceDemo
    //
    //  Created by Buzzinate Buzzinate on 12-6-25.
    //  Copyright (c) 2012年 Buzzinate Co. Ltd. All rights reserved.
    //

#import "AsyncOp.h"

@implementation AsyncOp
@synthesize url=_url, site=_site, request=_request;
-(void)dealloc {
    [_url release];
    _url = nil;
    [_site release];
    _site = nil;
    [_request release];
    _request = nil;
    [super dealloc];
}

-(id)init:(NSString *)url withSite:(NSString *)site withRequest:(NSMutableURLRequest *)request {
    id base = [super init];
    if (base) {
        self.url = url;
        self.site = site;
        self.request = request;
    }
    return base;
}

-(void)main{
    @try {
        
        NSURLResponse *resp=nil;NSError * err=nil;
        NSData* myReturn = [NSURLConnection sendSynchronousRequest:self.request returningResponse:&resp error:&err];
        if (err) {
            NSLog(@"%@", [err description]);
            return;
        }
        if (myReturn) {
            NSLog(@"%@", [[[NSString alloc] initWithData:myReturn encoding:NSUTF8StringEncoding] autorelease]);      
        }
       
    }
    @catch (NSException *exception) {
        NSLog(@"%@", [exception description]);
    }
   
   
    
}



@end
