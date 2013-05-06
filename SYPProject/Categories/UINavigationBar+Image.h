//
//  UINavigationBar+Image.h
//  XYCore
//
//  Created by sunyuping on 13-1-21.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINavigationBar (Image)

// 设置导航条背景图片
- (void)setNavigationBarWithImageKey:(NSString *)imageKey;
// 清空导航条的背景图片，使恢复到系统默认状态
- (void)clearNavigationBarImage;

@end

//选转问题
@interface UINavigationController (Rotate)

@end
