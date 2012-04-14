//
//  RMPlaceGetPoiBaseInfoByPidResponse.h
//  RMSDK
//
//  Created by Renren on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
///RMPlaceGetPoiBaseInfoByPidResponse返回某个poi的基本信息
@interface RMPlaceGetPoiBaseInfoByPidResponse : RMObject
{
	NSString *pid;///pid
	NSString *poi_name;///POI名称
	NSString *poi_address;///POI地址
	NSString *map_url;///地图地址
	NSInteger visit_count;///访问量
	NSInteger activity_count;///活动数
	NSString *activity_contents;///活动内容
	NSInteger nearby_activity_count;///附近活动数
	NSString *lat;///维度
	NSString *lon;///经度
	NSString *activity_url;///活动地址
	NSString *detail_address;///详情地址
}
@property(nonatomic, readonly) NSString *pid;
@property(nonatomic, readonly) NSString *poi_name;
@property(nonatomic, readonly) NSString *poi_address;
@property(nonatomic, readonly) NSString *map_url;
@property(nonatomic, readonly) NSInteger visit_count;
@property(nonatomic, readonly) NSInteger activity_count;
@property(nonatomic, readonly) NSString *activity_contents;
@property(nonatomic, readonly) NSInteger nearby_activity_count;
@property(nonatomic, readonly) NSString *lat;
@property(nonatomic, readonly) NSString *lon;
@property(nonatomic, readonly) NSString *activity_url;
@property(nonatomic, readonly) NSString *detail_address;
@end
