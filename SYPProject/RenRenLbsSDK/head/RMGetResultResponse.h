//
//  RMGetResultResponse.h
//  RMSDK
//
//  Created by Renren-inc on 11-10-12.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import <Foundation/Foundation.h>
#import "RMObject.h"
@interface RMGetResultResponse :RMResponse{
    NSString *result;
}
@property(nonatomic, readonly) NSString *result;
@end
