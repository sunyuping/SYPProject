//
//  NSObjectAddition.m
//  SYPFrameWork
//
//  Created by sunyuping on 13-1-8.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "NSObjectAddition.h"
#if (TARGET_OS_IPHONE)

#import <objc/runtime.h>
@implementation NSObject(ClassName)
- (NSString *)className
{
	return [NSString stringWithUTF8String:class_getName([self class])];
}
+ (NSString *)className
{
	return [NSString stringWithUTF8String:class_getName(self)];
}

@end
#endif

@implementation NSObject (Description)

- (NSString *)rsDescription {
    NSMutableString *desc = [NSMutableString string];
    NSMutableArray *arrProps = [NSMutableArray array];
    
    Class cls = self.class;
    while (cls != [NSObject class]) {
        unsigned int propsCount;
        objc_property_t *propList = class_copyPropertyList(cls, &propsCount);
        for (int i = 0; i < propsCount; i++) {
            objc_property_t oneProp = propList[i];
            [arrProps addObject:[NSString stringWithUTF8String:property_getName(oneProp)]];
        }
        
        if (propList)
            free(propList);
        
        cls = cls.superclass;
    }
    
    [desc appendFormat:@"<%@ %p", self.className, (void *) self];
    for (NSString *propName in arrProps) {
        [desc appendFormat:@",%@=%@", propName, [self valueForKey:propName]];
    }
    
    [desc appendString:@">"];
    return desc;
}

@end
