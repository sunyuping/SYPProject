//
//  RMPlaceAddPOIContext.h
//  RMSDK
//
//  Created by Renren on 11-11-9.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMCommonContextPublic.h"
#import "RMPlaceAddPOIResponse.h"
@interface RMPlaceAddPOIContext : RMCommonContext
{
    RMPlaceAddPOIResponse *response;      ///< 返回的结果
    NSString *address;                    ///  POI的地址
    NSString *type;                       ///  POI的类型
    NSString * lat_gps;
    NSString * lon_gps;
    NSInteger d;
    NSString *latlon;
    
}
@property(copy,nonatomic) NSString *address;
@property(copy,nonatomic) NSString *type;
@property(copy,nonatomic) NSString * lat_gps;
@property(copy,nonatomic) NSString * lon_gps;
@property(assign,nonatomic) NSInteger d;
@property(copy,nonatomic) NSString *latlon;
/**
 *创建POI
 *异步请求
 *@param lat_gps	 gps纬度
 *@param lon_gps	 gps经度
 *@param d	         使用的是否是真实经纬度，若是，则设1，若已经使用的是偏转过的经纬度，则设为0
 *@param latlon	     json化的经纬度
 *@param request_time	 请求时间
 *@param name	     POI的名字
 */
-(void)asynAddPOI:(long)request_time name:(NSString*)name; 
/**
 *创建POI
 *同步请求
 *@param lat_gps	 gps纬度
 *@param lon_gps	 gps经度
 *@param d	         使用的是否是真实经纬度，若是，则设1，若已经使用的是偏转过的经纬度，则设为0
 *@param latlon	     json化的经纬度
 *@param request_time	 请求时间
 *@param name	     POI的名字
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */
-(BOOL)synAddPOI:(long)request_time name:(NSString*)name error:(RMError **)error;

-(RMPlaceAddPOIResponse *)getContextResponse;



@end
