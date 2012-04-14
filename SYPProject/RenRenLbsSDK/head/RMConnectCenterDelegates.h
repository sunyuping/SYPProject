//
//  RMConnectCenterDelegates.h
//  RMSDK
//
//  Created by 王 永胜 on 11-12-27.
//  Copyright (c) 2011年 人人网. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RMError;
@protocol RenrenPrivateLoginDelegate 
@required
/**
 *zh
 * 使用私有登录接口的回调
 * @param bSucc:YES登录成功;NO登录失败 
 * @param err:当登录失败时，服务器返回的错误
 *
 *en
 * Call-back method for private login.
 * @param bSucc:YES: login success; NO: login fail
 * @param err:Service error object when login fails.
 */
- (void)privateLoginCallback:(BOOL)bSucc withErr:(RMError *)err;
@end

@protocol RenrenLoginViewControllerDelegate <NSObject>
/**
 *zh
 * 人人登录界面回调
 * 当登录取消时，关闭登录人人界面，delegate受到此回调
 *
 *en
 * Call-back method for Renren login view controller.
 * Will be called when Renren login view controller be closed while user cancels login. 
 */
- (void)didCloseToLoginCancel;
/**
 *zh
 * 人人登录界面回调
 * 当登录成功时，关闭登录人人界面，delegate受到此回调
 *
 *en
 * Call-back method for Renren login view controller.
 * Will be called when Renren login view controller be closed for the reason of login success. 
 */
- (void)didCloseToLoginSuccess;

@end

@protocol RenrenMobileDelegate <NSObject>
@optional
/**
 *zh
 * 第三方开发者可选实现该方法
 * 通知第三方开发者人人网功能界面将要出现。
 *
 *en
 * optional realization method for third-party developers
 * Notify the third party developers renren function interface will appear.
 */
- (void)dashboardWillAppear;

/**
 *zh
 * 第三方开发者可选实现该方法
 **通知第三方开发者人人网功能界面已经出现
 *
 *en
 * optional realization method for third-party developers
 * Notify the third party developers renren function interface did appear.
 */
- (void)dashboardDidAppear;

/**
 *zh
 * 第三方开发者可选实现该方法
 * 通知第三方开发者人人网功能界面将要消失
 *
 *en
 * optional realization method for third-party developers
 * Notify the third party developers renren function interface will appear.
 */
- (void)dashboardWillDisappear;

/**
 *zh
 * 第三方开发者可选实现该方法
 * 通知第三方开发者人人网功能界面已经消失
 *
 *en
 * optional realization method for third-party developers
 * Notify the third party developers renren function interface did appear.
 */
- (void)dashboardDidDisappear;

/**
 *zh
 * 第三方开发者可选实现该方法
 * 通知第三方开发者用户登录人人网验证状态
 * @param flag:YES登录成功;NO登录失败 
 *
 *en
 * required realization method for third-party developers
 * Notify the third party developers the validation status of user login renren.
 * @param flag: YES login success; NO login failed
 */
//- (void)renrenLoginWithAuthStauts:(BOOL)flag;

@required
/**
 *zh
 * 第三方开发者必须实现该方法
 * RenrenMobile每次启动都会检查当前用户身份是否仍有效，
 * 当验证失败时，RenrenMobile会清除用户登录会话信息，并调用此代理方法通知第三方开发者验证失败。
 * 
 *en
 * required realization method for third-party developers
 * check whether the current user is still valid every time the RenrenMobile start.
 * RenrenMobile clear the user login session information when validation fails and call this proxy method to notify the third-party developers validation fails.
 */
- (void)reAuthVerifyUserFailWithError:(RMError *)error;

@end

