//
//  RMPlaceGetNearbyActivityListByPidResponse.h
//  RMSDK
//
//  Created by Renren on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
///RMPlaceGetNearbyActivityListByPidResponse根据pid获取附近活动poi
@interface RMPlaceGetNearbyActivityListByPidResponse : RMObject
{
    NSMutableArray *poi_list;     ///POI列表
    NSInteger count;                    /// 数量
    NSInteger page_size;///页面大小
    
    
    NSInteger need2deflect;///是否偏转
    NSInteger locate_type;///位置类型
    NSString *lat_gps;///GPS维度
    NSString *lon_gps;///GPS经度
    
}
@property(nonatomic, readonly) NSMutableArray *poi_list;
@property(nonatomic, readonly) NSInteger count;
@property(nonatomic, readonly) NSInteger page_size;



@property(nonatomic, readonly) NSInteger need2deflect;
@property(nonatomic, readonly) NSInteger locate_type;
@property(nonatomic, readonly) NSString *lat_gps;
@property(nonatomic, readonly) NSString *lon_gps;
@end
