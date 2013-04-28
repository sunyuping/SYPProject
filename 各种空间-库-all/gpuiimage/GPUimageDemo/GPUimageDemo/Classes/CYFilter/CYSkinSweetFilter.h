//
//  CYSkinSweetFilter.h
//  CYFilter
//
//  Created by chen yi on 12-10-21.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "GPUImageFilterGroup.h"

/*	甜美可人
 */
@interface CYSkinSweetFilter : GPUImageFilterGroup
{
    GPUImagePicture *_lookupImageSource;
}
@property(nonatomic,retain)GPUImagePicture *lookupImageSource;


@end
