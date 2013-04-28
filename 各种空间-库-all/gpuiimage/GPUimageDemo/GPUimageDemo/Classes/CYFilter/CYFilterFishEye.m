//
//  CYFilterFishEye.m
//  CYFilter
//
//  Created by yi chen on 12-7-26.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYFilterFishEye.h"

@implementation CYFilterFishEye

- (id)init{
	
	if (self = [super init]) {
		GPUImageGlassSphereFilter *glassFilter = [[GPUImageGlassSphereFilter alloc]init];
		[glassFilter setRadius:0.65];
		[self addFilterToChain:glassFilter];
		[glassFilter release];
		 
		GPUImageMonochromeFilter *monoFilter = [[GPUImageMonochromeFilter alloc] init];
		[monoFilter setColor:(GPUVector4){1.0f, 1.0f, 0.0f, 1.0f}];
		[monoFilter setIntensity:0.2];
		[self addFilterToChain:monoFilter];
		[monoFilter release];
		
		GPUImageBrightnessFilter *brightnessFilter = [[GPUImageBrightnessFilter alloc]init];
		[brightnessFilter setBrightness: - 0.1];
		[self addFilterToChain:brightnessFilter];
		[brightnessFilter release];
		
		
		GPUImageVignetteFilter *vigFilter = [[GPUImageVignetteFilter alloc] init];
		[vigFilter setVignetteEnd:0.8];
		[self addFilterToChain:vigFilter];
		[vigFilter release];
	}
	return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (NSString *)title
{
    return @"Fish Eye";
}
@end
