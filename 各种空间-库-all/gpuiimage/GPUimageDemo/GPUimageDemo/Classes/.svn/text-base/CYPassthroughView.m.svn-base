//
//  CYPassthroughView.m
//  CYFilter
//
//  Created by chen yi on 12-12-25.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYPassthroughView.h"

@implementation CYPassthroughView
{
	BOOL testHits;
}

@synthesize passthroughViews=_passthroughViews;

-(void) dealloc{
    self.passthroughViews = nil;
	[super dealloc];
}


-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//	NSLog(@"检查碰撞 ～");

    if(testHits){
        return nil;
    }
	
    if(!self.passthroughViews
	   || (self.passthroughViews && self.passthroughViews.count == 0)){
        return self;
    } else {
		
        UIView *hitView = [super hitTest:point withEvent:event];
		
        if (hitView == self) {
            //Test whether any of the passthrough views would handle this touch
			for (UIView *view in self.passthroughViews) {///修改了
				testHits = YES;
				CGPoint superPoint = [view convertPoint:point fromView:self];
				UIView *superHitView = [view hitTest:superPoint withEvent:event];
				testHits = NO;
				
				if ([self isPassthroughView:superHitView]) {
					hitView = superHitView;
				}
			}
//            testHits = YES;
//            CGPoint superPoint = [self.superview convertPoint:point fromView:self];
//            UIView *superHitView = [self.superview hitTest:superPoint withEvent:event];
//            testHits = NO;
//			
//            if ([self isPassthroughView:superHitView]) {
//                hitView = superHitView;
//            }
        }
        return hitView;
//		NSLog(@"检查碰撞 ～%@",hitView);
    }
	
}

- (BOOL)isPassthroughView:(UIView *)view {
//	NSLog(@"判断穿越～～～～%@",view);
    if (view == nil) {
        return NO;
    }
	
    if ([self.passthroughViews containsObject:view]) {
//		NSLog(@"～～～～～～穿越事件点击的视图是：%@",[view description]);
        return YES;
    }
	
    return [self isPassthroughView:view.superview];
}


@end
