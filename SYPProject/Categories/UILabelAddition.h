//
//  UILabelAddition.h
//  XYCore
//
//  Created by sunyuping on 13-4-22.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (UILabelAddition)

-(CGSize)autoWidthWithMax:(float)maxWidth;
-(void)setAutoWidth:(NSString*)text maxWidth:(float)maxWidth;
@end
