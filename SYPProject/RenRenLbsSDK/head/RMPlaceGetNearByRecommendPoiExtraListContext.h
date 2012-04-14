//
//  RMPlaceGetNearByRecommendPoiExtraListContext.h
//  RMSDK
//
//  Created by Renren on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RMPlaceGetNearByRecommendPoiExtraListResponse.h"
/*
 *周边Poi推荐(附近推荐list用)
 */
@interface RMPlaceGetNearByRecommendPoiExtraListContext : RMCommonContext
{
    RMPlaceGetNearByRecommendPoiExtraListResponse *response;  ///< 返回的结果
    NSString *latlon;///json化的经纬度，此时longitude和latitude这组参数不生效。
    NSInteger page;///分页页码，默认为1
    NSInteger pageSize;///分页每页技术，默认为10
    NSInteger radius;///查找半径，单位为米 默认为1
    long requestTime;///请求时间,当有latlon时应传此参数
    NSInteger type;///类型，默认为-1; -1=全部 1=吃饭 2=聚会玩乐 3=逛街 4=酒吧夜店 5=聊天小坐 6=旅游 7=住宿
}
@property(assign, nonatomic) NSInteger page;
@property(assign, nonatomic) NSInteger pageSize;
@property(assign, nonatomic) NSString *latlon;
@property(assign, nonatomic) NSInteger radius;
@property(assign, nonatomic) long requestTime;
@property(assign, nonatomic) NSInteger type;

/**
 *异步请求
 *@param latGps 经度（为实际经度乘以106）
 *@param lonGps 纬度（为实际纬度乘以106）
 *@param d 使用的是否是真实经纬度，若是，则设1，若已经使用的是偏转过的经纬度，则设为0
 */  
-(void)asynGetRecommendPoiExtraList:(NSString*)latGps lonGps:(NSString*)lonGps d:(NSInteger)d;

/**
 *同步请求
 *@param latGps 经度（为实际经度乘以106）
 *@param lonGps 纬度（为实际纬度乘以106）
 *@param d 使用的是否是真实经纬度，若是，则设1，若已经使用的是偏转过的经纬度，则设为0
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetRecommendPoiExtraList:(NSString*)latGps lonGps:(NSString*)lonGps d:(NSInteger)d error:(RMError **)error;
-(RMPlaceGetNearByRecommendPoiExtraListResponse *)getContextResponse;
@end
