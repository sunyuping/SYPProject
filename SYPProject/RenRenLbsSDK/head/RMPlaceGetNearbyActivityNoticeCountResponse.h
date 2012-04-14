//
//  RMPlaceGetNearbyActivityNoticeCountResponse.h
//  RMSDK
//
//  Created by Renren on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
///RMPlaceGetNearbyActivityNoticeCountResponse返回附近的活动或好友活动的数量
@interface RMPlaceGetNearbyActivityNoticeCountResponse : RMObject
{
    NSMutableArray *activity_list;    ///活动列表
    NSInteger page_size;///页面大小
    NSInteger count;                    /// 数量
}
@property(nonatomic, readonly) NSMutableArray *activity_list;
@property(nonatomic, readonly) NSInteger count;
@property(nonatomic, readonly) NSInteger page_size;
@end
