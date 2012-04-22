//
//  NSObject+RNAdditions.m
//  RRSpring
//
//  Created by sheng siglea on 4/1/12.
//  Copyright (c) 2012 RenRen.com. All rights reserved.
//

#import "NSObject+RNAdditions.h"

@implementation NSObject (RNAdditions)

+ (BOOL)isEmptyContainer:(NSObject *)o{
	if (o==nil) {
		return YES;
	}
	if (o==NULL) {
		return YES;
	}
	if (o==[NSNull new]) {
		return YES;
	}
    if ([o isKindOfClass:[NSDictionary class]]) {
		return [((NSDictionary *)o) count]<=0;			
	}
	if ([o isKindOfClass:[NSArray class]]) {
		return [((NSArray *)o) count]<=0;			
	}
    if ([o isKindOfClass:[NSSet class]]) {
		return [((NSSet *)o) count]<=0;			
	}
	return NO;
}

@end
