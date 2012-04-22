//
//  UIDevice+UIDeviceExt.m
//  RenrenCore
//
//  Created by SunYu  on 11-11-1.
//  Copyright (c) 2011年 www.renren.com. All rights reserved.
//

#import "UIDevice+UIDeviceExt.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>

@implementation UIDevice (IdentifierAddition)

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
+ (NSString *)macAddress{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

+ (BOOL)isDeviceiPad{
    BOOL iPadDevice = NO;
    
    // Is userInterfaceIdiom available?
    if ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)])
    {
        // Is device an iPad?
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
            iPadDevice = YES;
    }
    
    return iPadDevice;
}

+ (NSString *) machineModel{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *machineModel = [NSString stringWithUTF8String:machine];
    free(machine);
    return machineModel;
}

+ (NSString *) machineModelName{
    NSString *machineModel = [UIDevice machineModel];
    
    // iPhone
    if ([machineModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([machineModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([machineModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([machineModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([machineModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([machineModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    // iPod
    if ([machineModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([machineModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([machineModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([machineModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    
    // iPad
    if ([machineModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([machineModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([machineModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([machineModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([machineModel isEqualToString:@"iPad3,1"])      return @"iPad 3";
    
    // Simulator
    if ([machineModel isEqualToString:@"i386"])         return @"Simulator";
    if ([machineModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    return machineModel;
}

+(NSNumber *)freeSpace{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/private/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }

    return [NSNumber numberWithLongLong:freespace];
}

+(NSNumber *)totalSpace{
	struct statfs buf;	
	long long totalspace = -1;
	if(statfs("/private/var", &buf) >= 0){
		totalspace = (long long)buf.f_bsize * buf.f_blocks;
	} 
	return [NSNumber numberWithLongLong:totalspace];
}

// 获取运营商信息
+ (NSString *)carrierName{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    if (carrier == nil) {
        return nil;
    }
    NSString *carrierName = [carrier carrierName];
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    NSLog(@"Carrier Name: %@ mcc: %@ mnc: %@", carrierName, mcc, mnc);
    return carrierName;
}

+ (NSString *)carrierCode{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    if (carrier == nil) {
        return nil;
    }
    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];
    NSString *carrierCode = [NSString stringWithFormat:@"%@%@", mcc, mnc];
    return carrierCode;
}

@end
