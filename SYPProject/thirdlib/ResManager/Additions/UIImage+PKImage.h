//
//  UIImage+PKImage.h
//  SYPFrameWork
//
//  Created by sunyuping on 12-12-27.
//  Copyright (c) 2012年 sunyuping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PKImage)

/*!
 *   @method
 *   @abstract get image by key
 *   @param needCache , will cached
 *   @param name, will not cached
 */
+ (UIImage *)imageForKey:(id)key style:(NSString *)name;
+ (UIImage *)imageForKey:(id)key cache:(BOOL)needCache;
+ (UIImage *)imageForKey:(id)key; // default cached

@end
