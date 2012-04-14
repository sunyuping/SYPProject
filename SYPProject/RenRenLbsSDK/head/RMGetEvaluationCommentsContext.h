//
//  RMGetEvaluationCommentsContext.h
//  RMSDK
//
//  Created by Renren on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContextPublic.h"
#import "RMGetEvaluationCommentsResponse.h"
@interface RMGetEvaluationCommentsContext : RMCommonContext
{
    RMGetEvaluationCommentsResponse *response;  ///< 返回的结果
    NSInteger page;                             ///  分页页码，默认为1
    NSInteger page_size;                        ///  页面大小，默认20
    NSInteger sort;                             ///  sort=1为倒序
    NSInteger exclude_list;                     ///  是否包含列表，1为不包含
    NSInteger with_evaluation;                  ///  是否包含点评详细信息，1为包含
}
@property(assign,nonatomic) NSInteger page;
@property(assign,nonatomic) NSInteger page_size; 
@property(assign,nonatomic) NSInteger sort; 
@property(assign,nonatomic) NSInteger exclude_list; 
@property(assign,nonatomic) NSInteger with_evaluation; 

-(void)asynGetEvaluationComments:(NSString*)cid 
                       userID:(NSString*)user_id; 

-(BOOL)synGetEvaluationComments:(NSString*)cid 
                      userID:(NSString*)user_id 
                       error:(RMError **)error;

-(RMGetEvaluationCommentsResponse *)getContextResponse;
@end
