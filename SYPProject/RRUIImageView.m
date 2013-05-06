//
//  RRUIImageView.m
//  RRSpring
//
//  Created by 玉平 孙 on 12-3-12.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "RRUIImageView.h"
#import <CommonCrypto/CommonDigest.h>

@implementation RRUIImageView
@synthesize imageView=_imageView; 
@synthesize indicator=_indicator;
@synthesize canMove = _canMove;
-(void)dealloc{
    [super dealloc];
    [_imageEngine release];
    [_imageView release];
    [_indicator release];
}
-(void)initMemberVariables{
    _imageEngine = [MKNetworkEngine alloc];
    [_imageEngine useCache];
    _imageView = [[UIImageView alloc] init];  
    self.clipsToBounds=YES;
    [self addSubview:_imageView]; 
    self.imageView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.indicator = [[[UIActivityIndicatorView alloc] initWithFrame:self.bounds] autorelease];  
    [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];  
    [self addSubview:self.indicator];
    self.imageView.contentMode = UIViewContentModeScaleToFill;  
    self.imageView.frame = self.bounds; 
    _canSetPosition = NO;
    _canMove=NO;
}
- (id)initWithCoder:(NSCoder*) coder{
    self = [super initWithCoder:coder];
    if (self) {  
        // Initialization code.  
        [self initMemberVariables];
    }  
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        [self initMemberVariables];
    }
    return self;
}
- (void)setImage:(UIImage*)image{
    [self.imageView setImage:image];
    [self.imageView setNeedsLayout];
}
- (void) LoadImageWithUrl:(NSString *) strURL isNeedRefash:(BOOL) force{
    if (strURL == nil) {
        
        return;
    }
    if (!force) {
        [_imageEngine useCache];
    }
    MKNetworkOperation *op = [_imageEngine operationWithURLString:strURL];
    [op onCompletion:^(MKNetworkOperation *completedOperation)
     {
         [self.indicator stopAnimating];
//         if ([completedOperation isCachedResponse]) {
//             [self.imageView setImage:[completedOperation responseImage]];
//             
//             // [self.imageView setNeedsLayout];  
//         }else{
//             [self.imageView setImage:[completedOperation responseImage]];
//         }
         UIImage *netimage = [completedOperation responseImage];
         [self.imageView setImage:netimage];
         if(_canSetPosition){
            // UIImage *changeimage=[netimage stretchableImageWithLeftCapWidth:self.bounds.size.width topCapHeight:0];
             CGSize imagesize = netimage.size;
             float height = self.bounds.size.width*imagesize.height/imagesize.width;
             curr_X = -imagesize.width*_leftPoint;
             curr_Y = -height*_topPoint;
             self.imageView.frame = CGRectMake(curr_X, curr_Y, self.bounds.size.width, height);
             [self.imageView setNeedsLayout];
             _canSetPosition=NO;
         }
         
     }
             onError:^(NSError* error) {
                 
             }];    
    [self.indicator startAnimating];
    [_imageEngine enqueueOperation:op];
    
    [op onDownloadProgressChanged:^(double progress) {
        //实现实时监控图片下载进度，可以利用这个实现加载前的动画
        NSLog(@"syp======change===%f",progress);
    }];
    
    
}

- (void) LoadImageWithUrl:(NSString *) strURL  
{  
    [self LoadImageWithUrl:strURL isNeedRefash:NO];
}
- (void)setImageWithUrl:(NSString*)url{
    if (url == nil) {
        return;
    }
    [self LoadImageWithUrl:url];
}
-(void)setImageViewShowPosition:(float)topPercentage left:(float)leftPercentage{
    _canSetPosition = YES;
    _topPoint = topPercentage;
    _leftPoint = leftPercentage;
    if (self.imageView.image) {
        CGSize imagesize = self.imageView.image.size;
        float height = self.bounds.size.width*imagesize.height/imagesize.width;
        curr_X = -imagesize.width*_leftPoint;
        curr_Y = -height*_topPoint;
        self.imageView.frame = CGRectMake(curr_X, curr_Y, self.bounds.size.width, height);
        [self.imageView setNeedsLayout];
        _canSetPosition=NO;
        
    }
}
//在这里我们做了一个简单的判断，只有手指移动了超过一定像素（min_offset常量）后，才识别为拖动手势，
//并调用moveToX方法。在这个方法中，需要不断的更新手指移动的坐标，因为这是一个连续的过程。
-(void)moveToX:(CGFloat)x ToY:(CGFloat)y
{
    if (!_canMove) {
        return;
    }
    //因为cover暂时只处理上下移动所以屏蔽掉x的移动
    x=0;
    //计算移动后的矩形框，原点x,y坐标，矩形宽高
    CGFloat destX,destY,destW,destH;
    curr_X=destX=curr_X+x;
    curr_Y=destY=curr_Y+y;
    destW=self.imageView.frame.size.width;
    destH=self.imageView.frame.size.height;
    //左边界越界处理
    if(destX>0) {
        curr_X=destX=0;
    }
    //上边界越界处理
    if(destY>0) {
        curr_Y=destY=0;
    }
    //下边界越界处理
    if (curr_Y < self.bounds.size.height - self.imageView.frame.size.height ) {
        curr_Y = self.bounds.size.height - self.imageView.frame.size.height;
    }
    //右边界处理
    if (curr_X < self.bounds.size.width - self.imageView.frame.size.width ) {
        curr_X = self.bounds.size.width - self.imageView.frame.size.width;
    }
    CGRect imageMovefram = self.imageView.frame;
    imageMovefram.origin.y = curr_Y;
    self.imageView.frame = imageMovefram;
}
//记录下手指第一次触摸的位置。因为任何一个拖动都必然有一个起点和终点。
-(void)touchesBegan:(NSSet *)touches 
          withEvent:(UIEvent *)event
{
    NSLog(@"syp===touchesBegan");
    UITouch *touch=[touches anyObject];
    gestureStartPoint=[touch locationInView:self];
    //NSLog(@”touch:%f,%f”,gestureStartPoint.x,gestureStartPoint.y);
}

//然后是手指移动后回调的touchesMoved方法：
-(void)touchesMoved:(NSSet *)touches 
          withEvent:(UIEvent *)event
{
    NSLog(@"syp===touchesMoved");
    UITouch* touch=[touches anyObject];
    CGPoint curr_point=[touch locationInView:self];
    //分别计算x，和y方向上的移动
    offsetX=curr_point.x-gestureStartPoint.x;
    offsetY=curr_point.y-gestureStartPoint.y;
    //只要在任一方向上移动的距离超过Min_offset,判定手势有效
    if(fabsf(offsetY)>=2)
    {
        [self moveToX:offsetX ToY:offsetY];
        gestureStartPoint.x=curr_point.x;
        gestureStartPoint.y=curr_point.y;
    }
}
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"syp===beginTrackingWithTouch");
    if (_canMove) {
        return NO;
    }
    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"syp===continueTrackingWithTouch");
    if (_canMove) {
        return NO;
    }
    return YES;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

//在程序中如何把两张图片合成为一张图片   
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 {  
    UIGraphicsBeginImageContext(image1.size);  
    // Draw image1  
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];  
    // Draw image2  
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];  
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    return [resultingImage autorelease];  
}
@end
