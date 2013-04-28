//
//  CYOldPictureFilter.m
//  CYFilter
//
//  Created by chen yi on 12-11-12.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYOldPictureFilter.h"

@implementation CYOldPictureFilter
@synthesize lookupImageSource = _lookupImageSource;

- (void)dealloc {
    [_lookupImageSource release];
    [super dealloc];
}

- (id)init;
{
    if (!(self = [super init]))
    {
		return nil;
    }
	
    UIImage *image = [UIImage imageNamed:@"lookup_oldpicture.png"];
    NSAssert(image, @"To use CYOldPictureFilter you need to add lookup_oldpicture.png from /Resources to your application bundle.");
	
    GPUImagePicture * picture = [[GPUImagePicture alloc] initWithImage:image];
	self.lookupImageSource =  picture;
	[picture release];
	
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
	
    [self.lookupImageSource addTarget:lookupFilter atTextureLocation:1];
	
    [self.lookupImageSource processImage];
	
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
	[lookupFilter release]; //内存泄漏
	
    return self;
}

@end
