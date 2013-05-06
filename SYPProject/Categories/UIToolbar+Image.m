//
//  UIToolbar+Image.m
//  XYCore
//
//  Created by sunyuping on 13-3-7.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "UIToolbar+Image.h"
#import "UIFont+PKFont.h"
#import "UIImage+PKImage.h"


static UIImage *toolBarImage = nil;

@implementation UIToolbar(UIToolbar_Image)

- (void)drawRect:(CGRect)rect {
    if (toolBarImage) {
        [toolBarImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }
    
}

// 设置导航条背景图片 navigation_bar_bg.png
- (void)setToolBarWithImageKey:(NSString *)imageKey{
    UIImage *image = [UIImage imageForKey:imageKey];
    
    if ([self respondsToSelector:@selector(setBackgroundImage: forToolbarPosition: barMetrics:)]) {
        [self setBackgroundImage:image forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
        self.tintColor = [UIColor colorWithPatternImage:image];
    }
    else{
        toolBarImage = image;
    }
    self.backgroundColor = [UIColor blackColor];
}

- (void)clearToolBarImage{
    
    
    if ([self respondsToSelector:@selector(setBackgroundImage: forToolbarPosition: barMetrics:)]) {
        [self setBackgroundImage:nil forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    }else{
        toolBarImage = nil;
    }
}


@end
