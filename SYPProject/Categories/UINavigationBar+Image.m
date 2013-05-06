//
//  UINavigationBar+Image.m
//  XYCore
//
//  Created by sunyuping on 13-1-21.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "UINavigationBar+Image.h"
static UIImage *navigationBarImage = nil;


@implementation UINavigationBar (Image)

// 这里由类别改成继承方式，主要是在5.0以下版本，调用短信，邮件等系统界面时，需在调用原来的绘制方法，
// 但是类别实现不能满足这一需求，所以改为继承，这里重写此方法实现
//+ (Class)class
//{
//    return NSClassFromString(@"RSNavigationBar");
//}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (navigationBarImage) {
        [navigationBarImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    }

}

// 设置导航条背景图片 navigation_bar_bg.png
- (void)setNavigationBarWithImageKey:(NSString *)imageKey{
    UIImage *image = [UIImage imageForKey:imageKey];
    
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        self.tintColor = [UIColor colorWithPatternImage:image];
    }
    else{
        navigationBarImage = image;
    }
    
    if ([self respondsToSelector:@selector(setTitleVerticalPositionAdjustment:forBarMetrics:)]) {
        [self setTitleVerticalPositionAdjustment:44.0f - image.size.height forBarMetrics:UIBarMetricsDefault];
    }
//    self.backgroundColor = [UIColor blackColor];
}

- (void)clearNavigationBarImage{
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }else{
        navigationBarImage = nil;
    }
}

@end



@implementation UINavigationController (Rotate)

-(NSUInteger)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate
{
    return YES;
}


@end

