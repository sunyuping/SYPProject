//
//  RMGetEvaluationContext.h
//  RMSDK
//
//  Created by Renren on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContext.h"
#import "RMGetEvaluationResponse.h"
/*
 *获取某点评
 */
@interface RMGetEvaluationContext : RMCommonContext
{
    RMGetEvaluationResponse *response;  ///< 返回的结果
    NSString *reply_id;///被回复人的id
}
@property(copy, nonatomic) NSString *reply_id;
/**
 *异步请求
 *@param 点评的id
 *@param 点评拥有者id
 */  
-(void)asynGetEvaluation:(NSString *)eId owner_id:(NSString *)owner_id; 

/**
 *同步请求
 *@param 点评的id
 *@param 点评拥有者id
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetEvaluation:(NSString *)eId owner_id:(NSString *)owner_id error:(RMError **)error;
-(RMGetEvaluationResponse *)getContextResponse;

@end
