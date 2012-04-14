//
//  RMGetFeed.h
//  RMSDK
//
//  Created by Renren on 11-10-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMObject.h"
#import "RMFeed.h"
@interface RMGetFeed : RMItem{
    NSString *feedID;                   /// 表示新鲜事的id
    NSString *sourceId;                 /// 表示新鲜事内容主体的id，例如日志id、相册id和分享id等等
     NSString *time;                    /// 表示新鲜事更新时间
     NSString *strTime;                 /// 可选的格式化时间
     NSString *userId;                  /// 表示新鲜事用户的id
     NSString *userName;                /// 表示新鲜事用户的姓名
     NSInteger feedType;                /// 表示新鲜事类型
     NSString *headUrl;                 /// 表示新鲜事用户的头像
    NSString *perfix;                   /// 表示新鲜事内容的前缀
    NSString *content;                  /// 表示新鲜事用户自定义输入内容，状态
    NSString *title;                    /// 表示新鲜事的主题内容
    NSString *url;                      /// 表示新鲜事主题的相关链接
    NSInteger originType;               /// 表示新鲜事来源type
    NSString *originTitle;              /// 表示新鲜事来源描述
    NSString *originImg;                /// 表示新鲜事来源图标地址
    NSInteger originPageId;             /// 表示新鲜事来源pageid
    NSString *originUrl;                /// 表示新鲜事来源指定url
    NSString *desc;                     /// 表示新鲜事的具体内容 如日志内容
    NSMutableArray *attachmentList;     /// 表示新鲜事中包含的媒体内容，例如照片、视频等
    NSInteger commentCount;             /// 表示评论的数量
    NSMutableArray *commentList;        /// 表示新鲜事中包含的评论内容，目前返回最新和最早的评论
    NSMutableArray *likes;              /// 表示赞相关的信息
    RMFeedPlace *place;              /// 表示新鲜事发生的
    RMFeedShare *share;              /// 分享内容数据
    RMFeedStatus *statusForward;      /// 转发状态源内容
    NSInteger hasMore;                  /// 是否还有更多新鲜事（1：还有更多）
    NSInteger pageChecked;              /// page是否通过验证（1：通过验证）
    NSString *pageImageUrl;             /// page头像（type=2002时下发）
}
@property(nonatomic, readonly) NSString *feedID; 
@property(nonatomic, readonly) NSString *sourceId;
@property(nonatomic, readonly) NSString *time;
@property(nonatomic, readonly) NSString *strTime;
@property(nonatomic, readonly) NSString *userId;
@property(nonatomic, readonly) NSString *userName;
@property(nonatomic, readonly) NSInteger feedType;
@property(nonatomic, readonly) NSString *headUrl;
@property(nonatomic, readonly) NSString *perfix;
@property(nonatomic, readonly) NSString *content;
@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) NSString *url;
@property(nonatomic, readonly) NSInteger originType;
@property(nonatomic, readonly) NSString *originTitle;
@property(nonatomic, readonly) NSString *originImg;
@property(nonatomic, readonly) NSInteger originPageId;
@property(nonatomic, readonly) NSString *originUrl;
@property(nonatomic, readonly) NSMutableArray *attachmentList;
@property(nonatomic, readonly) NSString *desc;
@property(nonatomic, readonly) NSInteger commentCount;
@property(nonatomic, readonly) NSMutableArray *commentList;
@property(nonatomic, readonly) NSMutableArray *likes;
@property(nonatomic, readonly) RMFeedPlace *place;
@property(nonatomic, readonly) RMFeedShare *share;
@property(nonatomic, readonly) RMFeedStatus *statusForward;
@property(nonatomic, readonly) NSInteger hasMore;
@property(nonatomic, readonly) NSInteger pageChecked;
@property(nonatomic, readonly) NSString *pageImageUrl;
@end



