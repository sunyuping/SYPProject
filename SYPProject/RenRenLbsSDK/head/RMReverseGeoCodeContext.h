//
//  RMReverseGeoCodeContext.h
//  RMSDK
//
//  Created by Renren on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContext.h"
#import "RMReverseGeoCodeResponse.h"
@interface RMReverseGeoCodeContext : RMCommonContext
{
    RMReverseGeoCodeResponse *response;  ///< 返回的结果
    
}
/**
 * 按pid取poi信息
 * 异步请求
 */  
-(void)asynReverseGeoCode:(long)longitude latitude:(long)latitude; 

/**
 *  按pid取poi信息
 *  同步请求
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synReverseGeoCode:(long)longitude latitude:(long)latitude error:(RMError **)error;

-(RMReverseGeoCodeResponse *)getContextResponse;

@end
