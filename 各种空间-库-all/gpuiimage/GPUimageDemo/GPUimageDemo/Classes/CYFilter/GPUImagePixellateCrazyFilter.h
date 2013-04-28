//
//  GPUImagePixellateCrazyFilter.h
//  CYFilter
//
//  Created by yi chen on 12-7-27.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "GPUImageFilter.h"

//	水波像素化
@interface GPUImagePixellateCrazyFilter : GPUImageFilter

{
    GLint fractionalWidthOfAPixelUniform, scaleUniform;
}

// The fractional width of the image to use as a size for the pixels in the resulting image. Values below one pixel width in the source image are ignored.
@property(readwrite, nonatomic) CGFloat fractionalWidthOfAPixel;
@property(readwrite, nonatomic) CGFloat scale;

@end