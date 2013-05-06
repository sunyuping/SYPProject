//
//  NSObject+RRDefines.h
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef RRDefines_h
#define RRDefines_h

#import <objc/runtime.h>
#import <execinfo.h>
#import <stdio.h>
#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Availability.h>
#import <TargetConditionals.h>
#endif
/*
#undef RR_TARGET_SIMULATOR
#undef RR_TARGET_IOS

#ifdef TARGET_IPHONE_SIMULATOR
#define RR_TARGET_SIMULATOR
#endif


#ifdef TARGET_OS_IPHONE
#define RR_TARGET_IOS
#endif
*/

//默认多语言表
#define RS_CURRENT_LANGUAGE_TABLE  [[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageSwtich"]?[[NSUserDefaults standardUserDefaults] objectForKey:@"LanguageSwtich"]:@"zh-Hans"

//系统当前语言
#define SYSTEM_NOW_LANGUAGE [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0]

//程序语言设置
#define RS_LANGUAGE_TYPE_SET(value)     [[NSUserDefaults standardUserDefaults] setValue:value forKey:@"LanguageSwtich"]

#define RELEASE(__POINTER) { if (nil != (__POINTER)) { CFRelease(__POINTER); __POINTER = nil; } }

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#define RR_ALWAYS_INLINE    __attribute__((always_inline))
#define RR_UNUSED_RESULT    __attribute__((warn_unused_result))
#ifdef __cplusplus
#define RREXTERN		    extern "C" __attribute__((visibility ("default")))
#else
#define RREXTERN	        extern __attribute__((visibility ("default")))
#endif

#define RRRelease(object)   do {if (object) {[object release];}object=nil;}while(0);

#define RRCFRelease(object) do {if (object!=NULL) {RRRelease(object);}object=NULL;}while(0);


#ifndef NULL
#define NULL nil
#endif

#endif
