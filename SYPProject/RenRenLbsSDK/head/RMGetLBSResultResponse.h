//
//  RMGetLBSResultResponse.h
//  RMSDK
//
//  Created by Renren on 11-11-24.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"

@interface RMGetLBSResultResponse :RMResponse{
    NSString *result;           /// 结果
    NSString *message;          /// 消息
    NSString *lat_gps;          /// gps纬度
    NSString *lon_gps;          /// gps经度
    NSInteger need2deflect;     
    NSInteger locate_type;      /// 定位类型
}
@property(nonatomic, readonly) NSString *result;
@property(nonatomic, readonly) NSString *message;
@property(nonatomic, readonly) NSString *lat_gps;
@property(nonatomic, readonly) NSString *lon_gps;
@property(nonatomic, readonly) NSInteger need2deflect;
@property(nonatomic, readonly) NSInteger locate_type;


@end
