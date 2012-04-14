//
//  RMPlacePoiListContext.h
//  RMSDK
//
//  Created by linux on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

/*
 *获取好友列表，目前不分远近
 */

#import "RMPlacePoiListResponse.h"
/*
 *获取poi列表
 */
@interface RMPlacePoiListContext : RMCommonContext
{
    RMPlacePoiListResponse *response;  ///< 返回的结果
    NSString *latlon;///json化的经纬度，此时longitude和latitude这组参数不生效。(用于android和symbian
    long requestTime;///请求时间,当有latlon时应传此参数
    NSString *k;///查询的关键字
    NSString *dataType;///为compression的时候，返回值做gzip加密
    NSInteger page;///  分页页码，默认为1
    NSInteger pageSize;///  分页每页技术，默认为10
    NSString *placeData;
    NSString * gLatitude;
    NSString * gLongitude;
    
}
@property(assign, nonatomic) NSInteger page;
@property(assign, nonatomic) NSInteger pageSize;
@property(assign, nonatomic) long requestTime;
@property(assign, nonatomic) NSString *k;
@property(assign, nonatomic) NSString *dataType;
@property(assign, nonatomic) NSString *latlon;
@property(copy, nonatomic) NSString *placeData;
@property(copy, nonatomic) NSString * gLatitude;
@property(copy, nonatomic) NSString * gLongitude;
/**
 *异步请求
 *@param lat_gps	long	gps纬度  
 *@param lon_gps	long	gps经度 
 *@param radius     int     查找半径，单位为米
 *@param d          int     使用的是否是真实经纬度，若是，则设1，若已经使用的是偏转过的经纬度，则设为0
 */  
-(void)asynPoiList:(NSString *)latGps lonGps:(NSString *)lonGps radius:(NSInteger)radius d:(NSInteger)d; 

/**
 *同步请求
 *@param lat_gps	long	gps纬度  
 *@param lon_gps	long	gps经度 
 *@param radius     int     查找半径，单位为米
 *@param d          int     使用的是否是真实经纬度，若是，则设1，若已经使用的是偏转过的经纬度，则设为0
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synPoiList:(NSString *)latGps lonGps:(NSString *)lonGps radius:(NSInteger)radius d:(NSInteger)d error:(RMError **)error;

-(RMPlacePoiListResponse *)getContextResponse;

@end