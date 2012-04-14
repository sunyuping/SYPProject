//
//  RMSetStatusContext.h
//  RMSDK
//
//  Created by Renren on 11-10-25.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
/**
 *zh
 * 发布状态
 *
 *en
 * publish status
 */
#import "RMCommonContextPublic.h"
#import "RMGetResultResponse.h"
@interface RMSetStatusContext : RMCommonContext
{
    RMGetResultResponse *response;      ///< 返回的结果                 result return 
    NSString *placeData;                ///描述地理位置的JSON格式字符串    the JSON format string decribed the location
}
@property(copy,nonatomic) NSString *placeData;

/**
 *zh
 * 发布状态
 * 异步请求
 * @param status 状态内容。
 *
 *en
 * publish status
 * Asynchronous request
 * @param status     content of status
 */
-(void)asynSetStatus:(NSString *)status; 
/**
 *zh
 * 发布状态
 * 同步请求
 * @param status 状态内容。
 * @param error 错误信息
 * @return YES 成功 NO 失败
 *
 *en
 *
 * publish status
 * Synchronous request
 * @param status     content of status
 * @param error      error message
 * @return           YES for success     NO for failed
 */
-(BOOL)synSetStatus:(NSString *)status error:(RMError **)error;

-(RMGetResultResponse *)getContextResponse;
@end
