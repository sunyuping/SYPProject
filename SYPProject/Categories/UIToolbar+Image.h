//
//  UIToolbar+Image.h
//  XYCore
//
//  Created by sunyuping on 13-3-7.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIToolbar(UIToolbar_Image)

// 设置底边条背景图片
- (void)setToolBarWithImageKey:(NSString *)imageKey;
// 清空底边条的背景图片，使恢复到系统默认状态
- (void)clearToolBarImage;


@end
