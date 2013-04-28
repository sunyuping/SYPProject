//
//  UIImage+IF.h
//  InstaFilters
//
//  Created by Di Wu on 2/29/12.
//  Copyright (c) 2012 twitter:@diwup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IF)

/*	剪切图片的某个区域
 */
- (UIImage * )getSubImage:(CGRect)rect;

/*	旋转图片
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/*	通过某个纯色获取图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

/*	调整图片的大小
 */
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

+ (UIImage*)imageFromView:(UIView *)view;

@end
