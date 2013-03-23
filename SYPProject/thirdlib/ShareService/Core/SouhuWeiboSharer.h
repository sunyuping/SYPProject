//
//  SouhuWeiboSharer.h
//  ShareDemo
//
//  Created by mini2 on 2/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHSOAuth1Sharer.h"

@interface SouhuWeiboSharer : SHSOAuth1Sharer
- (void)shareRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
- (void)shareRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;
@end
