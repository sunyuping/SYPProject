//
//  RMGetFeedContext.h
//  RMSDK
//
//  Created by Renren on 11-10-18.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMCommonContextPublic.h"
#import "RMGetFeedResponse.h"
@class RMError;
///////////////////////////////////////////////////////////////////////////////////////////////////
typedef enum {
   	SHARE_BLOG =102,                ///分享日志
    SHARE_PHOTO=103,                ///分享照片
   	SHARE_ALBUM =104,               ///分享相册
   	SHARE_LINK =107,                ///分享链接
    SHARE_VIDEO=110,                ///分享视频
   	HEAD_UPDATE =501,               ///头像上传
    STATUS_UPDATE=502,              ///状态发布
   	BLOG_PUBLISH =601,              ///发布日至
    PHOTO_PUBLISH_ONE=701,          ///上传照片
    PHOTO_TAG_PUBLISH=702,          ///照片标题
    PHOTO_PUBLISH_MORE =709,        ///发布更多照片
    GIFT_GIVE =801,                 ///赠送礼物
    LBS_SIGNIN=1101,                ///标记位置
    LBS_EVALUATION=1104,            ///位置范围
    PAGE_JOIN =2002,                ///加入公共主页
    SHARE_PAGE_BLOG=2003,           ///分享公共主页日志
    SHARE_PAGE_PHOTO =2004,         ///分享公共主页照片
    PAGE_SHARE_LINK=2005,           ///分享公共主页链接
    PAGE_SHARE_VIDEO=2006,          ///分享公共主页视频
    PAGE_STATUS_UPDATE=2008,        ///公共主页发布状态
    SHARE_PAGE_ALBUM =2009,         ///分享公共相册
    PAGE_BLOG_PUBLISH=2012,         ///公共主页发布日志
    PAGE_PHOTO_PUBLISH=2013,        ///公共主页发布照片
    PAGE_HEADPHOTO_UPDATE=2015,     ///公共主页头像上传
    EDM_TEXT=8001,                  ///EDM为广告推广置顶新鲜事，只下发链接和图片，无额外信息。
    EDM_PHOTO=8002,                 ///EDM为广告推广置顶新鲜事，只下发链接和图片，无额外信息。
    EDM_VIDEO=8003,                 ///EDM为广告推广置顶新鲜事，只下发链接和图片，无额外信息。
    EDM_FLASH=8004,                 ///EDM为广告推广置顶新鲜事，只下发链接和图片，无额外信息。
} RMGetFeedListType;
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface RMGetFeedContext : RMCommonContext{
    NSInteger page;                 ///支持分页，指定页号，页号从1开始。缺省返回第一页数据。
    NSInteger pageSize;             ///支持分页，每一页记录数，默认值为30，最大50
    NSString *userId;               ///当指定uid时表示取uid用户的个人主页新鲜事,不传时取当前登录用户的首页新鲜事
    RMGetFeedResponse *response;   ///< 返回的结果  
}
@property(assign,nonatomic) NSInteger page;
@property(assign,nonatomic) NSInteger pageSize;
@property(copy,nonatomic) NSString *userId;
/**
 *获取当前用户的新鲜事内容，支持下发网站的日志、相册、状态、分享、公共主页等新鲜事，在调用之前，应用必须获取到用户的授权 
 *异步请求
 *@param type 新鲜事的类别RMGetFeedListType，多个类型以逗号分隔。
 */   
-(void)asynGetFeedList:(NSString *)type; 
/**
 *获取当前用户的新鲜事内容，支持下发网站的日志、相册、状态、分享、公共主页等新鲜事，在调用之前，应用必须获取到用户的授权 
 *同步请求
 *@param type 新鲜事的类别RMGetFeedListType，多个类型以逗号分隔。
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */   
-(BOOL)synGetFeedList:(NSString *)type error:(RMError **)error;
-(RMGetFeedResponse *)getContextResponse;
@end
