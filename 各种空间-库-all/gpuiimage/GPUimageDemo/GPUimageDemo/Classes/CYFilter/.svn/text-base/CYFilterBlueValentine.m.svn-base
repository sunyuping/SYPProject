//
//  CYFilterBlueValentine.m
//  CYFilter
//
//  Created by yi chen on 12-7-26.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYFilterBlueValentine.h"

@implementation CYFilterBlueValentine

- (id)init{
	
	if (self = [super init]) {
		//饱和度
		GPUImageSaturationFilter *saturFilter = [[GPUImageSaturationFilter alloc] init];
		[saturFilter setSaturation:0.5];
		
		//单色
		GPUImageMonochromeFilter *monoFilter = [[GPUImageMonochromeFilter alloc] init];
		[monoFilter setColor:(GPUVector4){0.0f, 0.0f, 1.0f, 1.0f}];
		[monoFilter setIntensity:0.015];
		
		//光晕
		GPUImageVignetteFilter *vigFilter = [[GPUImageVignetteFilter alloc] init];
		[vigFilter setVignetteEnd:1.0];
		
		//曝光度
		GPUImageExposureFilter *expoFilter = [[GPUImageExposureFilter alloc] init];
		[expoFilter setExposure:0.3];

		
		[self addFilterToChain:saturFilter];
		[self addFilterToChain:monoFilter];
		[self addFilterToChain:vigFilter];
		[self addFilterToChain:expoFilter];
		
		[saturFilter release];
		[monoFilter release];
		[vigFilter release];
		[expoFilter release];
		
	}
	
	return self;
}

- (NSString *)title{
	
	return @"BlueValentine";
}
@end
