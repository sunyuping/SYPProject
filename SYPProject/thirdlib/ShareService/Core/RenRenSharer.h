//
//  RenRenSharer.h
//  ShareDemo
//
//  Created by mini2 on 2/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHSOAuth2Sharer.h"

@interface RenRenSharer : SHSOAuth2Sharer<NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}
-(NSString *)md5:(NSString *)str ;
@end
