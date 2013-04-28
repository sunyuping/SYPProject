//
//  CYSkinSweetFilter.m
//  CYFilter
//
//  Created by chen yi on 12-10-21.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYSkinSweetFilter.h"

@implementation CYSkinSweetFilter
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
	
    UIImage *image = [UIImage imageNamed:@"lookup_skinsweet.JPG"];
    NSAssert(image, @"To use CYSkinSweetFilter you need to add lookup_skinsweet.png from Resources to your application bundle.");
    
	GPUImagePicture * picture = [[GPUImagePicture alloc] initWithImage:image];
	self.lookupImageSource =  picture;
	[picture release];
    
	GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];
	
    [self.lookupImageSource addTarget:lookupFilter atTextureLocation:1];
     [lookupFilter release];
    [self.lookupImageSource processImage];
	
    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;
    
    return self;
}

@end
