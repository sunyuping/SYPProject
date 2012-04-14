//
//  RMReverseGeoCodeResponse.h
//  RMSDK
//
//  Created by Renren on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"

@interface RMReverseGeoCodeResponse : RMObject {
    NSString *longitude;                /// 纬度
    NSString *latitude;                 /// 经度
    NSString *StreetName;               /// 街道名称
    NSString *address;                  /// 地址
    NSString *district;                 /// 区：（朝阳区
    NSString *city;                     /// 城市
    NSString *cityCode;                 /// 城市编号
    NSString *province;                 /// 省份
    NSString *country;                  /// 国家
    NSString *nearestPoiName;           /// 最近POI的名称
    NSString *nearestPoiType;           /// 最近POI的类型
    NSString *nearestPoiDirection;      /// 最近POI的方向
    NSString *nearestPoiDistance;       /// 最近POI的距离
    NSString *nearestRoadName;          /// 最近公路的名称
    NSString *nearestRoadDirection;     /// 最近公路的方向
    NSString *nearestRoadDistance;      /// 最近公路的距离
}

@property(nonatomic, readonly) NSString *longitude;
@property(nonatomic, readonly) NSString *latitude;
@property(nonatomic, readonly) NSString *StreetName;
@property(nonatomic, readonly) NSString *address;
@property(nonatomic, readonly) NSString *district;
@property(nonatomic, readonly) NSString *city;
@property(nonatomic, readonly) NSString *cityCode;
@property(nonatomic, readonly) NSString *province;
@property(nonatomic, readonly) NSString *country;
@property(nonatomic, readonly) NSString *nearestPoiName;
@property(nonatomic, readonly) NSString *nearestPoiType;
@property(nonatomic, readonly) NSString *nearestPoiDirection;
@property(nonatomic, readonly) NSString *nearestPoiDistance;
@property(nonatomic, readonly) NSString *nearestRoadName;
@property(nonatomic, readonly) NSString *nearestRoadDirection;
@property(nonatomic, readonly) NSString *nearestRoadDistance;


@end
