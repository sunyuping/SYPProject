//
//  UIButton+UIButtonExt.h
//  XYCore
//
//  Created by sunyuping on 13-2-23.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(XYUIButtonExt)
/**
 * 返回一个自定义的UIButton对象。
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
						frame:(CGRect)frame
						image:(UIImage *)image
			  backgroundImage:(UIImage *)backgroundImage
	   backgroundImagePressed:(UIImage *)backgroundImagePressed
					textColor:(UIColor *)textColor
		 highlightedTextColor:(UIColor *)highlightedTextColor;

/**
 * 返回一个自定义的UIButton对象。
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
						frame:(CGRect)frame
						image:(UIImage *)image
			  backgroundImage:(UIImage *)backgroundImage
	   backgroundImagePressed:(UIImage *)backgroundImagePressed
					textColor:(UIColor *)textColor
		 highlightedTextColor:(UIColor *)highlightedTextColor
					   target:(id)target
					 selector:(SEL)selector;
/**
 * 返回一个自定义的UIButton对象。
 */
+ (UIButton *)buttonWithTitle:(NSString *)title
						frame:(CGRect)frame
						image:(UIImage *)image
			  backgroundImage:(UIImage *)backgroundImage
	   backgroundImagePressed:(UIImage *)backgroundImagePressed
					 textFont:(UIFont *)textFont
					textColor:(UIColor *)textColor
		 highlightedTextColor:(UIColor *)highlightedTextColor
					   target:(id)target
					 selector:(SEL)selector;

-(void)setBackImage:(UIImage*)image;
-(void)setImage:(UIImage*)image;

-(void)setText:(NSString*)text;
@end
