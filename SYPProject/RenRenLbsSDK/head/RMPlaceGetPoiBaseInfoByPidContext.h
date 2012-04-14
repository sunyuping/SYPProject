//
//  RMPlaceGetPoiBaseInfoByPidContext.h
//  RMSDK
//
//  Created by Renren on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContext.h"
#import "RMPlaceGetPoiBaseInfoByPidResponse.h"
@interface RMPlaceGetPoiBaseInfoByPidContext : RMCommonContext
{
    NSInteger radius;              ///查找半径，单位为米 默认为1
    RMPlaceGetPoiBaseInfoByPidResponse *response;  ///< 返回的结果
}
@property(assign, nonatomic) NSInteger radius;

/**
 *异步请求
 *@param pid	 long	  
 *@param gz	     int	 1（返回值为gzip压缩过）/0（返回值不压缩）
 *@param ubb	 int	 1（返回值为ubb转换过，<img>）/0（返回值没有转换过， 
 */  
-(void)asynGetPoiBaseInfoByPid:(NSString *)pid gz:(NSInteger)gz ubb:(NSInteger)ubb; 

/**
 *同步请求
 *@param pid	 long	  
 *@param gz	     int	 1（返回值为gzip压缩过）/0（返回值不压缩）
 *@param ubb	 int	 1（返回值为ubb转换过，<img>）/0（返回值没有转换过， 
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetPoiBaseInfoByByPid:(NSString *)pid gz:(NSInteger)gz ubb:(NSInteger)ubb error:(RMError **)error;
-(RMPlaceGetPoiBaseInfoByPidResponse *)getContextResponse;

@end
