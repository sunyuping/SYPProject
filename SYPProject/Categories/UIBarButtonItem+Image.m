//
//  UIBarButtonItem+Image.m
//  XYCore
//
//  Created by sunyuping on 13-1-21.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "UIBarButtonItem+Image.h"

#import "PKResManager.h"

@implementation UIBarButtonItem (CustomImage)

- (void)setButtonAttribute:(NSDictionary*)dic
{
    if ([self.customView isKindOfClass:[UIButton class]]) {
        UIButton* button = (UIButton*)self.customView;
        UIFont* font = [dic objectForKey:@"font"];
        if (font != nil && [font isKindOfClass:[UIFont class]]) {
            [button.titleLabel setFont:font];
        }
        NSNumber* shadowOffset = [dic objectForKey:@"shadowOffset"];
        if (shadowOffset != nil && [shadowOffset isKindOfClass:[NSNumber class]]) {
            [button.titleLabel setShadowOffset:shadowOffset.CGSizeValue];
        }
        NSNumber* buttonWidth = [dic objectForKey:@"width"];
        if (buttonWidth != nil && [buttonWidth isKindOfClass:[NSNumber class]]) {
            CGRect rc = button.frame;
            rc.size.width = buttonWidth.floatValue;
            button.frame = rc;
        }
        UIColor* titleColorNormal = [dic objectForKey:@"titleColorNormal"];
        if (titleColorNormal != nil && [titleColorNormal isKindOfClass:[UIColor class]]) {
            [button setTitleColor:titleColorNormal forState:UIControlStateNormal];
        }
        UIColor* shadowColorNormal = [dic objectForKey:@"shadowColorNormal"];
        if (shadowColorNormal != nil && [shadowColorNormal isKindOfClass:[UIColor class]]) {
            [button setTitleShadowColor:shadowColorNormal forState:UIControlStateNormal];
        }
        UIColor* titleColorHighlighted = [dic objectForKey:@"titleColorHighlighted"];
        if (titleColorHighlighted != nil && [titleColorHighlighted isKindOfClass:[UIColor class]]) {
            [button setTitleColor:titleColorHighlighted forState:UIControlStateHighlighted];
        }
        UIColor* shadowColorHightlighted = [dic objectForKey:@"shadowColorHightlighted"];
        if (shadowColorHightlighted != nil && [shadowColorHightlighted isKindOfClass:[UIColor class]]) {
            [button setTitleShadowColor:shadowColorHightlighted forState:UIControlStateHighlighted];
        }
    }
}

+ (UIBarButtonItem *)rsBarButtonItemWithTitle:(NSString *)title
                                        image:(UIImage *)image
                             heightLightImage:(UIImage *)hlImage
                                 disableImage:(UIImage *)disImage
                                       target:(id)target
                                       action:(SEL)selector
{
    UIButton* customButton = [self rsCustomBarButtonWithTitle:title
                                                        image:image
                                             heightLightImage:hlImage
                                                 disableImage:disImage
                                                       target:target
                                                       action:selector];
    CGSize sizeOfTitle = CGSizeZero;
    if (title!=nil && ![title isEqualToString:@""]) {
        sizeOfTitle = [title sizeWithFont:customButton.titleLabel.font
                        constrainedToSize:CGSizeMake(100.0f, 22.0f)
                            lineBreakMode:UILineBreakModeMiddleTruncation];
    }
    if (sizeOfTitle.width <= 0.0f) {
        [customButton setFrame:CGRectMake(0.0f,
                                          0.0f,
                                          customButton.currentBackgroundImage.size.width,
                                          customButton.currentBackgroundImage.size.height)];
    }else {
        [customButton setFrame:CGRectMake(0.0f,
                                          0.0f,
                                          sizeOfTitle.width+30.0f,
                                          customButton.currentBackgroundImage.size.height)];
    }
    
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    //    barBtnItem.width = [customButton currentBackgroundImage].size.width;
    return [barBtnItem autorelease];
}

+ (UIBarButtonItem *)rsBarButtonItemWithTitle:(NSString *)title
                                       target:(id)target
                                       action:(SEL)selector{
    UIImage *imageOri = [UIImage imageForKey:@"navigation_button_text"];
    UIImage* image = [imageOri stretchableImageWithLeftCapWidth:imageOri.size.width/2.0f topCapHeight:imageOri.size.height/2.0f];
    //stretchableImageWithLeftCapWidth:18.0f
    //topCapHeight:18.0f];
    UIImage *hlImage = nil;//[UIImage imageForKey:@"navigation_button_blue_hl"];
    //stretchableImageWithLeftCapWidth:18.0f
    //topCapHeight:18.0f];
    UIImage* disImage = [UIImage imageForKey:@"navigation_button_disable"];
    return [UIBarButtonItem rsBarButtonItemWithTitle:title
                                               image:image
                                    heightLightImage:hlImage
                                        disableImage:[disImage stretchableImageWithLeftCapWidth:imageOri.size.width/2.0f topCapHeight:imageOri.size.height/2.0f]
                                              target:target
                                              action:selector];
}

+ (UIButton*)rsCustomBarButtonWithTitle:(NSString*)title
                                  image:(UIImage *)image
                       heightLightImage:(UIImage *)hlImage
                           disableImage:(UIImage *)disImage
                                 target:(id)target
                                 action:(SEL)selector
{
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setBackgroundColor:[UIColor clearColor]];
    [customButton setBackgroundImage:image forState:UIControlStateNormal];
    [customButton setBackgroundImage:hlImage forState:UIControlStateHighlighted];
    if (nil != disImage)
    {
        [customButton setBackgroundImage:disImage forState:UIControlStateDisabled];
    }
//    [customButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [customButton.titleLabel setFont:[UIFont fontForKey:@"CommonFont-fontSizeCB"]];
//    [customButton.titleLabel setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    if (title!=nil && title.length > 0) {
        [customButton setTitle:title forState:UIControlStateNormal];
        [customButton setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
        [customButton setTitleColor:RGBCOLOR(98.0f, 157.0f, 140.0f) forState:UIControlStateDisabled];
//        [customButton setTitleShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.2f] forState:UIControlStateNormal];
//        [customButton setTitleShadowColor:[UIColor clearColor] forState:UIControlStateDisabled];
    }
    [customButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return customButton;
}

@end
