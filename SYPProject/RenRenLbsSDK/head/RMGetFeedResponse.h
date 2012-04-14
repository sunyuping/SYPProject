//
//  RMGetFeedResponse.h
//  RMSDK
//
//  Created by Renren on 11-10-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMObject.h"

@interface RMGetFeedResponse : RMResponse {
    NSMutableArray *feedList;   /// 新鲜事模板
    NSInteger code;             /// 返回结果状态（0表示正常， 1表示没有权限）
}
@property(nonatomic, readonly) NSMutableArray *feedList;
@property(nonatomic, readonly) NSInteger code;
@end
