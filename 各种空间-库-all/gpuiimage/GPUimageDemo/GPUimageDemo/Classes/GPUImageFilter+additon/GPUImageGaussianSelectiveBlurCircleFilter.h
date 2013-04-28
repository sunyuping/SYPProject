//
// Created by chenyi on 12-11-8.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
@class GPUImageGaussianBlurFilter;
/*
    为了适应高斯模糊的区域是一个完美的圆形，不受图片分辨率的影响
 */
@interface GPUImageGaussianSelectiveBlurCircleFilter : GPUImageFilterGroup
/** A Gaussian blur that preserves focus within a circular region
 */
{
    GPUImageGaussianBlurFilter *blurFilter;
    GPUImageFilter *selectiveFocusFilter;
    BOOL hasOverriddenAspectRatio;
}

/** The radius of the circular area being excluded from the blur
 */
@property (readwrite, nonatomic) CGFloat excludeCircleRadius;
/** The center of the circular area being excluded from the blur
 */
@property (readwrite, nonatomic) CGPoint excludeCirclePoint;
/** The size of the area between the blurred portion and the clear circle
 */
@property (readwrite, nonatomic) CGFloat excludeBlurSize;
/** A multiplier for the size of the blur, ranging from 0.0 on up, with a default of 1.0
 */
@property (readwrite, nonatomic) CGFloat blurSize;
/** The aspect ratio of the image, used to adjust the circularity of the in-focus region. By default, this matches the image aspect ratio, but you can override this value.
 */
@property (readwrite, nonatomic) CGFloat aspectRatio;

/* 如果是editing那么在模糊区域会变灰 盖一层蒙板
 */
@property (readwrite, nonatomic) BOOL isEditing;

@end