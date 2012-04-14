//
//  RMPlaceGetStaticMapByPidResponse.h
//  RMSDK
//
//  Created by Renren on 12-3-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
#import "RMPlaceData.h"
///RMPlaceGetStaticMapByPidResponse根据PID获取静态地图
@interface RMPlaceGetStaticMapByPidResponse : RMObject{
    double latitude;///维度
    double longitude;///经度
    NSString *staticMapUrl;///地图地址
}
@property(nonatomic, readonly)double latitude;
@property(nonatomic, readonly)double longitude;
@property(nonatomic, readonly)NSString *staticMapUrl;
@end
