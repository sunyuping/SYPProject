//
//  RSStroke.m
//  RRSnapCommon
//
//  Created by Apple on 13-1-17.
//  Copyright (c) 2013年 renren. All rights reserved.
//

#import "RSStroke.h"
#import <QuartzCore/QuartzCore.h>



#define COOKBOOK_PURPLE_COLOR    [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]

#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]
#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

// Get points from Bezier Curve
void getPointsFromBezier(void *info, const CGPathElement *element)
{
    NSMutableArray *bezierPoints = ( NSMutableArray *)info;
    
    // Retrieve the path element type and its points
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
    // Add the points if they're available (per type)
    if (type != kCGPathElementCloseSubpath)
    {
        [bezierPoints addObject:VALUE(0)];
        if ((type != kCGPathElementAddLineToPoint) &&
            (type != kCGPathElementMoveToPoint))
            [bezierPoints addObject:VALUE(1)];
    }
    if (type == kCGPathElementAddCurveToPoint)
        [bezierPoints addObject:VALUE(2)];
}

NSArray *pointsFromBezierPath(UIBezierPath *bpath)
{
    NSMutableArray *points = [NSMutableArray array];
    CGPathApply(bpath.CGPath, ( void *)points, getPointsFromBezier);
    return points;
}

UIBezierPath *smoothedPath(UIBezierPath *bpath, int granularity)
{
    NSArray *points = pointsFromBezierPath(bpath);
    
    if (points.count < 4) return bpath;
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    
    // Copy traits
    smoothedPath.lineWidth = bpath.lineWidth;
    
    // Draw out the first 3 points (0..2)
    [smoothedPath moveToPoint:POINT(0)];
    for (int index = 1; index < 3; index++)
        [smoothedPath addLineToPoint:POINT(index)];
    
    for (int index = 4; index < points.count; index++)
    {
        CGPoint p0 = POINT(index - 3);
        CGPoint p1 = POINT(index - 2);
        CGPoint p2 = POINT(index - 1);
        CGPoint p3 = POINT(index);
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++)
        {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            [smoothedPath addLineToPoint:pi];
        }
        
        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    
    return smoothedPath;
}


@implementation RSStroke

@synthesize path;
@synthesize strokeWidth;
@synthesize strokeColor;

- (void)setPath:(UIBezierPath *)aPath {

	if (path != aPath) {
        [aPath retain];
        [path release];
		path = aPath;
	}
}

- (void)setStrokeColor:(CGColorRef)aColor {
	if (strokeColor != aColor) {
		CGColorRelease(strokeColor);
		strokeColor = CGColorRetain(aColor);
	}
}

- (void)dealloc {
    [path release];
	CGColorRelease(strokeColor);
	[super dealloc];
}

- (void)strokeWithContext:(CGContextRef)context {
    [[UIColor colorWithCGColor:strokeColor]set];
    [smoothedPath(path, 20) stroke];  //通过曲线拟合·
}

@end
