//
//  PicetureView.m
//  Picture
//
//  Created by Keggcalm on 12-1-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PicetureView.h"

@interface PicetureView(private) 

- (CGFloat)angleBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2; 
- (NSInteger)distanceBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2;
- (void)showOverlayWithFrame:(CGRect)changeframe;
- (void)set_path;
@end

@implementation PicetureView

@synthesize showImageView = _showImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //_showImageView.image = [UIImage imageNamed:@"new.png"];
        _showImageView.userInteractionEnabled = YES;
        _showImageView.multipleTouchEnabled = YES;
        _showImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _showImageView.layer.shadowOffset = CGSizeMake(-1,-1);
        _showImageView.layer.shouldRasterize = YES;
        _showImageView.layer.shadowOpacity = 1;
        _showImageView.layer.borderColor = [UIColor whiteColor].CGColor;
       // _showImageView.layer.borderWidth = 1.0;
        [self addSubview:_showImageView];
        self.backgroundColor = [UIColor clearColor];
        self.multipleTouchEnabled = YES;
    }
    return self;
}

- (void)dealloc
{
    [_showImageView release];
    _showImageView = nil;
    [super dealloc];
}

- (void)showOverlayWithFrame:(CGRect)changeframe
{
    self.bounds = changeframe;
    _showImageView.layer.shadowOffset = CGSizeMake(0,-1);
}

- (CGFloat)angleBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 
{  
    CGFloat deltaY = point1.y - point2.y; 
    CGFloat deltaX = point1.x - point2.x; 
    CGFloat angle = atan2(deltaY, deltaX); 
    return angle; 
} 

- (NSInteger)distanceBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2 
{ 
    CGFloat deltaX = fabsf(point1.x - point2.x);
    CGFloat deltaY = fabsf(point1.y - point2.y); 
    CGFloat distance = sqrt((deltaY*deltaY)+(deltaX*deltaX)); 
    return distance; 
} 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if ([super hitTest:point withEvent:event] == _showImageView) {
        return _showImageView;
    }
    return nil;    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 1) {
        if (touch.view == _showImageView) {
            if ([self superview]) {
                [[self superview] bringSubviewToFront:self];
            }
        } 
    } 
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSUInteger touchCount = [[touches allObjects] count];
    if (touchCount == 1) {
        UITouch *touch = [touches anyObject];
        if (touch.view == _showImageView) {
            CGPoint prevPoint = [touch previousLocationInView:self];
            CGPoint curPoint = [touch locationInView:self];
            CGPoint centerPoint  = self.center;
            centerPoint.x = centerPoint.x + curPoint.x - prevPoint.x;
            centerPoint.y = centerPoint.y + curPoint.y - prevPoint.y; 
            [self setCenter:centerPoint];
        }
    } else if (touchCount == 2) {
        
        CGPoint prevPoint1 = [[[touches allObjects] objectAtIndex:0] previousLocationInView:self]; 
        CGPoint prevPoint2 = [[[touches allObjects] objectAtIndex:1] previousLocationInView:self]; 
        
        CGPoint curPoint1 = [[[touches allObjects] objectAtIndex:0] locationInView:self]; 
        CGPoint curPoint2 = [[[touches allObjects] objectAtIndex:1] locationInView:self]; 
        
        float prevDistance = [self distanceBetweenPoint1:prevPoint1 andPoint2:prevPoint2]; 
        float newDistance = [self distanceBetweenPoint1:curPoint1 andPoint2:curPoint2]; 
        float sizeDifference = (newDistance / prevDistance); 
        
        CGAffineTransform scaleTransform = CGAffineTransformScale(_showImageView.transform, sizeDifference, sizeDifference); 
        _showImageView.transform = scaleTransform;
            
        
        float prevAngle = [self angleBetweenPoint1:prevPoint1 andPoint2:prevPoint2]; 
        float curAngle = [self angleBetweenPoint1:curPoint1 andPoint2:curPoint2]; 
        float angleDifference = curAngle - prevAngle; 
        CGAffineTransform rotateTransform = CGAffineTransformRotate(_showImageView.transform, angleDifference); 
        _showImageView.transform = rotateTransform; 
        [self showOverlayWithFrame:_showImageView.frame];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.view == _showImageView) {
        if ([touch tapCount] == 2) {
            CGAffineTransform scaleTransform = CGAffineTransformScale(_showImageView.transform, 2, 2); 
            _showImageView.transform = scaleTransform; 
            [self showOverlayWithFrame:_showImageView.frame];
        }
    }
}

@end
