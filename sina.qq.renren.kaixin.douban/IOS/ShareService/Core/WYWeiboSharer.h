//
//  163WeiboSharer.h
//  ShareServiceDemo
//
//  Created by tmy on 12-1-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHSOAuth1Sharer.h"

@interface WYWeiboSharer : SHSOAuth1Sharer
- (void)shareRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)shareRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;
@end
