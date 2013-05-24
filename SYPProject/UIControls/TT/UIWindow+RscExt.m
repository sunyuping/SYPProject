//
//  UIWindow+RscExt.m
//  RenrenSixin
//
//  Created by zhongsheng on 12-5-28.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "UIWindow+RscExt.h"

@implementation UIWindow (RscExt)
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)findFirstResponder {
    return [self findFirstResponderInView:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)findFirstResponderInView:(UIView*)topView {
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView* firstResponderCheck = [self findFirstResponderInView:subView];
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}

@end
