//
//  RMUser.h
//  RMSDK
//
//  Created by Renren-inc on 11-10-26.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMObject.h"

typedef enum{
    RMGenderTyprUnknow = -1,        /// 性别未知        gender unknown
    RMGenderTypeWomen = 0,          /// 性别女          female
    RMGenderTypeMen = 1             /// 性别男          male
}RMGenderType;

@class RMUserBirthday;
@class RMFeedStatus;
@interface RMUser : RMItem{
    NSString *userId;       /// 用户id                user id
    NSString *username;     /// 用户姓名               user name        
    NSString *headerUrl;    /// 100宽度 用户头像        user avatar, width 100
    NSString *tinyUrl;      /// 50宽度 用户头像         user avatar, width 50
    NSString *network;      /// 用户所属网络            the network users belongs to 
    BOOL isStar;            /// 是否是星级用户           whether is a star user
    BOOL hasVisitRight;     /// 是否有访问权限（0:有，1：没有）                   whether has the permissions to access (0: yes, he does.   1:no, he doesn't. )
    BOOL isFriendWithCurrentUser;   /// 与登录用户是否是好友(1:是，2：不是)       whether is on the friends list of the logged-on user (1: yes, he does. 2:no, he doesn't.)
    NSInteger vistorCount;          /// 访问人数                   total number of visitors
    NSInteger blogCount;            /// 日志数                     total number of blogs
    NSInteger albumCount;           /// 照片数                     total number of photos
    NSInteger friendCount;          /// 好友数                     total number of friends
    NSInteger gossipCount;          /// 留言数                     total number of messages
    NSInteger shareFriendsCount;    /// 与登录用户的共同好友数         total number of the same friends with the logged-on user
    NSInteger vipLevel;             /// vip等级(1-6)               vip level(1-6)
    NSInteger vipStat;              /// 用户当前vip的状态（按位表示状态（1是0不是），0：不是vip； vip_stat&1: 是否是vip； vip_stat&2：曾经是否是vip； vip_stat&4：是否是迪士尼vip）              The user's current VIP status(bitwise status(1 for yes, 0 for no), 0: not a vip; vip_stat&1: whether is a vip or not; vip_stat&2: whether was a vip or not; vip_stat&4: whether is the Disney nip or not).             
    NSString *hometownProvince;     /// 家乡 省          hometown province
    NSString *hometownCity;         /// 家乡 城市        hometown city
    RMGenderType gender;            /// 性别            gender
    RMUserBirthday *birthday;       /// 用户生日         birthday of user
    RMFeedStatus *status;           /// 用户最新状态     latets status of user
}
@property(nonatomic, copy)NSString *userId;
@property(nonatomic, copy)NSString *username;
@property(nonatomic, copy)NSString *headerUrl;

@property(nonatomic, readonly)NSString *tinyUrl;
@property(nonatomic, readonly)NSString *network;
@property(nonatomic, readonly)BOOL isStar;
@property(nonatomic, readonly)BOOL hasVisitRight;
@property(nonatomic, readonly)BOOL isFriendWithCurrentUser;
@property(nonatomic, readonly)NSInteger vistorCount;
@property(nonatomic, readonly)NSInteger blogCount;
@property(nonatomic, readonly)NSInteger albumCount;
@property(nonatomic, readonly)NSInteger friendCount;
@property(nonatomic, readonly)NSInteger gossipCount;
@property(nonatomic, readonly)NSInteger shareFrinendsCount;
@property(nonatomic, readonly)NSInteger vipLevel;
@property(nonatomic, readonly)NSInteger vipStat;
@property(nonatomic, readonly)NSString *hometownProvince;
@property(nonatomic, readonly)NSString *hometownCity;
@property(nonatomic, readonly)RMGenderType gender;
@property(nonatomic, readonly)RMUserBirthday *birthday;
@property(nonatomic, readonly)RMFeedStatus *status;

@end

@interface RMUserBirthday : RMItem {
    NSInteger day;      /// 生日天     day of birthday
    NSInteger month;    /// 生日月     month of birthday
    NSInteger year;     /// 生日年     year of birthday
}
@property(nonatomic,readonly)NSInteger day;
@property(nonatomic,readonly)NSInteger month;
@property(nonatomic,readonly)NSInteger year;
@end



