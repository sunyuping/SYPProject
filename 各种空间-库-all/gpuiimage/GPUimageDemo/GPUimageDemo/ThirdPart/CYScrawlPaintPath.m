//
//  CYScrawPaintPath.m
//  CYFilter
//
//  Created by chen yi on 12-12-21.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYScrawlPaintPath.h"
#define kDrawLineWidth 6.0f
@implementation CYScrawlPaintPath
@synthesize paintPoints = _paintPoints;
@synthesize pathColor = _pathColor;

CGPoint midPoint1(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

- (void)dealloc{
	
	self.paintPoints = nil;
	self.pathColor = nil;
//	[super dealloc];
}

- (id)init{
	self = [super init];
	if (self) {
		self.paintPoints = [NSMutableArray array];
		self.pathColor = [UIColor blackColor];
	}
	
	return self;
}

- (id)copyWithZone:(NSZone *)zone{
	CYScrawlPaintPath *copyZone =  [[self.class allocWithZone:zone]init]; 
	if (copyZone) {
		[copyZone setPaintPoints:self.paintPoints ];
		[copyZone setPathColor:self.pathColor  ];
	}
	return copyZone ;
}

- (void)addPaintPoint:(CGPoint)point{
	[self.paintPoints addObject:[NSValue valueWithCGPoint:point]];
}

/*	是否需要画线
 */
- (BOOL)isNeedToPaintLine {
	if (!self.paintPoints || self.paintPoints.count <=1){
		return NO ;
	}
	return YES;
}


/*	将所有的点连接
 */
- (void)paintPathWithContext:(CGContextRef)context{
	
	CYScrawlPaintPath *path = self;	
	if (self.paintPoints.count == 2) { //画一个小点点
		[path.pathColor set];
		
		CGPoint pointCenter = [[path.paintPoints objectAtIndex:0]CGPointValue];
		CGContextSaveGState(context);
		CGRect r = CGRectMake(pointCenter.x - kDrawLineWidth * 0.5,
							  pointCenter.y - kDrawLineWidth * 0.5,
							  kDrawLineWidth,
							  kDrawLineWidth);
		CGContextFillEllipseInRect(context, r);
		CGContextRestoreGState(context);
		return;
	}

	if (![path isNeedToPaintLine]) {
		return;
	}
	
	NSArray *array = path.paintPoints;
 	CGContextSaveGState(context);
	CGContextSetLineWidth(context, kDrawLineWidth);
	[path.pathColor set];
	CGPoint pointArrar[array.count];
    CGFloat movieToX = 0.0f;
    CGFloat movieToY = 0.0f;
	for (int i = 0 ; i < array.count ; i++)
	{
        CGPoint point = [[array objectAtIndex:i] CGPointValue];
		pointArrar[i] = point;
        if(i == 0){
            movieToX = point.x;
            movieToY = point.y;
        }
	}
	CGContextMoveToPoint(context, movieToX, movieToY);

    CGContextSetLineCap(context, kCGLineCapRound);
    
    for (int i = 0 ; i < [array count] - 2; i++) {
        CGPoint previousPoint1  = pointArrar[i + 1];
        CGPoint currentPoint = pointArrar[i + 2];
        CGPoint mid2 = midPoint1(currentPoint, previousPoint1);
        CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    }
//    
    
	CGContextStrokePath(context);
    
	CGContextRestoreGState(context);
}
@end
