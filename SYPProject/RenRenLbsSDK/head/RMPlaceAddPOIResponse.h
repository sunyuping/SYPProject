//
//  RMPlaceAddPOIResponse.h
//  RMSDK
//
//  Created by Renren on 11-11-9.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMObject.h"
@class RMPlaceAdd;

@interface RMPlaceAddPOIResponse : RMObject{
    NSInteger distance;             /// 距离
    NSInteger need2deflect;        
    NSInteger locate_type;          /// 定位类型
    NSString *lat_gps;              /// gps纬度
    NSString *lon_gps;              /// gps经度
    RMPlaceAdd  *placeAdd;          /// 基本信息
}
@property(nonatomic, readonly) RMPlaceAdd  *placeAdd;
@property(nonatomic, readonly) NSInteger distance;
@property(nonatomic, readonly) NSInteger need2deflect;
@property(nonatomic, readonly) NSInteger locate_type;
@property(nonatomic, readonly) NSString *lat_gps;
@property(nonatomic, readonly) NSString *lon_gps;


@end
