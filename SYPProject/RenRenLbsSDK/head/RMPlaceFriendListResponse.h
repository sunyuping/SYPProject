//
//  RMPlaceFriendListResponse.h
//  RMSDK
//
//  Created by Renren on 11-12-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"
///RMPlaceFriendListResponse  获取好友列表，目前不分远近
@interface RMPlaceFriendListResponse : RMObject
{
    NSMutableArray *friends_list;    ///好友列表
    NSInteger count;                    /// 数量
    NSString *lat_gps;///GPS维度
	NSString *lon_gps;///GPS经度
	NSInteger page_size;///页面大小
	NSInteger need2deflect;///是否偏转
	NSInteger locate_type;///位置类型
	NSString * lat_deflect;///偏转维度
	NSString * lon_deflect; ///偏转经度
}
@property(nonatomic, readonly) NSMutableArray *friends_list;
@property(nonatomic, readonly) NSInteger count;
@property(nonatomic, readonly) NSString * lat_gps;
@property(nonatomic, readonly) NSString * lon_gps;
@property(nonatomic, readonly) NSInteger page_size;
@property(nonatomic, readonly) NSInteger need2deflect;
@property(nonatomic, readonly) NSInteger locate_type;
@property(nonatomic, readonly) NSString * lat_deflect;
@property(nonatomic, readonly) NSString * lon_deflect; 

@end
