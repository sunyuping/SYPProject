//
//  RMPlaceGetPoiCategoryResponse.h
//  RMSDK
//
//  Created by Renren on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
///	RMPlaceGetPoiCategoryResponse	 获取poi分类列表
@interface RMPlaceGetPoiCategoryResponse : RMObject{
NSMutableArray *category_list;     ///分类列表
NSInteger count;                    /// 数量
}
@property(nonatomic, readonly) NSMutableArray *category_list;
@property(nonatomic, readonly) NSInteger count;
@end
