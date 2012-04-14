//
//  RMGetEvaluationResponse.h
//  RMSDK
//
//  Created by Renren on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
///RMGetEvaluationResponse获取某点评
@interface RMGetEvaluationResponse : RMObject
{
	long evaluationId; ///评论的id
	NSInteger user_id; ///用户id
	NSInteger comment_count;///评论数
	NSString *content;///内容
	long time;///时间
}
@property(nonatomic, readonly) NSString *content;
@property(nonatomic, readonly) NSInteger user_id;
@property(nonatomic, readonly) NSInteger comment_count;
@property(nonatomic, readonly) long evaluationId;
@property(nonatomic, readonly) long time;
@end
