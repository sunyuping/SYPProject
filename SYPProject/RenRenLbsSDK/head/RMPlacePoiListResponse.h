//
//  RMPlacePoiListResponse.h
//  RMSDK
//
//  Created by linux on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
#import "RMPlaceData.h"
///RMPlacePoiListResponse获取poi列表
@interface RMPlacePoiListResponse : RMObject
{
    NSInteger count; ///数量
    RMPoiListItem *info;   ///POI
    NSMutableArray *poiList;///POI列表
    NSInteger pageSize;///页面大小
    NSString *latGps;///GPS维度
    NSString *lonGps;///GPS经度
    NSInteger need2deflect;///是否偏转
    NSInteger locateType;///位置类型
}

@property(nonatomic, readonly)NSInteger count;
@property(nonatomic, readonly)RMPoiListItem *info;
@property(nonatomic, readonly)NSMutableArray *poiList;
@property(nonatomic, readonly)NSInteger pageSize;
@property(nonatomic, readonly)NSString *latGps;
@property(nonatomic, readonly)NSString *lonGps;
@property(nonatomic, readonly)NSInteger need2deflect;
@property(nonatomic, readonly)NSInteger locateType;

@end
