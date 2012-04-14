//
//  RMPlaceGetFeedsByPidContext.h
//  RMSDK
//
//  Created by Renren on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContext.h"
#import "RMPlaceGetFeedsByPidResponse.h"
/*
 *按poi获取某地的新鲜事
 */
@interface RMPlaceGetFeedsByPidContext : RMCommonContext

{
    RMPlaceGetFeedsByPidResponse *response;  ///< 返回的结果
    NSInteger page;///分页页码，默认为1
    NSInteger pageSize;///分页每页技术，默认为10
    NSInteger ubb;///1（返回值为ubb转换过，<img>）/0（返回值没有转换过，(大笑)), 默认为0
    
}
@property(assign, nonatomic) NSInteger page;
@property(assign, nonatomic) NSInteger pageSize;
@property(assign, nonatomic) NSInteger ubb;
/**
 *异步请求
 *@param pid 
 */  
-(void)asynGetFeedsByPid:(NSString*)pid; 

/**
 *同步请求
 *@param pid
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetFeedsByPid:(NSString*)pid error:(RMError **)error;
-(RMPlaceGetFeedsByPidResponse *)getContextResponse;


@end
