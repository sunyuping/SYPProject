//
//  RMError.h
//  RMSDK
//
//  Created by Renren-inc on 11-9-28.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//
#define kRMErrorDomain @"RenrenMobileErrorDomain"

#define kRMUserUnloginErrorCode         -9999
#define kRMMainParameterMissErrorCode   -9998
#define kRMUserUnauthorized             -9997
#define kRMInvalidArguments             -9996

#import <Foundation/Foundation.h>

@interface RMError : NSError {

    NSString* _developerDescription;
    NSString* _userDescription;
}
/**
 *zh
 * 系统说明文案，主要针对开发者.
 *
 *en
 * System Description files, mainly for developers.
 */
@property(nonatomic,copy)NSString* developerDescription;
/**
 *zh
 * 用户说明文案，主要针对人人网用户，不是所有错误都有此文案
 *
 *en
 * User instructions files, mainly for renren users, not all the errors have this file.
 */
@property(nonatomic,copy)NSString* userDescription;
/**
 *zh
 * 返回由oAuth接口返回错误信息构建的错误对象.
 *en
 * return the error object created by the error message which is returned by oAuth interface.
 */
+ (RMError*)errorWithOAuthResult:(NSDictionary*)result;

/**
 *zh
 * 返回由Rest接口错误信息构建的错误对象.
 *
 *en
 * return the error object created by the error message which is returned by Rest interface.
 */
+ (RMError*)errorWithRestInfo:(NSDictionary*)restInfo;


/**
 *zh
 * 返回由NSError构建的错误对象.
 *
 *en
 * return the error object created by NSError.
 */
+ (RMError*)errorWithNSError:(NSError*)error;

/**
 *zh
 * 构造RMError错误。
 *
 * @param code 错误代码
 * @param errorMessage 错误信息
 *
 * 返回错误对象.
 *
 *en
 * create RMError error
 *
 * @param coede           error code
 * @param errorMessage    error message
 *
 * return error object
 */
+ (RMError*)errorWithCode:(NSInteger)code errorMessage:(NSString*)errorMessage;

/**
 * zh
 * 返回错误描述
 *
 *en
 * return the error description
 */
- (NSString *)localizedDescription;
/**
 *zh
 * 返回错误描述
 *
 *en
 * return the error description
 */
- (NSString *)developerDescription;
/**
 *zh
 * 返回错误描述
 *
 *en
 * return the error description
 */
- (NSString *)userDescription;

@end
