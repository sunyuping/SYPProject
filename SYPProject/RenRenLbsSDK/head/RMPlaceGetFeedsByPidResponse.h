//
//  RMPlaceGetFeedsByPidResponse.h
//  RMSDK
//
//  Created by Renren on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
///RMPlaceGetFeedsByPidResponse通过PID获取某地的新鲜事列表
@interface RMPlaceGetFeedsByPidResponse : RMObject
{
    NSMutableArray *feed_list;  ///新鲜事列表  
    NSInteger count;  ///数量
    NSInteger page_size;///页面大小
    long lat_gps;///GPS维度
	long lon_gps;///GPS经度
	NSInteger need2deflect;///是否偏转
	NSInteger locate_type;///位置类型

}
@property(nonatomic, readonly) NSMutableArray *feed_list;
@property(nonatomic, readonly) NSInteger count;
@property(nonatomic, readonly) NSInteger page_size;
@property(nonatomic, readonly) long lat_gps;
@property(nonatomic, readonly) long lon_gps;
@property(nonatomic, readonly) NSInteger need2deflect;
@property(nonatomic, readonly) NSInteger locate_type;
@end
