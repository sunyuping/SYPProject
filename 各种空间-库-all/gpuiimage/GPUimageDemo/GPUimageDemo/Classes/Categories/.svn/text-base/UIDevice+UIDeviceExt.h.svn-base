//
//  UIDevice+UIDeviceExt.h
//  RenrenCore
//
//  Created by SunYu on 11-11-1.
//  Copyright (c) 2011年 www.renren.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>
#import <CoreGraphics/CoreGraphics.h>
#import	<UIKit/UIDevice.h>

@interface UIDevice (IdentifierAddition)

// 获取MAC地址
+ (NSString *)macAddress;
// 设备是否是iPad
+ (BOOL)isDeviceiPad;
// 获取机器型号
+ (NSString *)machineModel;
// 获取机器型号名称
+ (NSString *)machineModelName;
// 对低端机型的判断
+ (BOOL)isLowLevelMachine;
// 设备可用空间
// freespace/1024/1024/1024 = B/KB/MB/14.02GB
+(NSNumber *)freeSpace;
// 设备总空间
+(NSNumber *)totalSpace;
// 获取运营商信息
+ (NSString *)carrierName;
// 获取运营商代码
+ (NSString *)carrierCode;
//获取电池电量
+ (CGFloat) getBatteryValue;
//获取电池状态
+ (NSInteger) getBatteryState;
// 是否能发短信 不准确
+ (BOOL) canDeviceSendMessage;


// 内存信息
+ (unsigned int)freeMemory;
+ (unsigned int)usedMemory;

@end
