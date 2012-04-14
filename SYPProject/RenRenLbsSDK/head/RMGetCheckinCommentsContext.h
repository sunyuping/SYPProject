//
//  RMGetCheckinCommentsContext.h
//  RMSDK
//
//  Created by Renren on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContextPublic.h"
#import "RMGetCheckinCommentsResponse.h"
@interface RMGetCheckinCommentsContext : RMCommonContext
{
    RMGetCheckinCommentsResponse *response;      ///< 返回的结果
     NSInteger page;                             ///  分页页码，默认为1
     NSInteger page_size;                        ///  分页每页技术，默认为10
     NSInteger sort;                             ///  列表时间排序方式（0：时间递减，1：时间递增）
     NSInteger exclude_list;                     ///  是否排除列表（1：只取数，不取列表）
     NSInteger with_pci;                         ///  是否包含checkin信息（1：包含）
}
@property(assign,nonatomic) NSInteger page;
@property(assign,nonatomic) NSInteger page_size; 
@property(assign,nonatomic) NSInteger sort; 
@property(assign,nonatomic) NSInteger exclude_list; 
@property(assign,nonatomic) NSInteger with_pci; 

-(void)asynGetCheckinComments:(NSString*)cid 
                       userID:(NSString*)uid; 

-(BOOL)synGetCheckinComments:(NSString*)cid 
                      userID:(NSString*)uid 
                  error:(RMError **)error;

-(RMGetCheckinCommentsResponse *)getContextResponse;

@end
