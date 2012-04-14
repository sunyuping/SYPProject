//
//  RMGetEvaluationCommentsResponse.h
//  RMSDK
//
//  Created by Renren on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"

@interface RMGetEvaluationCommentsResponse :RMResponse{
    NSMutableArray *comment_list;       /// 评论列表
    NSInteger page_size;                /// 页面大小
    NSInteger count;                    /// 数量
}
@property(nonatomic, readonly) NSMutableArray *comment_list;
@property(nonatomic, readonly) NSInteger page_size;
@property(nonatomic, readonly) NSInteger count;


@end
