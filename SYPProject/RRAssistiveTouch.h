//
//  RRAssistiveTouch.h
//  SYPProject
//
//  Created by sunyuping on 13-7-4.
//
//

#import <UIKit/UIKit.h>

@interface RRAssistiveTouch : UIWindow<UIGestureRecognizerDelegate>{
    UIButton *_normalBtn;
    CGPoint _old_point;
}

@end
