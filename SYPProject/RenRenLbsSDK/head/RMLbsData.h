//
//  RMLbsData.h
//  RMSDK
//
//  Created by Renren-inc on 11-10-26.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMObject.h"

@interface RMLbsData : RMItem{
    NSString *lbsId;    /// lbsId lbsdata的id
    NSString *pid;      /// pid POI id
    NSString *pname;    /// pname POI name
    NSString *latitude; /// latitude 纬度
    NSString *longitude;/// longitude 经度
    NSString *location; /// location 位置
    NSString *comment;  /// comment 描述
}
@property(nonatomic, readonly) NSString *pid;
@property(nonatomic, readonly) NSString *pname;
@property(nonatomic, readonly) NSString *latitude;
@property(nonatomic, readonly) NSString *longitude;
@property(nonatomic, readonly) NSString *location;
@property(nonatomic, readonly) NSString *comment;
@property(nonatomic, readonly) NSString *lbsId;
@end



@interface RMPlaceAdd : RMObject{
    NSString *pid;                  /// pid POI id
    NSString *poiName;              /// pname POI name
    NSString *poiAddress;           /// location 位置
    NSString *mapUrl;               /// comment 描述
    NSInteger visitCount;           /// 访问数量
    NSInteger activityCount;        /// activity数量
    NSString *activityContents;     /// activity内容
    NSInteger nearbyActivityCount;  /// 附近activity数量
    NSString *lat;                  /// 纬度
    NSString *lon;                  /// 经度
    NSString *activityUrl;          /// activity的URL
    NSString *detailAddress;        /// 详细地址
}
@property(nonatomic, readonly) NSString *pid;
@property(nonatomic, readonly) NSString *poiName;
@property(nonatomic, readonly) NSString *poiAddress;
@property(nonatomic, readonly) NSString *mapUrl;
@property(nonatomic, readonly) NSInteger visitCount;
@property(nonatomic, readonly) NSInteger activityCount;
@property(nonatomic, readonly) NSString *activityContents;
@property(nonatomic, readonly) NSInteger nearbyActivityCount;
@property(nonatomic, readonly) NSString *lat;
@property(nonatomic, readonly) NSString *lon;
@property(nonatomic, readonly) NSString *activityUrl;
@property(nonatomic, readonly) NSString *detailAddress;
@end



@interface RMEvaluationComments : RMObject{

    NSString *commentId;        /// 评论id
    NSString *userId;           /// 评论者id
    NSString *userName;         /// 评论者用户名
    NSString *headUrl;          /// 评论者头像URL
    NSString *time;             /// 评论时间
    NSString *content;          /// 评论内容
}
@property(nonatomic, readonly) NSString *commentId;
@property(nonatomic, readonly) NSString *userId;
@property(nonatomic, readonly) NSString *userName;
@property(nonatomic, readonly) NSString *headUrl;
@property(nonatomic, readonly) NSString *time;
@property(nonatomic, readonly) NSString *content;
@end



@interface RMCheckinComments : RMObject{
    
    NSString *replyId;          /// 回复者id
    NSString *userId;           /// 用户id
    NSString *userName;         /// 用户名
    NSString *headUrl;          /// 头像URL
    NSString *time;             /// 时间
    NSString *content;          /// 内容
}
@property(nonatomic, readonly) NSString *replyId;
@property(nonatomic, readonly) NSString *userId;
@property(nonatomic, readonly) NSString *userName;
@property(nonatomic, readonly) NSString *headUrl;
@property(nonatomic, readonly) NSString *time;
@property(nonatomic, readonly) NSString *content;
@end
