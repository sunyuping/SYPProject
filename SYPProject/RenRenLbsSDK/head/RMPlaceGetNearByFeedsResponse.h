//
//  RMPlaceGetNearByFeedsResponse.h
//  RMSDK
//
//  Created by linux on 11-12-30.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
///RMPlaceGetNearByFeedsResponse获取某个poi或者某个经纬度附近的新鲜事
@interface RMPlaceGetNearByFeedsResponse : RMObject
{
    NSInteger count;///数量
    NSInteger pageSize;///页面大小
    NSMutableArray *placeFeedList;///新鲜事列表
    NSInteger need2deflect;///是否偏转
    NSInteger locateType;///位置属性
    NSString *latGps;///GPS维度
    NSString * lonGps;///GPS经度
}

@property(nonatomic, readonly)NSInteger count;
@property(nonatomic, readonly)NSInteger pageSize;
@property(nonatomic, readonly)NSMutableArray *placeFeedList;
@property(nonatomic, readonly)NSInteger need2deflect;
@property(nonatomic, readonly)NSInteger locateType;
@property(nonatomic, readonly)NSString * latGps;
@property(nonatomic, readonly)NSString * lonGps;
@end