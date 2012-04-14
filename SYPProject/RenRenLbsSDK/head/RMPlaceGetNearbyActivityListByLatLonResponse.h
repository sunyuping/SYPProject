//
//  RMPlaceGetNearbyActivityListByLatLonResponse.h
//  RMSDK
//
//  Created by Renren on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
#import "RMPlaceData.h"
///RMPlaceGetNearbyActivityListByLatLonResponse根据经纬度获取附近活动poi
@interface RMPlaceGetNearbyActivityListByLatLonResponse : RMObject
{
    NSInteger count;///数量
    NSMutableArray *poiList;///POI列表吧
    NSInteger pageSize;///页面大小
    NSString *latGps;///维度
    NSString *lonGps;///经度
    NSInteger need2deflect;///是否偏转
    NSInteger locateType;///位置类型
}

@property(nonatomic, readonly)NSInteger count;
@property(nonatomic, readonly)NSMutableArray *poiList;
@property(nonatomic, readonly)NSInteger pageSize;
@property(nonatomic, readonly)NSString *latGps;
@property(nonatomic, readonly)NSString *lonGps;
@property(nonatomic, readonly)NSInteger need2deflect;
@property(nonatomic, readonly)NSInteger locateType;
@end
