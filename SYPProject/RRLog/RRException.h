//
//  RRException.h
//  RRFramework
//
//  Created by 玉平 孙 on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRSingleton.h"

@protocol RRExceptionProtocol <NSObject>
@required
-(BOOL)ExceptionHandle:(NSException*)e ; 
@end

@interface RRException : NSObject {
    id<RRExceptionProtocol> _delegate;
    NSUncaughtExceptionHandler* _oldHandle;
}
@property (nonatomic,assign) id<RRExceptionProtocol> delegate;
@property (nonatomic,assign,readonly) NSUncaughtExceptionHandler* oldHandle;
+(RRException*) defaultException;
@end