//
//  RMConnectCenter.h
//  RMSDK
//
//  Created by Renren-inc on 11-9-28.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RMConnectCenterDelegates.h"
#import "RMRequestContextDelegate.h"

@protocol RMRequestContextDelegate;
@class RMUser;

@interface RMConnectCenter : NSObject <RMRequestContextDelegate> {
    id<RenrenMobileDelegate> _connecCenterDelegate;
    id<RenrenPrivateLoginDelegate> _privateLoginDelegate;
    NSString * _privateloginAccount;
    NSString * _privateloginPasswd;
}
/// 确认并实现了@protocol RenrenMobileDelegate的任意对象。  confirm and realize any objects of @protocol RenrenMobileDelegate.
@property(nonatomic ,assign)id<RenrenMobileDelegate> connectCenterDelegate;

/**
 *zh
 * 此方法是人人连接中心的初始化方法，请先调用此方法并保证传入正确参数。
 *@param apiKey    分配给应用的apiKey
 *@param secretKey 分配给应用的secretKey
 *@param appId     分配给应用的appId
 *@param delegate  确认并实现RenrenMobileDelegate的delegate
 *
 *en
 * this method is the initialize method of RMConnectCenter, please make sure you call this method first and pass the correct parameter
 *@param apiKey    api assigned to the application
 *@param secretKey secretKey assigned to the application
 *@param appId     appId assigned to the application
 *@param delegate  confirm and realize the delegate of RenrenMobileDelegate
 */
+ (void)initializeConnectWithAPIKey:(NSString *)apiKey 
                          secretKey:(NSString *)secretKey
                              appId:(NSString *)appId
                     mobileDelegate:(id<RenrenMobileDelegate>)delegate;
/**
 *zh
 * 销毁人人网所生成的全部实例，调用此方法后其他任何接口皆无法使用，要重新启用必须再调用人人连接中心的初始化方法
 * initializeConnectWithAPIKey: secretKey: appId:mobileDelegate:
 *
 *en
 * destroy all the instances created by renren, all the other interfaces would be invalid after this method is called, they would won't be valid unless you call the nitialize method of RMConnectCenter.
 */
+ (void)disconnectRenrenMobile;

/**
 *zh
 * 获取RMConnectCenter的实例。
 *
 *en
 * get the instance of RMConnectCenter
 */                               
+ (RMConnectCenter *)sharedCenter;

/**
 *zh
 * 判断当前是否有用户登录人人网。
 * @return YES，已有用户登录人人网；NO，没用用户登录人人网
 *
 *en
 * Verify if there are any users login renren.
 * @return YES, user has login renren; NO, nobody login renren.
 */ 
+ (BOOL)isCurrentUserLogined;

/**
 *zh
 * 从人人网登出当前用户。
 *
 *en
 * logout the current user from renren.
 */ 
+ (void)logoutCurrentUser;

/**
 *zh
 * 获取当前登录用户的实例，可查看用户的基本信息。
 * 使用RMUserGetInfoContext，传入的UserId为当前用户时，RMConnectCenter会自动补全当前用户信息。
 *
 *en
 * get the instance of current user and you can view the user's basic information.
 * When the incoming UserId is current user, the RMConnectCenter will automatically complete the current user's information if you use RMUserGetInfoContext
 */ 
+ (RMUser*)currentUser;

/**
 *zh
 * 私有登录，仅供深度合作的开发方使用，允许开发方自定界面采集人人用户名和密码。
 *
 *en
 * private login, Allows developers to customize the interface collection renren user name and password only for Depth cooperation of developers
 */
+ (void)privateLogin:(NSString *)account withPasswd:(NSString *)passwd delegate:(id<RenrenPrivateLoginDelegate>) delegate;

/**
 *zh
 * 完成社交组件与主客户端SSO登录的主要方法，第三方开发者必须在UIApplicationDelegate中调用此方法：
 *
 *en
 * to complete the RMTinyClient and the main client SSO login method, the third-party developers must call this method in the UIApplicationDelegate:
 * - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
 *   return [[RMConnectCenter sharedCenter] handleOpenURL:url];
 * }
 *
 * - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
 *   return [[RMConnectCenter sharedCenter] handleOpenURL:url];
 * }
 */ 
- (BOOL)handleOpenURL:(NSURL *)url;


@end





