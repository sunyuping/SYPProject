//
//  RMLocateContext.h
//  RMSDK
//
//  Created by Renren on 11-12-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMCommonContext.h"
#import "RMLocateResponse.h"
@interface RMLocateContext : RMCommonContext
{
    RMLocateResponse *response;  ///< 返回的结果
    NSString *latlon;///son化的经纬度,若有此值 gpsLatitude,gpsLongitude 无效。gpsLatitude、gpsLongitude或latlon必须存在一个，不能都不存在。
    NSInteger cl;/// 如果传输的latlon参数为gzip压缩后再经过AES加密，最后Base64编码的数据，那么值为1。如果不是则为0。缺省值为0
    NSInteger p_zip; /// 如果传输的latlon参数为gzip压缩后再经过Base64编码的数据，那么值为1。如果不是则为0。缺省值为0 
        NSString *placeData;
    long gLatitude;
    long gLongitude;
    NSInteger privacy;
}
@property(copy, nonatomic) NSString *latlon;
@property(copy, nonatomic) NSString *placeData;
@property(assign, nonatomic) NSInteger p_zip; 
@property(assign, nonatomic) NSInteger cl;
@property(readonly, nonatomic) long gLatitude;
@property(readonly, nonatomic) long gLongitude;
@property(assign, nonatomic) NSInteger privacy;
/**
 *@gpsLatitude gps的纬度
 *@gpsLongitude gps的经度
 * 异步请求
 */  
-(void)asynLocate:(long)gpsLatitude gpsLongitude:(long)gpsLongitude; 

/**
 *@gpsLatitude gps的纬度
 *@gpsLongitude gps的经度
 *  同步请求
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */  
-(BOOL)synLocate:(long)gpsLatitude gpsLongitude:(long)gpsLongitude error:(RMError **)error;


-(RMLocateResponse *)getContextResponse;
@end
