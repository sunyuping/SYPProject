//
//  RMPlaceGetLocalActivityListByPidResponse.h
//  RMSDK
//
//  Created by Renren on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
///RMPlaceGetLocalActivityListByPidResponse返回某个pid的活动列表
@interface RMPlaceGetLocalActivityListByPidResponse : RMObject
{
    NSMutableArray *activity_list;  ///活动列表  
    NSInteger page_size;///当前请求分页的每页的数量
    NSInteger count;                    /// 数量
}
@property(nonatomic, readonly) NSMutableArray *activity_list;
@property(nonatomic, readonly) NSInteger count;
@property(nonatomic, readonly) NSInteger page_size;

@end
