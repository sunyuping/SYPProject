//
//  RRObejctCRuntime.h
//  RRFramework
//
//  Created by 玉平 孙 on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRDefines.h"

@interface RRObejctCRuntime : NSObject
+(void)displayIvarList:(id)obj;
+(void)displayPropertyList:(id)obj;
+(void)displayMethodList:(id)obj;
+(void)displayProtocolList:(id)obj;
+(id)objectgetIvar:(id)obj name:(const char *)name;
@end
