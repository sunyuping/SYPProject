//
//  CYScrawlView.m
//  CYFilter
//
//  Created by chen yi on 12-12-21.
//  Copyright (c) 2012年 renren. All rights reserved.
//
#import "CYScrawlView.h"
#import "CYScrawlPaintPath.h"

#define DEFAULT_COLOR [UIColor blackColor]
#define DEFAULT_WIDTH 6.0f

#pragma mark Private Helper function

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}

@interface CYScrawlView()
{
@private
	//保存多条路径
	NSMutableArray *_paintPaths;
	
	//当前路径
	CYScrawlPaintPath *_currentPath;
}

@end


@implementation CYScrawlView

@synthesize currentPaintColor = _currentPaintColor;
@synthesize delegate;
@synthesize isForbidDrawPath = _isForbidDrawPath;
@synthesize lineColor;
@synthesize lineWidth;
-(void)setup
{
    self.lineWidth = DEFAULT_WIDTH;
    self.lineColor = DEFAULT_COLOR;
}

- (void)dealloc{
	self.currentPaintColor = nil;
	self.delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.paintPaths = [NSMutableArray array];
		
		self.currentPaintColor = [UIColor whiteColor];
		
		self.currentPath = [[CYScrawlPaintPath alloc]init];
		
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		self.userInteractionEnabled = YES;
		self.isForbidDrawPath = NO;
        
        [self setup];
    }
    return self;
}
/*	从另外一个涂鸦拷贝路径
 */
- (void)copyFromScrawlView:(CYScrawlView * )view{
	id copyZone;
    if ([view.paintPaths count]>0) {
        copyZone = [view.paintPaths mutableCopy];
        self.paintPaths = copyZone;
    }
    
	copyZone = [view.currentPath copy];
	self.currentPath = copyZone;
	
    UIColor *color = [UIColor colorWithCGColor:view.currentPaintColor.CGColor];
 	self.currentPaintColor = color;
}

- (BOOL) isMultipleTouchEnabled
{
    return NO;
}

/*	取消最后一次画笔
 */
- (void)rollbackLastPaintPath{
    self.currentPath = nil;
    //如果当前是backup scrawlview 那么会拷贝本身到 scrawlView 
	if (self.delegate && [self.delegate respondsToSelector:@selector(scrawlViewPaintBegain:)]) {
		[self.delegate scrawlViewPaintBegain:self];
	}
    
    [self setNeedsDisplay];
}

/*  最后一笔的颜色
 */
- (UIColor *)lastPathColor{
    if (self.currentPath) {
        return self.currentPaintColor;
    }
    
    CYScrawlPaintPath *lastPath = [self.paintPaths lastObject];
    return lastPath.pathColor;
}



/*	清除所有的画笔路径
 */
- (void)removeAllPaintPath{
	self.currentPath = nil;
	[self.paintPaths removeAllObjects];
	if (self.delegate && [self.delegate respondsToSelector:@selector(scrawlViewPaintBegain:)]) {
		[self.delegate scrawlViewPaintBegain:self];
	}
	[self setNeedsDisplay];
}


/*	绘画内容是否为空
 */
- (BOOL)isDrawPathEmpty{
	if ( self.paintPaths.count == 0) {
		return YES;
	}
	return NO;
}

/*	获取当前涂鸦的图片
 */
- (UIImage *)imageFromCurrentPaintPath{
	UIGraphicsBeginImageContext(self.bounds.size);
	CGContextRef theContext = UIGraphicsGetCurrentContext();
	[self.layer renderInContext:theContext];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}



static UIView * covertView = nil;
//经过坐标转化
- (CGPoint )pointCovert:(CGPoint)pt{
	
	CGPoint point = CGPointZero;
	if (covertView == nil) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(viewCovertToDrawPoint:)]) {
			covertView = [self.delegate viewCovertToDrawPoint:self];
		}
	}
	if (covertView) {
		point = [self convertPoint:pt toView:covertView];
	}
	
    //	NSLog(@"坐标系转化之后的坐标：%@",NSStringFromCGPoint(pt));
	return point;
}

#pragma mark - homer-gl version touch event
// Handles the start of a touch ,backupscralview会触发这几个touch函数，但是绘制要是在scralview里面进行绘制
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pt = [[touches anyObject] locationInView:self];
	pt = [self pointCovert : pt];
    
    //第一个点要添加到路径里，但是是在touchmove中绘制
	self.currentPath = [[CYScrawlPaintPath alloc]init];
	self.currentPath.pathColor = self.currentPaintColor;
    [self.currentPath addPaintPoint:pt];
    
	if (self.delegate && [self.delegate respondsToSelector:@selector(scrawlViewPaintBegain:)]) {
		[self.delegate scrawlViewPaintBegain:self];
	}
    
    UITouch *touch = [touches anyObject];
    
    previousPoint1 = [touch previousLocationInView:self];
    previousPoint2 = [touch previousLocationInView:self];
    currentPoint = [touch locationInView:self];
    
    [self touchesMoved:touches withEvent:event];
}

// Handles the continuation of a touch.
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGPoint pt = [[touches anyObject] locationInView:self];
	pt = [self pointCovert : pt];
    
	[self.currentPath addPaintPoint:pt];
    
	if (self.delegate && [self.delegate respondsToSelector:@selector(scrawlViewPaintMove:)]) {
		[self.delegate scrawlViewPaintMove:self];
	}
    
    //
    UITouch *touch  = [touches anyObject];
    
    previousPoint2  = previousPoint1;
    previousPoint1  = [touch previousLocationInView:self];
    currentPoint    = [touch locationInView:self];
    
    // calculate mid point
    CGPoint mid1    = midPoint(previousPoint1, previousPoint2);
    CGPoint mid2    = midPoint(currentPoint, previousPoint1);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(path, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    CGRect bounds = CGPathGetBoundingBox(path);
    CGPathRelease(path);
    
    CGRect drawBox = bounds;
    
    //Pad our values so the bounding box respects our line width
    drawBox.origin.x        -= self.lineWidth * 2;
    drawBox.origin.y        -= self.lineWidth * 2;
    drawBox.size.width      += self.lineWidth * 4;
    drawBox.size.height     += self.lineWidth * 4;
    
    UIGraphicsBeginImageContext(drawBox.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	curImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
    [self setNeedsDisplayInRect:drawBox];
}

// Handles the end of a touch event when the touch is a tap.
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //添加当前路径的最后一个点
    if (self.currentPath) {
        [self.paintPaths addObject:self.currentPath];
    }
	self.currentPath = nil; //清除当前路径
    
	if (self.delegate && [self.delegate respondsToSelector:@selector(scrawlViewPaintEnd:)]) {
		[self.delegate scrawlViewPaintEnd:self];
	}
}

// Handles the end of a touch event.
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	// If appropriate, add code necessary to save the state of the application.
	// This application is not saving state.
    //添加当前路径的最后一个点
    if (self.currentPath) {
        [self.paintPaths addObject:self.currentPath];
    }
	self.currentPath = nil;
    
	if (self.delegate && [self.delegate respondsToSelector:@selector(scrawlViewPaintEnd:)]) {
		[self.delegate scrawlViewPaintEnd:self];
	}
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (rect.size.width == self.bounds.size.width) {
        
        [self drawAllRect:rect];
        
    }else{
        
        [self drawTipRect:rect];
        
    }
    
}

- (void)drawAllRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextClearRect(context , rect);
	
	if (self.isForbidDrawPath) {
		return;
	}
	
	for (CYScrawlPaintPath *path in self.paintPaths) {
		[path paintPathWithContext:context];
	}
	[self.currentPath paintPathWithContext:context];
    
}

- (void)drawTipRect:(CGRect)rect{
    [curImage drawAtPoint:CGPointMake(0, 0)];
    CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
    CGPoint mid2 = midPoint(currentPoint, previousPoint1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];
    
    CGContextMoveToPoint(context, mid1.x, mid1.y);
    CGContextAddQuadCurveToPoint(context, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.currentPaintColor.CGColor);
    
    CGContextStrokePath(context);
}

@end

