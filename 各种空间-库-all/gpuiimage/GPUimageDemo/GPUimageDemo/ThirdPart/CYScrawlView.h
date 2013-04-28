//
//  CYScrawlView.h
//  CYFilter
//
//  Created by chen yi on 12-12-21.
//  Copyright (c) 2012年 renren. All rights reserved.
//


#import <UIKit/UIKit.h>
//for gl
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
//CONSTANTS:
#define kBrushOpacity		1.0
#define kBrushPixelStep		2    // 原来是64*64的纹理图，然后是3的步距
#define kBrushScale			5
#define kLuminosity			1.00    //亮度
#define kSaturation			1.0     //饱和度


@protocol CYScrawlViewDelegate;
@class CYScrawlPaintPath;

/*
	涂鸦层
 */
@interface CYScrawlView : UIView
{
    UIColor *_currentPaintColor;
	id<CYScrawlViewDelegate> _delegate;
    
@private
    CGPoint currentPoint;
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGFloat lineWidth;
    UIColor *lineColor;
    UIImage *curImage;
    
}
@property (nonatomic, retain) UIColor *lineColor;
@property (readwrite) CGFloat lineWidth;

@property(nonatomic,strong)NSMutableArray *paintPaths;

@property(nonatomic,strong)CYScrawlPaintPath *currentPath;

@property (nonatomic,strong)UIColor *currentPaintColor;

@property (nonatomic,assign)id<CYScrawlViewDelegate> delegate;

@property (nonatomic,assign)BOOL isForbidDrawPath;

- (void)rollbackLastPaintPath;

/*  最后一笔的颜色
 */
- (UIColor *)lastPathColor;

/*	清除所有的画笔路径
 */
- (void)removeAllPaintPath;

/*	获取当前涂鸦的图片
 */
- (UIImage *)imageFromCurrentPaintPath;

/*	从另外一个涂鸦拷贝路径，并重绘制
 */
- (void)copyFromScrawlView:(CYScrawlView * )view ;

/*	绘画内容是否为空
 */
- (BOOL)isDrawPathEmpty;

@end

@protocol CYScrawlViewDelegate <NSObject>

@optional

- (void)scrawlViewPaintBegain:(CYScrawlView *)scrawlView;

- (void)scrawlViewPaintEnd:(CYScrawlView *)scrawView;

- (void)scrawlViewPaintMove:(CYScrawlView *)scrawView;

- (UIView * )viewCovertToDrawPoint:(CYScrawlView *)scrawlView;

@end