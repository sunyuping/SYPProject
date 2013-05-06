//
//  NSErrorAddition.m
//  XYCore
//
//  Created by sunyuping on 13-2-26.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "NSErrorAddition.h"

@implementation NSError(NSErrorAddition)

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message
{
    return [NSError errorWithDomain:domain
                               code:code
                           userInfo:[NSDictionary dictionaryWithObject:message
                                                                forKey:NSLocalizedDescriptionKey]];
}

@end