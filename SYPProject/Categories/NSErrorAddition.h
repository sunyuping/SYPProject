//
//  NSErrorAddition.h
//  XYCore
//
//  Created by sunyuping on 13-2-26.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSError(NSErrorAddition)

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)message;

@end
