//
//  UIImage+PKImage.m
//  SYPFrameWork
//
//  Created by sunyuping on 12-12-27.
//  Copyright (c) 2012年 sunyuping. All rights reserved.
//

#import "UIImage+PKImage.h"
#import "PKResManager.h"

@implementation UIImage (PKImage)

+ (UIImage *)imageForKey:(id)key
{
    return [UIImage imageForKey:key cache:YES];
}

+ (UIImage *)imageForKey:(id)key cache:(BOOL)needCache
{
    if (key == nil) {
        NSLog(@" imageForKey:cache: key = nil");
        return nil;
    }
    
    if ([key hasSuffix:@".png"] || [key hasSuffix:@".jpg"]) {
        key = [key substringToIndex:((NSString*)key).length-4];
    }
    
    UIImage *image = [[PKResManager getInstance].resImageCache objectForKey:key];
    if (image == nil)
    {
        image = [UIImage imageForKey:key style:[PKResManager getInstance].styleName];
    }
    // cache
    if (image != nil && needCache)
    {
        [[PKResManager getInstance].resImageCache setObject:image forKey:key];
    }
    
    return image;
}

+ (UIImage *)imageForKey:(id)key style:(NSString *)name
{
    if (key == nil) {
        NSLog(@" imageForKey:style: key = nil");
        return nil;
    }
    UIImage *image = nil;
    NSString *imagePath = nil;
    
    if (![name isEqualToString:[PKResManager getInstance].styleName])
    {
        NSBundle *tempBundle = [[PKResManager getInstance] bundleByStyleName:name];
        NSAssert(tempBundle != nil,@" tempBundle = nil");
        
        if ([key hasSuffix:@".png"] || [key hasSuffix:@".jpg"])
        {
            key = [key substringToIndex:((NSString*)key).length-4];
        }
        imagePath = [tempBundle pathForResource:key ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:imagePath];
        
        if (image == nil)
        {
            imagePath = [[PKResManager getInstance].styleBundle pathForResource:key ofType:@"jpg"];
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    else
    {
        imagePath = [[PKResManager getInstance].styleBundle pathForResource:key ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    if (image == nil)
    {
        imagePath = [[PKResManager getInstance].styleBundle pathForResource:key ofType:@"jpg"];
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    if (image == nil)
    {
//        NSLog(@" will get default style => %@",key);
        imagePath = [[NSBundle mainBundle] pathForResource:key ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:imagePath];
        
        if (image == nil)
        {
            imagePath = [[NSBundle mainBundle] pathForResource:key ofType:@"jpg"];;
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
//        NSLog(@"get default style error=> %@",key);
//        NSAssert(image!=nil,@" get default Image error !!!");
    }
    
    return image;
}

@end
