//
//  CYFilterChain.m
//  CYFilter
//
//  Created by yi chen on 12-7-25.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYFilterChain.h"
#import "GPUImage.h"
@interface CYFilterChain() 

@property (nonatomic, readonly, retain) NSMutableArray *filters;

@end

@implementation CYFilterChain

@synthesize filters = _filters;
@synthesize finallyFilter = _finallyFilter;
- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    _filters = [[NSMutableArray alloc] initWithCapacity:10];
    
    return self;
}

- (void)dealloc
{
	[_filters release];
    _filters = nil;
	self.finallyFilter = nil;
	[super dealloc];
}

/*
	滤镜描述
 */
- (NSString *)title
{
    return @"Filter Chain";
}

- (void)addFilterToChain:(id )filter
{
    [_filters addObject:filter];
}

/*
	合成整个链路的滤镜
 */
- (GPUImageOutput<GPUImageInput>  *)finallyFilter{
	
	if ([self.filters count] == 0) {
		return nil;
	}
	if ([self.filters count] == 1) {
		
		GPUImageOutput<GPUImageInput> * filter = [self.filters objectAtIndex:0];
		[filter prepareForImageCapture];
		return filter;
	}
	
	if (!_finallyFilter) {
		_finallyFilter = [[GPUImageFilterGroup alloc]init];
	}
	
	[_finallyFilter removeAllTargets];
	
	//	将整个链路里面的滤镜串起来,转化为最终的GPUImageFilterGroup输出
	GPUImageFilter *filter = [self.filters objectAtIndex:0];
	GPUImageFilter *lastFilter = filter;
	
	[filter prepareForImageCapture];
	[(GPUImageFilterGroup *)_finallyFilter addFilter:filter];
	NSInteger count = [self.filters count];
	for (NSUInteger i = 1; i < count; i++) {
		filter = [self.filters objectAtIndex:i];
		
		[filter prepareForImageCapture];
		[(GPUImageFilterGroup *)_finallyFilter addFilter:filter];
		
		[lastFilter removeAllTargets];
		[lastFilter addTarget:filter];
		lastFilter = filter;
	}
	[(GPUImageFilterGroup *)_finallyFilter setInitialFilters:[NSArray arrayWithObject:[self.filters objectAtIndex:0]]];
	[(GPUImageFilterGroup *)_finallyFilter setTerminalFilter:lastFilter];

	[_finallyFilter prepareForImageCapture];
	return _finallyFilter;
}

@end
