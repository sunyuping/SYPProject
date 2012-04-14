//
//  RRDebug.h
//  RRFramework
//
//  Created by 玉平 孙 on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRDefines.h"


@interface RRDebug : NSObject {
}
+(void)loadDebugSymbol;
+(NSString*)lookupFunction:(unsigned int) address backtrace:(const char*)backtrace ;
@end


