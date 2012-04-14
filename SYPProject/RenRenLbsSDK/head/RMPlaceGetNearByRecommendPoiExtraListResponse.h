//
//  RMPlaceGetNearByRecommendPoiExtraListResponse.h
//  RMSDK
//
//  Created by Renren on 12-2-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
///RMPlaceGetNearByRecommendPoiExtraListResponse周边Poi推荐(附近推荐list用)
@interface RMPlaceGetNearByRecommendPoiExtraListResponse : RMObject{
NSMutableArray *poiDataExtraList;  ///POI列表   
NSInteger count;                    /// 数量
}
@property(nonatomic, readonly) NSMutableArray *poiDataExtraList;
@property(nonatomic, readonly) NSInteger count;
@end
