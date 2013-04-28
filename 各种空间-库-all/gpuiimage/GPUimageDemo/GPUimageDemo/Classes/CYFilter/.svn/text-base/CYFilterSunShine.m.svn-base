//
//  CYFilterSunShine.m
//  CYFilter
//
//  Created by yi chen on 12-7-26.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYFilterSunShine.h"

@implementation CYFilterSunShine

- (id)init{
	if (self = [super init]) {

		//亮度
//		GPUImageBrightnessFilter * brightFilter = [[GPUImageBrightnessFilter alloc]init];
//		[brightFilter setBrightness:4/255];
//		[self addFilterToChain:brightFilter];
//		[brightFilter release];		
//		
//		//对比度
//		GPUImageContrastFilter *contrastFilter = [[GPUImageContrastFilter alloc]init];
//		[contrastFilter setContrast:79/255 ];
//		[self addFilterToChain:contrastFilter];
//		[contrastFilter release];

		
		/*曲线调整整个风格*/
		
//		//B通道曲线
		
		GPUImageToneCurveFilter *toneCorveFilter = [[GPUImageToneCurveFilter alloc]init];
		[toneCorveFilter setBlueControlPoints:[NSArray arrayWithObjects:
											   [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)],
											   [NSValue valueWithCGPoint:CGPointMake(209/255.0, 223/255.0)],
											    [NSValue valueWithCGPoint:CGPointMake(160/255.0, 181/255.0)], 
											    [NSValue valueWithCGPoint:CGPointMake(120/255.0, 141/255.0)], 
											   [NSValue valueWithCGPoint:CGPointMake(60/255.0, 69/255.0)],
											    [NSValue valueWithCGPoint:CGPointMake(28/255.0, 32/255.0)], 
											   [NSValue valueWithCGPoint:CGPointMake(255/255.0, 255/255.0)],
											   nil]];
		GPUImageToneCurveFilter *toneCorveFilter1 = [[GPUImageToneCurveFilter alloc]init];

		//RGB通道曲线
		[toneCorveFilter1 setRgbCompositeControlPoints:[NSArray arrayWithObjects:
											  [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)],
											   [NSValue valueWithCGPoint:CGPointMake(209/255.0, 232/255.0)], 
											   [NSValue valueWithCGPoint:CGPointMake(165/255.0, 195/255.0)], 
											  [NSValue valueWithCGPoint:CGPointMake(124/255.0, 140/255.0)], 
											  [NSValue valueWithCGPoint:CGPointMake(93/255.0, 93/255.0)],
											   [NSValue valueWithCGPoint:CGPointMake(63/255.0, 53/255.0)], 
											   [NSValue valueWithCGPoint:CGPointMake(31/255.0, 21/255.0)], 
											  [NSValue valueWithCGPoint:CGPointMake(255/255.0, 255/255.0)],
											  nil]];
		
		GPUImageToneCurveFilter *toneCorveFilter2 = [[GPUImageToneCurveFilter alloc]init];

		//R通道曲线
		[toneCorveFilter2 setRedControlPoints:[NSArray arrayWithObjects:
											  [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)],
											  [NSValue valueWithCGPoint:CGPointMake(171/255.0, 184/255.0)], 
											 [NSValue valueWithCGPoint:CGPointMake(118/255.0, 133/255.0)], 
											   [NSValue valueWithCGPoint:CGPointMake(53/255.0, 62/255.0)], 
											  [NSValue valueWithCGPoint:CGPointMake(255/255.0, 255/255.0)],
											  nil]];
		
		[self addFilterToChain:toneCorveFilter];
		[self addFilterToChain:toneCorveFilter1];
		[self addFilterToChain:toneCorveFilter2];
		[toneCorveFilter release];
		[toneCorveFilter1 release];
		[toneCorveFilter2 release];
		
	///////////////////////////测试用////////////////////////////////////
		
//		GPUImageToneCurveFilter *toneCorveFilter = [[GPUImageToneCurveFilter alloc]init];
//		//RGB通道曲线
//		[toneCorveFilter setRGBControlPoints:[NSArray arrayWithObjects:
//											  [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)],
//											  [NSValue valueWithCGPoint:CGPointMake(0.5 * 255, 0.25 * 255)], 
//											  [NSValue valueWithCGPoint:CGPointMake(0.75 * 255, 0.5 * 255)],
//											  [NSValue valueWithCGPoint:CGPointMake(1.0 * 255, 1.0 * 255)],
//											  nil]];
//
//		GPUImageToneCurveFilter *toneCurveFilter1 = [[GPUImageToneCurveFilter alloc]init];
//		
//		//B通道曲线
//		[toneCurveFilter1 setBlueControlPoints:[NSArray arrayWithObjects:
//											  [NSValue valueWithCGPoint:CGPointMake(0.0, 0.0)],
//											  [NSValue valueWithCGPoint:CGPointMake(0.25 * 255, 0.5 * 255)], 
//											  [NSValue valueWithCGPoint:CGPointMake(0.5 * 255,0.75 * 255)], 
//											  [NSValue valueWithCGPoint:CGPointMake(1.0 * 255, 1.0 * 255)],
//											  nil]];
////		
//		
//		[self addFilterToChain:toneCurveFilter1];
//		[toneCurveFilter1 release];
//		
//		[self addFilterToChain:toneCorveFilter];
//		[toneCorveFilter release];

//		//单色
//		GPUImageMonochromeFilter *monochromeFilter = [[ GPUImageMonochromeFilter alloc]init];
//		[monochromeFilter setColorRed:255/255.0f green:174/255.0f blue:0];
//		[monochromeFilter setIntensity:0.04];
//		[self addFilterToChain:monochromeFilter];
//		[monochromeFilter release];
		
//
//		
////		GPUImageOpacityFilter *opacityFilter = [[GPUImageOpacityFilter alloc]init];
////		[opacityFilter setOpacity:0.04];
////		[self addFilterToChain:opacityFilter];
////		[opacityFilter release];
		
	}
	
	return self;
}

- (void)dealloc{
	
	[super dealloc];
}
- (NSString *)title{
	
	return @"SunShine";
}
@end
