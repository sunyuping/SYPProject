//
//  CYSkinWhiteFilter.h
//  CYFilter
//
//  Created by chen yi on 12-10-19.
//  Copyright (c) 2012年 renren. All rights reserved.
//


#import "CYImageFilter.h"
#import "GPUImage.h"

/*	皮肤美白+磨皮滤镜
 */
@interface CYSkinWhiteFilter : GPUImageFilterGroup
{
    GPUImagePicture *lookupImageSource;
}

@end
