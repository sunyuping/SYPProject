//
//  CYFilterMatrix4x4.m
//  CYFilter
//
//  Created by yi chen on 12-7-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYFilterMatrix4x4.h"

@implementation CYFilterMatrix4x4


- (id)init{
	if (self = [super init]) {
		GPUImageColorMatrixFilter *matrixFilter = [[GPUImageColorMatrixFilter alloc]init];
		matrixFilter.colorMatrix = (GPUMatrix4x4){
//			{0.3588, 0.7044, 0.1368, 0.0},
//			{0.2990, 0.5870, 0.1140, 0.0},
//			{0.2392, 0.4696, 0.0912 ,0.0},
//			{0,0,0,1.0},
			
			//此处色阶矩阵的生成是个大问题！！！！泛黄效果
			{1.3, 0.0, 0.0, 0.0},
			{0.0, 1.3, 0.0, 0.0},
			{0.0, 0.0, 1.0, 0.0},
			{0.0, 0.0, 0.0, 1.0},
			
			//灰度
//			{0.3086, 0.6094, 0.0820, 0},        //red
//			{0.3086, 0.6094, 0.0820, 0},       //green
//			{0.3086, 0.6094, 0.0820, 0},        //blue
//			{0.0,	 0.0,	0.0, 1.0},
		};
		[self addFilterToChain:matrixFilter];
		[matrixFilter release];
		
	}
	
	return self;
}

- (void)dealloc{
	[super dealloc];
}

- (NSString *)title{
	
	return @"Matrix4x4";
}
@end
