//
//  BlockBackground.m
//  arrived
//
//  Created by Gustavo Ambrozio on 29/11/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "BlockBackground.h"
#import "AppDelegate.h"

@interface BlockBackground ()

@property (nonatomic, retain) UIWindow *previousKeyWindow;

@end

@implementation BlockBackground

//@synthesize backgroundImage = _backgroundImage;
//@synthesize vignetteBackground = _vignetteBackground;

@synthesize previousKeyWindow = _previousKeyWindow;

static BlockBackground *_sharedInstance = nil;

+ (BlockBackground*)sharedInstance
{
    if (_sharedInstance != nil) {
        return _sharedInstance;
    }

    @synchronized(self) {
        if (_sharedInstance == nil) {
            [[[self alloc] init] autorelease];
        }
    }

    return _sharedInstance;
}

+ (id)allocWithZone:(NSZone*)zone
{
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            return _sharedInstance;
        }
    }
    NSAssert(NO, @ "[BlockBackground alloc] explicitly called on singleton class.");
    return nil;
}

- (id)copyWithZone:(NSZone*)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (unsigned)retainCount
{
    return UINT_MAX;
}

- (oneway void)release
{
}

- (id)autorelease
{
    return self;
}

- (id)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.windowLevel = UIWindowLevelAlert;//UIWindowLevelStatusBar;;
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
//        self.vignetteBackground = NO;
    }
    return self;
}

- (void)addToMainWindow:(UIView *)view
{
//    if (self.hidden)
    {
        self.alpha = 0.0f;
        self.hidden = NO;
        self.userInteractionEnabled = YES;
        
        self.previousKeyWindow = [[UIApplication sharedApplication] keyWindow];
        [self makeKeyWindow];
    }
    
    if (self.subviews.count > 0)
    {
        ((UIView*)[self.subviews lastObject]).userInteractionEnabled = NO;
    }
    
//    if (_backgroundImage)
//    {
//        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:_backgroundImage];
//        backgroundView.frame = self.bounds;
//        backgroundView.contentMode = UIViewContentModeScaleToFill;
//        [self addSubview:backgroundView];
//        [backgroundView release];
//        [_backgroundImage release];
//        _backgroundImage = nil;
//    }
    
    [self addSubview:view];
}

- (void)reduceAlphaIfEmpty
{
    if (self.subviews.count == 1)
    {
        self.alpha = 0.0f;
        self.userInteractionEnabled = NO;
    }
}

- (void)removeView:(UIView *)view
{
    [view removeFromSuperview];
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
//    [self removeAllSubviews];
    
    if (self.subviews.count == 0)
    {
        self.hidden = YES;
        // 动画导致键盘实效 , 前一个动画没有结束 因此 self.previousKeyWindow 还是 BlockBacground
        // 最终keywindow变为BlockBacground
        //[self.previousKeyWindow makeKeyWindow];
        AppDelegate* delgate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [delgate.window makeKeyWindow];
        //self.previousKeyWindow = nil;
//        [_previousKeyWindow release];
//        _previousKeyWindow = nil;
    }
    else
    {
        ((UIView*)[self.subviews lastObject]).userInteractionEnabled = YES;
    }
}


//- (void)drawRect:(CGRect)rect 
//{    
////    if (_backgroundImage || !_vignetteBackground) return;
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//	size_t locationsCount = 2;
//	CGFloat locations[2] = {0.0f, 1.0f};
//	CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f}; 
//	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
//	CGColorSpaceRelease(colorSpace);
//	
//	CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
//	float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
//	CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
//	CGGradientRelease(gradient);
//}


@end
