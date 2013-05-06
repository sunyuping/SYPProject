//
//  NSObjectAddition.h
//  SYPFrameWork
//
//  Created by sunyuping on 13-1-8.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>

#if (TARGET_OS_IPHONE)
/*!
 On the iPhone NSObject does not provide the className method.
 */
@interface NSObject(ClassName)
- (NSString *)className;
+ (NSString *)className;
@end
#endif

@interface NSObject (Description)


- (NSString *)rsDescription;

@end
