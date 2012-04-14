//
//  RMPlaceGetNearbyActivityListByLatLonContext.h
//  RMSDK
//
//  Created by Renren on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContext.h"
#import "RMPlaceGetNearbyActivityListByLatLonResponse.h"
/*
 *返回某个经纬度周边的活动poi列表
 */
@interface RMPlaceGetNearbyActivityListByLatLonContext : RMCommonContext
{
    RMPlaceGetNearbyActivityListByLatLonResponse *response;  ///< 返回的结果
    NSString *latlon;///json化的经纬度,若有此值 latGps,lonGps无效
    NSInteger page;///分页页码，默认为1
    NSInteger pageSize;///每页的数据量，默认为20
    NSInteger radius;///查找半径，单位为米 默认为1
    long requestTime;///请求时间,当有latlon时应传此参数
    NSInteger d;///传的经纬度是否需要偏转,1偏，0不偏，默认为0
    NSInteger exclude_list;///为1时将不返回活动列表数据
}
@property(assign, nonatomic) NSInteger page;
@property(assign, nonatomic) NSInteger pageSize;
@property(assign, nonatomic) NSInteger exclude_list;
@property(assign, nonatomic) NSString *latlon;
@property(assign, nonatomic) NSInteger radius;
@property(assign, nonatomic) long requestTime;
@property(assign, nonatomic) NSInteger d;
/**
 *异步请求
 *@param latGps gps纬度
 *@param lonGps gps经度
 */  
-(void)asynGetNearbyActivityListByLatLon:(NSString*)latGps lonGps:(NSString*)lonGps; 

/**
 *同步请求
 *@param latGps gps纬度
 *@param lonGps gps经度
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetNearbyActivityListByLatLon:(NSString*)latGps lonGps:(NSString*)lonGps error:(RMError **)error;
-(RMPlaceGetNearbyActivityListByLatLonResponse *)getContextResponse;


@end
