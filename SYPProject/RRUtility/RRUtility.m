//
//  RRUtility.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RRUtility.h"
#include <sys/sysctl.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>
#import <dlfcn.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <net/if_dl.h>
//#import "OpenUDID.h"
#import "RRSingleton.h"
RR_DECLARE_SINGLETON(RRUtility)
@interface RRUtility(AddPrivateMethod)
+ (NSUInteger) getSysInfo: (uint) typeSpecifier;
@end

@implementation RRUtility

RR_IMPLETEMENT_SINGLETON(RRUtility,defaultUtility)

+ (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

+ (NSInteger) getScreenWidth{
    CGRect rect = [[UIScreen mainScreen] bounds];
    return rect.size.width;
}
+ (NSInteger) getScreenHeight{
    CGRect rect = [[UIScreen mainScreen] bounds];
    return rect.size.height;
}

+ (NSInteger) getApplicationWidth{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    return rect.size.width;
}
+ (NSInteger) getApplicationHeight{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    return rect.size.height;
}

+ (NSUInteger) getCPUFrequency{
    return [self getSysInfo:HW_CPU_FREQ];
}
+ (NSUInteger) getBUSFrequency{
    return [self getSysInfo:HW_BUS_FREQ]; 
}
+ (NSUInteger) getTotalMemory{
    return [self getSysInfo:HW_PHYSMEM];
}
+ (NSUInteger) getUserMemory{
    return [self getSysInfo:HW_USERMEM];
}
+ (NSUInteger) getMaxSocketBufferSize{
    return [self getSysInfo:KIPC_MAXSOCKBUF];
}



+(NSString *) getlocalWiFiIPAddress{
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	success = getifaddrs(&addrs) == 0;
	if (success) {
		cursor = addrs;
		while (cursor != NULL) {
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) {
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if([name isEqualToString:@"en0"]){
					return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
				}
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return nil;
}
+(NSString *)hostname{
	char baseHostName[256];
	int success = gethostname(baseHostName,255);
	if (success != 0 ) {
		return nil;
	}
	baseHostName[255] = '\0';
#if !TARGET_IPHONE_SIMULATOR
	return [NSString stringWithFormat:@"%s.local",baseHostName];
#else
	return [NSString stringWithFormat:@"%s",baseHostName];
#endif
}
+(NSString *)getIPAddressForHost:(NSString *)theHost{
	struct hostent *host = gethostbyname([theHost UTF8String]);
	if (!host) {
      //  CJLOGE("gethostbyname return NULL");
		return NULL;
	}
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
	
}

+(NSString *)localIPAddress{
	struct hostent *host = gethostbyname([[self hostname] UTF8String]);
	if (!host) {
		//CJLOGE("gethostbyname return NULL");
		return nil;
	}
	
	struct in_addr **list = (struct in_addr **)host->h_addr_list;
	return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
}

+ (NSString*) getUniqueIdentifer{
   // return [OpenUDID value];
    return [[UIDevice currentDevice] uniqueIdentifier];
}
+ (NSString*) getSystemName{
    return [[UIDevice currentDevice] systemName];
}
+ (NSString*) getSystemVersion{
    return [[UIDevice currentDevice] systemVersion];
}
+ (NSString*) getModel{
    return [[UIDevice currentDevice] model];
}
+ (CGFloat) getDiskFreeSize{    
    NSError * error;
    NSDictionary *fattributes = [[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    CGFloat fileFreeSizeInBytes = [[fattributes objectForKey:NSFileSystemFreeSize] floatValue];
    return fileFreeSizeInBytes;
}
+ (CGFloat) getDiskTotalSize{
    NSError * error;
    NSDictionary *fattributes = [[NSFileManager defaultManager]attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    CGFloat fileSystemSizeInBytes = [[fattributes objectForKey:NSFileSystemSize] floatValue];
    return fileSystemSizeInBytes;
}
+ (CGFloat) getBatteryValue{
    UIDevice* device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    return device.batteryLevel;
}
+ (NSInteger) getBatteryState{
    UIDevice* device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    return device.batteryState;
}
+ (NSString *) getPlatform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}
+(NSString *) getPlatformString{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"i386"]||[platform isEqualToString:@"x86_64"])         
        return @"Simulator";
    return platform;
}

+(void)sendMemoryWarning{
    SEL memoryWarningSel = @selector(_performMemoryWarning);
    if ([[UIApplication sharedApplication] respondsToSelector:memoryWarningSel]) {
        [[UIApplication sharedApplication] performSelector:memoryWarningSel];
    }else {
        NSLog(@"%@",@"Whoops UIApplication no loger responds to -_performMemoryWarning");
    }
}
@end
