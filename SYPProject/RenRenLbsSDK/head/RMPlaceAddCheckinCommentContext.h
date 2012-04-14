//
//  RMPlaceAddCheckinCommentContext.h
//  RMSDK
//
//  Created by linux on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMGetResultResponse.h"
#import "RMCommonContextPublic.h"

@interface RMPlaceAddCheckinCommentContext : RMCommonContext
{
    RMGetResultResponse *response;     ///< 返回的结果
}

/**
 * 签到回复
 * 异步请求
 *@param content    回复的内容
 *@param cid        checkin id
 *@param uid        checkin owner id
 *@param rid        回复对象id，直接回复可以不填
 */
- (void)asynAddCheckInComment:(NSString *)content checkinId:(NSString *)cid ownerId:(NSString *)uid 
                      ReplyId:(NSString *)rid;

/**
 * 签到回复
 * 同步步请求
 *@param content    回复的内容
 *@param cid        checkin id
 *@param uid        checkin owner id
 *@param rid        回复对象id，直接回复可以不填
 *@param error      错误信息
  *@return YES 成功 NO 失败
 */
- (BOOL)synAddCheckInComment:(NSString *)content checkinId:(NSString *)cid ownerId:(NSString *)uid 
                     ReplyId:(NSString *)rid error:(RMError **)error;

// 初始化传递的参数
- (NSMutableDictionary *)initParamsDictionary:(NSString *)content checkinId:(NSString *)cid ownerId:(NSString *)uid ReplyId:(NSString *)rid;

- (RMGetResultResponse *)getContextResponse;
@end
