//
//  CYFilterPerlin.m
//  CYFilter
//
//  Created by yi chen on 12-7-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYFilterPixCrazy.h"
#import "GPUImagePixellateCrazyFilter.h"
@implementation CYFilterPixCrazy
- (id)init{
	if (self = [super init]) {
		
//		GPUImagePerlinNoiseFilter *perlinFilter = [[GPUImagePerlinNoiseFilter alloc]init];
//		[perlinFilter setColorStart:(GPUVector4){0.0, 0.0, 0.0, 1.0}];
//		[perlinFilter setColorFinish:(GPUVector4){1, 1, 1, 1.0}];   
//		[perlinFilter setScale:100];
//		[self addFilterToChain:perlinFilter];
//		[perlinFilter release];
		
		GPUImagePixellateCrazyFilter *crazyFilter = [[GPUImagePixellateCrazyFilter alloc]init];
		
		[crazyFilter setScale: 4.0];
		[crazyFilter setFractionalWidthOfAPixel:0.008];
		[self addFilterToChain:crazyFilter];
		[crazyFilter release];
		
		
	}
	
	return self;
}


- (NSString *)title{
	
	return @"Perlin";
}
@end
