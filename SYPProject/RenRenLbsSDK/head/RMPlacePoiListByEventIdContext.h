//
//  RMPlacePoiListByEventIdContext.h
//  RMSDK
//
//  Created by Renren on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContext.h"
#import "RMPlacePoiListByEventIdResponse.h"
/*
 *通过活动id（eventId）获取活动所在地的poi列表
 */
@interface RMPlacePoiListByEventIdContext : RMCommonContext
{
    RMPlacePoiListByEventIdResponse *response;  ///< 返回的结果
    NSInteger page;///  分页页码，默认为1
    NSInteger pageSize;///  分页每页技术，默认为10
}
@property(assign, nonatomic) NSInteger page;
@property(assign, nonatomic) NSInteger pageSize;

/**
 *异步请求
 *@param eventId 活动id
 */  
-(void)asynGetPoiListByEventId:(NSString*)eventId; 

/**
 *同步请求
 *@param eventId 活动id
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetPoiListByEventId:(NSString*)eventId error:(RMError **)error;
-(RMPlacePoiListByEventIdResponse *)getContextResponse;

@end
