//
//  RMPublishFeedContext.h
//  RMSDK
//
//  Created by Renren on 11-10-19.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMCommonContextPublic.h"
#import "RMPublishFeedResultResponse.h"
@class RMError;

@interface RMPublishFeedContext : RMCommonContext{

    RMPublishFeedResultResponse *response;   ///返回的结果。              result return.
    NSString *feedTitle;             ///新鲜事的标题。             title of feed.
    NSString *feedContent;           ///新鲜事的内容。             content of feed.
    NSString *feedURL;               ///新鲜事标题的链接地址。       url of feed's title.
    NSString *imageSrc;              ///新鲜事图片地址。            address of feed's image.
    NSString *message;               ///用户输入的话,长度不超过200。  the message which the user enterde cannot over 200 words.   
    NSString *actionName;            ///新鲜事来源部分的名称，没有则用当前app默认的的名称(同action_link一起判断，任何一个为空都用当前app的信息)。 Part of the feed's name where the feed comes from, use current app name as default value(judge together with action_link, use current app information if either is nil).
    NSString *actionLink;            ///新鲜事来源部分的名称，没有则用当前app默认的的链接(同action_name一起)。 Part of the feed's name where the feed comes from, use current app url as default value(together with action_name).

}
@property(copy,nonatomic) NSString *feedTitle; 
@property(copy,nonatomic) NSString *feedContent;
@property(copy,nonatomic) NSString *feedURL;   
@property(copy,nonatomic) NSString *imageSrc;
@property(copy,nonatomic) NSString *message;
@property(copy,nonatomic) NSString *actionName;
@property(copy,nonatomic) NSString *actionLink;
/**
 *zh
 *发布一条新鲜事
 *异步请求
 *@param title 新鲜事标题,长度不超过30。
 *@param content 新鲜事描述内容，长度不超过200,支持超链接
 *@param  url 新鲜事链接（有图片时链接有用)
 *
 *en
 *
 *publish a feed
 *Asynchronous request
 *@param title     feed's title, no more than 30 words.
 *@param content   feed's content, no more than 200 words, hyperlinks supportive
 *@param url       feed's url(only useful when there are images)
 */   
-(void)asynPublishFeedFeed:(NSString *)title content:(NSString *)content url:(NSString *)url; 
/**
 *zh
 *发布一条新鲜事
 *同步请求
 *@param title 新鲜事标题,长度不超过30。
 *@param content 新鲜事描述内容，长度不超过200,支持超链接
 *@param  url 新鲜事链接（有图片时链接有用)
 *@param error 错误信息
 *@return YES 成功 NO 失败
 *
 *en
 *publish a feed
 *Synchronous request
 *@param title     feed's title, no more than 30 words.
 *@param content   feed's content, no more than 200 words, hyperlinks supportive
 *@param url       feed's url(only useful when there are images)
 *@param error     error message
 *@return          YES for success, NO for failed
 */  
-(BOOL)synPublishFeedFeed:(NSString *)title content:(NSString *)content url:(NSString *)url error:(RMError **)error;
-(RMPublishFeedResultResponse *)getContextResponse;
@end
