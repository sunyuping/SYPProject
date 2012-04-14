//
//  RMPlaceAddEvaluationCommentContext.h
//  RMSDK
//
//  Created by linux on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMCommonContextPublic.h"
#import "RMGetResultResponse.h"

@interface RMPlaceAddEvaluationCommentContext : RMCommonContext
{
    RMGetResultResponse *response;                   ///< 返回的结果
    NSString *rid;                                   ///  被回复人的id
    NSInteger privace;                               ///  隐私。缺省值为1 ；0为自己可见，1为好友可见，2为所有人可见
}

@property (nonatomic, copy) NSString *rid;
@property (nonatomic, assign) NSInteger privace;

// 初始化传递的参数
- (NSMutableDictionary *)initParamDictionary:(NSString *)content ownerId:(NSString *)ownerId commentId:(NSString *)commentId;

/**
 * 发表对某地的点评
 * 异步请求
 *@param content 评论的内容
 *@param ownerId 点评拥有者id
 *@param commentId 点评的id
 */
- (void)asynAddEvaluatioinComment:(NSString *)content ownerId:(NSString *)ownerId commentId:(NSString *)commentId;

/**
 * 发表对某地的点评
 * 同步请求
 *@param content 评论的内容
 *@param ownerId 点评拥有者id
 *@param commentId 点评的id
 *@param error 错误消息
 *@return YES 成功 NO 失败
 */
- (BOOL)synAddEvaluatioinComment:(NSString *)content ownerId:(NSString *)ownerId commentId:(NSString *)commentId error:(RMError **)error;

- (RMGetResultResponse *)getContextResponse;
@end