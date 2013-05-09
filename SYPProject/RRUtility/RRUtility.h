//
//  RRUtility.h
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRUtility : NSObject
+(RRUtility*) defaultUtility;
//屏幕相关
+ (NSInteger)  getScreenWidth;
+ (NSInteger)  getScreenHeight;
+ (NSInteger)  getApplicationWidth;
+ (NSInteger)  getApplicationHeight;

//硬件相关
+ (NSUInteger) getCPUFrequency;
+ (NSUInteger) getBUSFrequency;
+ (NSUInteger) getTotalMemory;
+ (NSUInteger) getUserMemory;
+ (NSUInteger) getMaxSocketBufferSize;

//网络相关
+ (NSString *) getlocalWiFiIPAddress;
+ (NSString *) hostname;
+ (NSString *) getIPAddressForHost:(NSString *)theHost;
+ (NSString *) localIPAddress;

//系统相关
+ (NSString*)  getUniqueIdentifer;
+ (NSString*)  getModel;
+ (NSString*)  getSystemName;
+ (NSString*)  getSystemVersion;
+ (CGFloat)    getDiskFreeSize;
+ (CGFloat)    getDiskTotalSize;
+ (CGFloat)    getBatteryValue;
+ (NSInteger)  getBatteryState;
+ (NSString *) getPlatform;
+ (NSString *) getPlatformString;

//私有api实现内存警告

+(void)sendMemoryWarning;

@end






