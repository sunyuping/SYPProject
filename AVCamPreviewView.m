/*
    File: AVCamPreviewView.m
    FaXian
 
    Created by liubo on 11-08-31.
    Copyright 2011 __DaTou__. All rights reserved.
*/

#import "AVCamPreviewView.h"
@implementation AVCamPreviewView
- (void)drawRect:(CGRect)rect{	
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [[UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:0.8f] CGColor]);
    CGContextSetLineWidth(ctx, 1.5);
    iSelectRect.origin.x = 10;
    iSelectRect.origin.y = 64;
    iSelectRect.size.width = 300;
    iSelectRect.size.height = 300;
    CGContextAddRect(ctx,iSelectRect);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}

@end
