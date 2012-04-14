//
//  RMPlaceGetPoiCategoryContext.h
//  RMSDK
//
//  Created by Renren on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//


#import "RMPlaceGetPoiCategoryResponse.h"
@interface RMPlaceGetPoiCategoryContext : RMCommonContext
{
    NSString *data_type;              ///查找半径，单位为米 默认为1
    RMPlaceGetPoiCategoryResponse *response;  ///< 返回的结果
}
@property(copy, nonatomic) NSString *data_type;

/**
 *异步请求
 */  
-(void)asynGetPoiCategory; 

/**
 *同步请求
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synGetPoiCategory:(RMError **)error;
-(RMPlaceGetPoiCategoryResponse *)getContextResponse;


@end
