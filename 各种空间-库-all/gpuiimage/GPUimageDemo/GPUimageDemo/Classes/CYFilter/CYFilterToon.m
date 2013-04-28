//
//  CYFilterToon.m
//  CYFilter
//
//  Created by yi chen on 12-7-26.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYFilterToon.h"

@implementation CYFilterToon

- (id)init{
	
	if (self = [super init]) {
//		GPUImageSmoothToonFilter *toonFilter = [[GPUImageSmoothToonFilter alloc] init];
//		[toonFilter setBlurSize:0.6];
//		[self addFilterToChain:toonFilter];
//		[toonFilter release];
		
		GPUImageToonFilter *toonFilter = [[GPUImageToonFilter alloc] init];
		[toonFilter setQuantizationLevels:11];
		[toonFilter setThreshold:0.4];
		
		[self addFilterToChain:toonFilter];
		[toonFilter release];

		
//		GPUImageMonochromeFilter *monoFilter = [[GPUImageMonochromeFilter alloc] init];
//		[monoFilter setColor: (GPUVector4){0.8, 0.8, 0.8, 1.f}];
//		[self addFilterToChain:monoFilter];
//		[monoFilter release];
	}
	
	return self;
}

- (NSString *)title{
	
	return @"Toon";
}
@end
