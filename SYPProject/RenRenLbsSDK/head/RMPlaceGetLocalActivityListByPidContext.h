//
//  RMPlaceGetLocalActivityListByPidContext.h
//  RMSDK
//
//  Created by Renren on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
/*
 *返回某个pid的活动列表
 */

#import "RMCommonContext.h"
#import "RMPlaceGetLocalActivityListByPidResponse.h"
@interface RMPlaceGetLocalActivityListByPidContext : RMCommonContext
{
    RMPlaceGetLocalActivityListByPidResponse *response;  ///< 返回的结果
    NSInteger page;///分页页码，默认为1
    NSInteger pageSize;///分页每页技术，默认为20
    NSInteger excludeList;///为1时将不返回活动列表数据
    
}
@property(assign, nonatomic) NSInteger page;
@property(assign, nonatomic) NSInteger pageSize;
@property(assign, nonatomic) NSInteger excludeList;
/**
 *异步请求
 *@param pid 
 */  
-(void)asynGetLocalActivityListByPid:(NSString*)pid; 

/**
 *同步请求
 *@param pid
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetLocalActivityListByPid:(NSString*)pid error:(RMError **)error;
-(RMPlaceGetLocalActivityListByPidResponse *)getContextResponse;


@end
