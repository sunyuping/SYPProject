//
//  RMPlaceFriendListContext.h
//  RMSDK
//
//  Created by Renren on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

/**
 * 获取好友列表，目前不分远近
 */

#import "RMCommonContext.h"
#import "RMPlaceFriendListResponse.h"
@interface RMPlaceFriendListContext : RMCommonContext
{
    RMPlaceFriendListResponse *response;  ///< 返回的结果
    NSInteger page; ///  分页页码，默认为1
    NSInteger pageSize;///  分页每页技术，默认为10
    NSInteger excludeList;///是否包含commentlist 为1时表示不包含
    NSString *order_type;///time（时间倒序）/distance（距离正序） 默认为time
    NSString *data_type;///all（所有数据）/near（附近的数据） 默认为all
    NSInteger radius;///判断附近的半径，默认为1，单位为公里
    
}
@property(assign, nonatomic) NSInteger page;
@property(assign, nonatomic) NSInteger pageSize;
@property(assign, nonatomic) NSInteger excludeList;
@property(assign, nonatomic) NSString *order_type;
@property(assign, nonatomic) NSString *data_type;
@property(assign, nonatomic) NSInteger radius;
/**
 *异步请求
 *@param latlon	 带有经纬度信息的json
 *@param lat_gps gps纬度（无效的话是255000000）
 *@param lon_gps gps经度（无效的话是255000000）
 *@param d	 是否需要偏转
 *@param request_time latlon请求时间
 */  
-(void)asynFriendList:(NSString*)latlon lat_gps:(NSString*)lat_gps lon_gps:(NSString*)lon_gps d:(NSInteger)d request_time:(double)request_time; 

/**
 *同步请求
 *@param latlon	 带有经纬度信息的json
 *@param lat_gps gps纬度（无效的话是255000000）
 *@param lon_gps gps经度（无效的话是255000000）
 *@param d	 是否需要偏转
 *@param request_time latlon请求时间
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synFriendList:(NSString*)latlon lat_gps:(NSString*)lat_gps lon_gps:(NSString*)lon_gps d:(NSInteger)d request_time:(double)request_time error:(RMError **)error;
-(RMPlaceFriendListResponse *)getContextResponse;



@end
