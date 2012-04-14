//
//  RMPlaceGetLocalCheckinListByPidContext.h
//  RMSDK
//
//  Created by Renren on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContext.h"

@interface RMPlaceGetLocalCheckinListByPidContext : RMCommonContext

{
   // RMPlacePoiListByEventIdResponse *response;  ///< 返回的结果
    NSInteger page;///  分页页码，默认为1
    NSInteger pageSize;///  分页每页技术，默认为10
}
@property(assign, nonatomic) NSInteger page;
@property(assign, nonatomic) NSInteger pageSize;

/**
 *异步请求
 *@param pid
 */  
-(void)asynGetCheckinListByPid:(NSString*)pid; 

/**
 *同步请求
 *@param pid
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetCheckinListByPid:(NSString*)pid error:(RMError **)error;
//-(RMPlacePoiListByEventIdResponse *)getContextResponse;
@end
