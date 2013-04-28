//
// Created by chenyi on 12-10-21.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CYColorfullFilter.h"


@implementation CYColorfullFilter {

}


- (void)dealloc {
    [lookupImageSource release];
    [super dealloc];
}
- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }

    UIImage *image = [UIImage imageNamed:@"lookup_colorfull.JPG"];
    NSAssert(image, @"To use CYColorfullFilter you need to add lookup_colorfull.png from Resources to your application bundle.");

    lookupImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];

    [lookupImageSource addTarget:lookupFilter atTextureLocation:1];
    [lookupFilter release];
    [lookupImageSource processImage];

    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = lookupFilter;

    return self;
}

@end