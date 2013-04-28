//
//  RSStroke.h
//  RRSnapCommon
//
//  Created by Apple on 13-1-17.
//  Copyright (c) 2013年 renren. All rights reserved.
//
#import <Foundation/Foundation.h>

/*  画笔
 */
@interface RSStroke : NSObject {
	CGFloat		strokeWidth;
	CGColorRef	strokeColor;
    
    UIBezierPath *path;
}
@property (nonatomic, retain)UIBezierPath	 *path;
@property (nonatomic, assign)CGFloat		strokeWidth;
@property (nonatomic, readwrite)CGColorRef	strokeColor;

- (void)strokeWithContext:(CGContextRef)context;

@end
