//
//  RMPlaceCheckinContext.h
//  RMSDK
//
//  Created by Renren on 11-11-9.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMCommonContextPublic.h"
#import "RMGetLBSResultResponse.h"
@interface RMPlaceCheckinContext : RMCommonContext
{
    RMGetLBSResultResponse *response;      ///< 返回的结果
    NSString *status;                      ///  签到的内容
    NSString *lat_gps;                     ///  gps纬度，缺省值为0
    NSString *lon_gps;                     ///  gps经度，缺省值为0
    NSString *latlon;                      ///  json化的经纬度。根据latlon获取所在的经纬度，如果获取经纬度失败，则签到失败
    NSInteger privacy;                     ///  隐私。缺省值为1 ；0为自己可见，1为好友可见，2为所有人可见
    NSString *poi_name; 
    NSString *poi_address; 
    NSString *poi_type; 
}
@property(copy,nonatomic) NSString *status;                   
@property(copy,nonatomic) NSString *lat_gps; 
@property(copy,nonatomic) NSString *lon_gps; 
@property(copy,nonatomic) NSString *latlon; 
@property(copy,nonatomic) NSString *poi_name; 
@property(copy,nonatomic) NSString *poi_address; 
@property(copy,nonatomic) NSString *poi_type; 
@property(assign,nonatomic) NSInteger privacy;

/**
 *签到
 *异步请求
 *@param pid	         
 */
-(void)asynCheckin:(NSString*)pid; 
/**
 *签到
 *同步请求
 *@param pid	         
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */
-(BOOL)synCheckin:(NSString*)pid error:(RMError **)error;

-(RMGetLBSResultResponse *)getContextResponse;

@end
