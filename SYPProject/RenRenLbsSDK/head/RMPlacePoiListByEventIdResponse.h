//
//  RMPlacePoiListByEventIdResponse.h
//  RMSDK
//
//  Created by Renren on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
#import "RMPlaceData.h"
///RMPlacePoiListByEventIdResponse通过活动id（eventId）获取活动所在地的poi列表
@interface RMPlacePoiListByEventIdResponse : RMObject
{
    NSInteger count;///数量
    NSMutableArray *poidataInfoList;///POI列表

}

@property(nonatomic, readonly)NSInteger count;
@property(nonatomic, readonly)NSMutableArray *poidataInfoList;

@end
