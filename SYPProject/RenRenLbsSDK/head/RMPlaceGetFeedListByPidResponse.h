//
//  RMPlaceGetFeedListByPidResponse.h
//  RMSDK
//
//  Created by seven liu on 12-3-1.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RMObject.h"
///RMPlaceGetFeedListByPidResponse通过PID获取某地的新鲜事列表
@interface RMPlaceGetFeedListByPidResponse : RMObject{
    NSMutableArray *lbsFeedInfoList;     ///LBS新鲜事信息列表
    NSInteger count;                    /// 数量
}
@property(nonatomic, readonly) NSMutableArray *lbsFeedInfoList;
@property(nonatomic, readonly) NSInteger count;
@end