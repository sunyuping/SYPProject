//
//  RMPlaceAddEvaluationContext.h
//  RMSDK
//
//  Created by Renren on 11-11-10.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMCommonContextPublic.h"
#import "RMGetLBSResultResponse.h"
@interface RMPlaceAddEvaluationContext : RMCommonContext
{
    RMGetLBSResultResponse *response;      ///< 返回的结果
    NSString* lat_gps;                          ///  gps纬度，缺省值为0
    NSString* lon_gps;                          ///  gps经度，缺省值为0
    NSString *latlon;                      ///  json化的经纬度。根据latlon获取所在的经纬度，如果获取经纬度失败，则返回经纬度错误的错误代码
    NSInteger privacy;                     ///  隐私。缺省值为1 ；0为自己可见，1为好友可见，2为所有人可见
    
    NSString *poi_name;                    //POI名称
    NSString *poi_address;                 //POI地址
    NSString *poi_type;	                   //POI分类
}
@property(copy,nonatomic) NSString *lat_gps; 
@property(copy,nonatomic) NSString *lon_gps; 
@property(copy,nonatomic) NSString *latlon; 
@property(assign,nonatomic) NSInteger privacy;

@property(copy,nonatomic) NSString *poi_name; 
@property(copy,nonatomic) NSString *poi_address; 
@property(copy,nonatomic) NSString *poi_type; 
/**
 *发表对某地的点评
 *异步请求
 *@param pid	         
 *@param request_time 请求的时间
 *@param content	  点评的内容
 */
-(void)asynAddEvaluation:(NSString*)pid 
                 request_time:(long)request_time  
                 content:(NSString*)content; 
/**
 *签到
 *同步请求
 *@param pid	         
 *@param request_time 请求的时间
 *@param content	  点评的内容
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */
-(BOOL)synAddEvaluation:(NSString*)pid 
           request_time:(long)request_time  
                content:(NSString*)content 
                  error:(RMError **)error;
-(RMGetLBSResultResponse *)getContextResponse;

@end
