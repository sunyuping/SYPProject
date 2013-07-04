//
//  RRAssistiveTouch.m
//  SYPProject
//
//  Created by sunyuping on 13-7-4.
//
//

#import "RRAssistiveTouch.h"


@implementation RRAssistiveTouch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0,0,55,55);
        self.windowLevel = UIWindowLevelStatusBar;
        _normalBtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        _normalBtn.frame = self.bounds;
        [_normalBtn setBackgroundImage:[UIImage imageNamed:@"action_point_normal"] forState:UIControlStateNormal];
        [_normalBtn setBackgroundImage:[UIImage imageNamed:@"action_point_pressed"] forState:UIControlStateHighlighted];
        
        
        [self addSubview:_normalBtn];
        
        //创建panGesture手势
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(movePoint:)];
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 1;
        panGesture.delegate = self;
        [_normalBtn addGestureRecognizer:panGesture];
        [panGesture release];
        
        
    }
    return self;
}
//
//UIGestureRecognizerStateBegan,      // the recognizer has received touches recognized as the gesture. the action method will be called at the next turn of the run loop
//UIGestureRecognizerStateChanged,    // the recognizer has received touches recognized as a change to the gesture. the action method will be called at the next turn of the run loop
//UIGestureRecognizerStateEnded,      // the recognizer has received touches recognized as the end of the gesture. the action method will be called at the next turn of the run loop and the recognizer will be reset to UIGestureRecognizerStatePossible
//UIGestureRecognizerStateCancelled,
- (void)movePoint:(UIPanGestureRecognizer *)recognizer {
    CGPoint point = [recognizer translationInView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        _old_point = self.origin;
        
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        float  end_x = _old_point.x + point.x;
        float  end_y = _old_point.y + point.y;
        [UIView animateWithDuration:0.1 animations:^{
            self.origin = CGPointMake(end_x, end_y);
        }];
        

    }else if (recognizer.state == UIGestureRecognizerStateEnded){
        float last_x=0;
        if (self.origin.x>320/2) {
            last_x = 320-self.width;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.origin = CGPointMake(last_x, self.origin.y);
        }];
        
        
    }
    
    
 
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
