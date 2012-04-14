//
//  RMPlaceGetPoiBaseInfoByLbsIdContext.h
//  RMSDK
//
//  Created by Renren on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

/**
 * 发布状态
 */

#import "RMCommonContext.h"
#import "RMPlaceGetPoiBaseInfoByLbsIdResponse.h"
@interface RMPlaceGetPoiBaseInfoByLbsIdContext : RMCommonContext
{
    NSInteger radius;              ///查找半径，单位为米 默认为1
    RMPlaceGetPoiBaseInfoByLbsIdResponse *response;  ///< 返回的结果
}
@property(assign, nonatomic) NSInteger radius;

/**
 *异步请求
 *@param lbs_id	 long	 lbs_data表中的主键 
 *@param gz	     int	 1（返回值为gzip压缩过）/0（返回值不压缩）
 *@param ubb	 int	 1（返回值为ubb转换过，<img>）/0（返回值没有转换过， 
 */  
-(void)asynGetPoiBaseInfoByLbsId:(NSString*)lbs_id gz:(NSInteger)gz ubb:(NSInteger)ubb; 

/**
 *同步请求
 *@param lbs_id	 long	 lbs_data表中的主键 
 *@param gz	     int	 1（返回值为gzip压缩过）/0（返回值不压缩）
 *@param ubb	 int	 1（返回值为ubb转换过，<img>）/0（返回值没有转换过， 
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetPoiBaseInfoByLbsId:(NSString*)lbs_id gz:(NSInteger)gz ubb:(NSInteger)ubb error:(RMError **)error;
-(RMPlaceGetPoiBaseInfoByLbsIdResponse *)getContextResponse;

@end
