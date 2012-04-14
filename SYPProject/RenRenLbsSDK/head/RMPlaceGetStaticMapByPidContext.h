//
//  RMPlaceGetStaticMapByPidContext.h
//  RMSDK
//
//  Created by Renren on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RMPlaceGetStaticMapByPidResponse.h"
/*
 *根据PID获取静态地图的URL
 */
@interface RMPlaceGetStaticMapByPidContext : RMCommonContext
{
    RMPlaceGetStaticMapByPidResponse *response;  ///< 返回的结果
    NSString *pointName;///标注的名称
    NSInteger height;///地图的高度,默认为320,单位为像素
    NSInteger width;///地图的宽度,默认为240,单位为像素
    NSInteger zoom;///地图的zoom值，尺寸，1-11，默认11

}
@property(assign, nonatomic) NSInteger height;
@property(assign, nonatomic) NSInteger width;
@property(assign, nonatomic) NSString *pointName;
@property(assign, nonatomic) NSInteger zoom;


/**
 *异步请求
 *@param pid
 */  
-(void)asynGetStaticMapByPid:(NSString*)pid;

/**
 *同步请求
 *@param pid
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetStaticMapByPid:(NSString*)pid error:(RMError **)error;
-(RMPlaceGetStaticMapByPidResponse *)getContextResponse;
@end
