//
//  UIImage+RNAdditions.m
//  RRSpring
//
//  Created by zhang hai on 4/17/12.
//  Copyright (c) 2012 RenRen.com. All rights reserved.
//

#import "UIImage+RNAdditions.h"

@implementation UIImage (RNAdditions)

+ (UIImage *)scaleImage:(UIImage *)image scaleToSize:(CGSize)size {    
    // 创建一个bitmap的context    
    // 并把它设置成为当前正在使用的context    
    UIGraphicsBeginImageContext(size);    
    
    // 绘制改变大小的图片    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];    
    
    // 从当前context中创建一个改变大小后的图片    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();    
    
    // 使当前的context出堆栈    
    UIGraphicsEndImageContext();    
    
    // 返回新的改变大小后的图片    
    return scaledImage;
}
+ (UIImage*)middleStretchableImageWithKey:(NSString*)key {
    UIImage *image = [[RCResManager getInstance] imageForKey:key];
    return [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}
@end
