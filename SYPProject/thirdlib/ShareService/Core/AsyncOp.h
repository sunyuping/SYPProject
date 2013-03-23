//
//  AsyncOp.h
//  ShareServiceDemo
//
//  Created by Buzzinate Buzzinate on 12-6-25.
//  Copyright (c) 2012年 Buzzinate Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncOp : NSOperation {
    NSString *_url;
    NSString *_site;
    NSMutableURLRequest *_request;
}
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *site;
@property (nonatomic, retain) NSMutableURLRequest *request;

-(id)init:(NSString *)url withSite:(NSString *) site withRequest:(NSMutableURLRequest *)request;

@end
