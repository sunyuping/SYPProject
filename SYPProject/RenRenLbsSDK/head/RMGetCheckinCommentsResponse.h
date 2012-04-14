//
//  RMGetCheckinCommentsResponse.h
//  RMSDK
//
//  Created by Renren on 11-12-12.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RMObject.h"

@interface RMGetCheckinCommentsResponse : RMResponse{
    NSMutableArray *reply_list;         /// 回复列表
    NSInteger count;                    /// 数量
    NSString *pcId;                     /// 回复者id
    NSString *pid;                      /// pid
    long lat;                           /// 纬度
    long lon;                           /// 经度
    long time;                          /// 时间
    NSString *p_address;                /// 地址
    NSString *user_id;                  /// 用户id
    NSString *user_name;                /// 用户名
    NSString *head_url;                 /// 头像URL
    NSString *status;                   /// 状态
    NSString *poi_name;                 /// poi名字
}
@property(nonatomic, readonly) NSMutableArray *reply_list;
@property(nonatomic, readonly) NSInteger count;
@property(nonatomic, readonly) NSString *pcId;
@property(nonatomic, readonly) NSString *pid;
@property(nonatomic, readonly) long lat;
@property(nonatomic, readonly) long lon;
@property(nonatomic, readonly) long time;
@property(nonatomic, readonly) NSString *p_address;
@property(nonatomic, readonly) NSString *user_id;
@property(nonatomic, readonly) NSString *user_name;
@property(nonatomic, readonly) NSString *head_url;
@property(nonatomic, readonly) NSString *status;
@property(nonatomic, readonly) NSString *poi_name;
@end
