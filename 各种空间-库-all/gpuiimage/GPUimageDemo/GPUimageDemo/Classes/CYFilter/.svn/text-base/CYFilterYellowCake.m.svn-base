//
//  CYYellowCake.m
//  CYFilter
//
//  Created by yi chen on 12-7-25.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYFilterYellowCake.h"
#import "GPUImage.h"
@implementation CYFilterYellowCake

- (id)init
{
    self = [super init];
    if (self){
		/// filters
		GPUImageSaturationFilter *saturFilter = [[GPUImageSaturationFilter alloc] init];
		[saturFilter setSaturation:0.8];
		
		GPUImageMonochromeFilter *monoFilter = [[GPUImageMonochromeFilter alloc] init];
		[monoFilter setColor:(GPUVector4){1.0f, 1.0f, 0.0f, 1.0f}];
		[monoFilter setIntensity:0.2];
		
		GPUImageVignetteFilter *vigFilter = [[GPUImageVignetteFilter alloc] init];
		[vigFilter setVignetteEnd:0.6];
		
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

- (void)dealloc
{
    [super dealloc];
}

- (NSString *)title
{
    return @"Yellow Cake";
}

- (NSString *)localizedTitle
{
    return NSLocalizedString(@"Yellow Cake", @"Localized title for default filter chain.");
}

@end
