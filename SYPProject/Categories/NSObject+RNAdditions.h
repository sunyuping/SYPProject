//
//  NSObject+RNAdditions.h
//  RRSpring
//
//  Created by sheng siglea on 4/1/12.
//  Copyright (c) 2012 RenRen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RNAdditions)

/*
 NSDictionary
 NSArray
 NSSet
 is nil OR zero element
 */
+ (BOOL)isEmptyContainer:(NSObject *)o;

@end
