//
//  RMPlaceGetNearbyActivityNoticeCountContext.h
//  RMSDK
//
//  Created by Renren on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContext.h"
#import "RMPlaceGetNearbyActivityNoticeCountResponse.h"
@interface RMPlaceGetNearbyActivityNoticeCountContext : RMCommonContext
{
    NSString *latlon;               ///json化的经纬度,若有此值 latGps,lonGps无效
    NSInteger d;                    ///传的经纬度是否需要偏转,1偏，0不偏，默认为0
    NSInteger radius;              ///查找半径，单位为米 默认为1
    RMPlaceGetNearbyActivityNoticeCountResponse *response;  ///< 返回的结果
}
@property(assign, nonatomic) NSInteger radius;
@property(assign, nonatomic) NSInteger d;
@property(copy, nonatomic) NSString *latlon; 
/**
 *异步请求
 *@param lat_gps	long	gps纬度  
 *@param lon_gps	long	gps经度 
 */  
-(void)asynGetNearbyActivityNoticeCount:(NSString*)lat_gps lon_gps:(NSString*)lon_gps; 

/**
 *同步请求
 *@param lat_gps	long	gps纬度  
 *@param lon_gps	long	gps经度 
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetNearbyActivityNoticeCount:(NSString*)lat_gps lon_gps:(NSString*)lon_gps error:(RMError **)error;
-(RMPlaceGetNearbyActivityNoticeCountResponse *)getContextResponse;

@end
