//
//  RMPlaceGetNearByFeedsContext.h
//  RMSDK
//
//  Created by linux on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContext.h"
#import "RMPlaceGetNearByFeedsResponse.h"
/*
 *获取某个poi或者某个经纬度附近的新鲜事 按poi取的时候不包括此poi信息
 */
@interface RMPlaceGetNearByFeedsContext : RMCommonContext

{
    RMPlaceGetNearByFeedsResponse *response;  ///< 返回的结果
    NSString *pid;///pid,如果传了pid，则经纬度参数无效，且不包含此poi新鲜事
    NSString *latlon;///json化的经纬度,若有此值 latGps,lonGps无效
    NSInteger page;///分页页码，默认为1
    NSInteger pageSize;///分页每页技术，默认为10
    NSInteger ubb;///1（返回值为ubb转换过，<img>）/0（返回值没有转换过，(大笑)) 默认为0
    NSInteger radius;///查找半径，单位为米 默认为1
    long requestTime;///请求时间,当有latlon时应传此参数
    NSInteger d;///传的经纬度是否需要偏转，1为需要
    
}
@property(assign, nonatomic) NSInteger page;
@property(assign, nonatomic) NSInteger pageSize;
@property(assign, nonatomic) NSInteger ubb;
@property(assign, nonatomic) NSString *pid;
@property(assign, nonatomic) NSString *latlon;
@property(assign, nonatomic) NSInteger radius;
@property(assign, nonatomic) long requestTime;
@property(assign, nonatomic) NSInteger d;
/**
 *异步请求
 *@param latGps gps纬度
 *@param lonGps gps经度
 */  
-(void)asynGetNearByFeeds:(NSString*)latGps lonGps:(NSString*)lonGps; 

/**
 *同步请求
 *@param latGps gps纬度
 *@param lonGps gps经度
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetNearByFeeds:(NSString*)latGps lonGps:(NSString*)lonGps error:(RMError **)error;
-(RMPlaceGetNearByFeedsResponse *)getContextResponse;

@end