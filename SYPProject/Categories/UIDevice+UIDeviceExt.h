//
//  UIDevice+UIDeviceExt.h
//  RenrenCore
//
//  Created by SunYu on 11-11-1.
//  Copyright (c) 2011年 www.renren.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKitDefines.h>

@interface UIDevice (IdentifierAddition)

// 获取MAC地址
+ (NSString *)macAddress;
// 设备是否是iPad
+ (BOOL)isDeviceiPad;
// 获取机器型号
+ (NSString *)machineModel;
// 获取机器型号名称
+ (NSString *)machineModelName;
// 设备可用空间
// freespace/1024/1024/1024 = B/KB/MB/14.02GB
+(NSNumber *)freeSpace;
// 设备总空间
+(NSNumber *)totalSpace;
// 获取运营商信息
+ (NSString *)carrierName;
// 获取运营商代码
+ (NSString *)carrierCode;
@end
