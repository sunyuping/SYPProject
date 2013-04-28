//
//  CYScrawPaintPath.h
//  CYFilter
//
//  Created by chen yi on 12-12-21.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYScrawlPaintPath : NSObject<NSCopying>
{
	NSMutableArray *_paintPoints;
	
	UIColor *_pathColor;
}

@property(nonatomic,strong)NSMutableArray *paintPoints;
@property(nonatomic,strong)UIColor *pathColor;

- (void)addPaintPoint:(CGPoint)point;

- (BOOL)isNeedToPaintLine;

- (void)paintPathWithContext:(CGContextRef)context;
@end