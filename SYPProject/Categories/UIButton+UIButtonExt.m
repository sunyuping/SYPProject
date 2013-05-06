//
//  UIButton+UIButtonExt.m
//  XYCore
//
//  Created by sunyuping on 13-2-23.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "UIButton+UIButtonExt.h"

@implementation UIButton(XYUIButtonExt)

+ (UIButton *)buttonWithTitle:(NSString *)title
						frame:(CGRect)frame
						image:(UIImage *)image
			  backgroundImage:(UIImage *)backgroundImage
	   backgroundImagePressed:(UIImage *)backgroundImagePressed
					textColor:(UIColor *)textColor
		 highlightedTextColor:(UIColor *)highlightedTextColor
					   target:(id)target
					 selector:(SEL)selector {
	
	return [self buttonWithTitle:title
						   frame:frame
						   image:image
				 backgroundImage:backgroundImage
		  backgroundImagePressed:backgroundImagePressed
						textFont:[UIFont boldSystemFontOfSize:16]
					   textColor:textColor
			highlightedTextColor:highlightedTextColor
						  target:target
						selector:selector];
}
+ (UIButton *)buttonWithTitle:(NSString *)title
						frame:(CGRect)frame
						image:(UIImage *)image
			  backgroundImage:(UIImage *)backgroundImage
	   backgroundImagePressed:(UIImage *)backgroundImagePressed
					 textFont:(UIFont *)textFont
					textColor:(UIColor *)textColor
		 highlightedTextColor:(UIColor *)highlightedTextColor
					   target:(id)target
					 selector:(SEL)selector {
	UIButton *button = [[[UIButton alloc] initWithFrame:frame] autorelease];
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:textColor forState:UIControlStateNormal];
	[button setTitleColor:highlightedTextColor forState:UIControlStateHighlighted];
	button.titleLabel.font = textFont;
    CGRect titleFrame = button.titleLabel.frame;
	
	[button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
	if (backgroundImagePressed) {
        [button setBackgroundImage:backgroundImagePressed forState:UIControlStateHighlighted];
    }
	
	if (target) {
		[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	}
	if (image) {
		[button setImage:image forState:UIControlStateNormal];
		button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, titleFrame.origin.x);
	}
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}

+ (UIButton *)buttonWithTitle:(NSString *)title
						frame:(CGRect)frame
						image:(UIImage *)image
			  backgroundImage:(UIImage *)backgroundImage
	   backgroundImagePressed:(UIImage *)backgroundImagePressed
					textColor:(UIColor *)textColor
		 highlightedTextColor:(UIColor *)highlightedTextColor {
	return [self buttonWithTitle:title
						   frame:frame
						   image:image
				 backgroundImage:backgroundImage
		  backgroundImagePressed:backgroundImagePressed
					   textColor:textColor
			highlightedTextColor:highlightedTextColor
						  target:nil
						selector:nil];
}
-(void)setBackImage:(UIImage*)image{
    [self setBackgroundImage:image forState:UIControlStateNormal];
	[self setBackgroundImage:image forState:UIControlStateSelected];
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
}
-(void)setImage:(UIImage*)image{
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateSelected];
    [self setImage:image forState:UIControlStateHighlighted];
}
-(void)setText:(NSString*)text{
    [self setTitle:text forState:UIControlStateNormal];
    
    
}

@end
