//
//  UIImage+RNAdditions.h
//  RRSpring
//
//  Created by zhang hai on 4/17/12.
//  Copyright (c) 2012 RenRen.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (RNAdditions)
// 缩放图片
+ (UIImage *)scaleImage:(UIImage *)image scaleToSize:(CGSize)size;
//中间拉伸自动宽高
+ (UIImage*)middleStretchableImageWithKey:(NSString*)key ;

@end
