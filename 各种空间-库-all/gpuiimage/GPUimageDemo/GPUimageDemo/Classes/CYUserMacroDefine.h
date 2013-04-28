//
//  CYUserMacroDefine.h
//  CYFilter
//
//  Created by yi chen on 12-7-16.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CY_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }

//Debug 信息
// 内存监测
//#define DEBUG_MEMORY_MONITOR 1

/*
 * 通过RGB创建UIColor
 */
//#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]