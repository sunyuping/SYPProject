//
//  RMPlaceGetNearbyActivityListByPidContext.h
//  RMSDK
//
//  Created by Renren on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContext.h"
#import "RMPlaceGetNearbyActivityListByPidResponse.h"
/*
 *返回某个pid周边的活动poi列表
 */
@interface RMPlaceGetNearbyActivityListByPidContext : RMCommonContext
{
    RMPlaceGetNearbyActivityListByPidResponse *response;  ///< 返回的结果
    NSInteger page;///分页页码，默认为1
    NSInteger pageSize;///分页每页技术，默认为20
    NSInteger excludeList;///为1时将不返回活动列表数据
    NSInteger radius;///查找半径，单位为米 默认为1
}
@property(assign, nonatomic) NSInteger page;
@property(assign, nonatomic) NSInteger pageSize;
@property(assign, nonatomic) NSInteger excludeList;
@property(assign, nonatomic) NSInteger radius;
/**
 *异步请求
 *@param pid pid
 */  
-(void)asynGetNearbyActivityListByPid:(NSString*)pid; 

/**
 *同步请求
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetNearbyActivityListByPid:(NSString*)pid error:(RMError **)error;
-(RMPlaceGetNearbyActivityListByPidResponse *)getContextResponse;


@end
