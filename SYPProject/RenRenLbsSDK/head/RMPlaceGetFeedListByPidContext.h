//
//  RMPlaceGetFeedListByPidContext.h
//  RMSDK
//
//  Created by Renren on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "RMPlaceGetFeedListByPidResponse.h"
/*
 *通过PID获取某地的新鲜事列表
 */
@interface RMPlaceGetFeedListByPidContext : RMCommonContext
{
    RMPlaceGetFeedListByPidResponse *response;  ///< 返回的结果
    NSInteger page;///分页页码，默认为1
    NSInteger pageSize;///分页每页技术，默认为10
    NSInteger bizType ;///biz_type=3 得到的是签到列表；biz_type=4 得到的是评论列表。缺省值为3

}
@property(assign, nonatomic) NSInteger page;
@property(assign, nonatomic) NSInteger pageSize;
@property(assign, nonatomic) NSInteger bizType;

/**
 *异步请求
 *@param pid
 */  
-(void)asynGetFeedListByPid:(NSString *)pid;

/**
 *同步请求
 *@param pid
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetFeedListByPid:(NSString *)pid error:(RMError **)error;
-(RMPlaceGetFeedListByPidResponse *)getContextResponse;
@end