//
//  RSColorBarPicker.m
//  RRSnapCommon
//
//  Created by chen yi on 12-12-29.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "RSColorBarPicker.h"

#import "InfHSBSupport.h"

#define kContentInsetY 0

@implementation RSColorBarView

//------------------------------------------------------------------------------

static CGImageRef createContentImage()
{
	float hsv[] = { 0.0f, 1.0f, 1.0f };
	return createHSVBarContentImageVertical( InfComponentIndexHue, hsv );
}

//------------------------------------------------------------------------------

- (void) drawRect: (CGRect) rect
{
	CGImageRef image = createContentImage();
	
	if( image ) {
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGContextDrawImage( context, [ self bounds ], image );
		
		CGImageRelease( image );
	}
}

//------------------------------------------------------------------------------

@end

@implementation RSColorBarPicker
//------------------------------------------------------------------------------

@synthesize value;

//------------------------------------------------------------------------------
#pragma mark	Lifetime
//------------------------------------------------------------------------------

- (void) dealloc
{	
	[ super dealloc ];
}

//------------------------------------------------------------------------------
#pragma mark	Drawing
//------------------------------------------------------------------------------

- (void) layoutSubviews
{
//	if( indicator == nil ) {
//		CGFloat kIndicatorSize = 24.0f;
//		indicator = [ [ InfColorIndicatorView alloc ] initWithFrame: CGRectMake( 0, 0, kIndicatorSize, kIndicatorSize ) ];
//		[ self addSubview: indicator ];
//	}
//	
//	indicator.color = [ UIColor colorWithHue: value saturation: 1.0f
//								  brightness: 1.0f alpha: 1.0f ];
//	
//	CGFloat indicatorLoc = kContentInsetX + ( self.value * ( self.bounds.size.width - 2 * kContentInsetX ) );
//	indicator.center = CGPointMake( indicatorLoc, CGRectGetMidY( self.bounds ) );
}

//------------------------------------------------------------------------------
#pragma mark	Properties
//------------------------------------------------------------------------------

- (void) setValue: (float) newValue
{
	if( newValue != value ) {
		value = newValue;
		
		[ self sendActionsForControlEvents: UIControlEventValueChanged ];
		[ self setNeedsLayout ];
	}
}

//------------------------------------------------------------------------------
#pragma mark	Tracking
//------------------------------------------------------------------------------

- (void) trackIndicatorWithTouch: (UITouch*) touch
{

	float percent =  ([ touch locationInView: self ].y - kContentInsetY ) / (self.bounds.size.height - 2 * kContentInsetY);
    NSLog(@"percent = %f",percent);

	self.value = pin( 0.0f, percent, 1.0f );
}

//------------------------------------------------------------------------------

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    [self trackIndicatorWithTouch:touch];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    [self trackIndicatorWithTouch:touch];
}


- (BOOL) beginTrackingWithTouch: (UITouch*) touch
					  withEvent: (UIEvent*) event
{
	[ self trackIndicatorWithTouch: touch ];
	
	return YES;
}

//------------------------------------------------------------------------------

- (BOOL) continueTrackingWithTouch: (UITouch*) touch
						 withEvent: (UIEvent*) event
{
	[ self trackIndicatorWithTouch: touch ];
	
	return YES;
}


@end
