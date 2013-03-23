//
//  THCapture.h
//  SYPProject
//
//  Created by sunyuping on 12-10-29.
//
//

#import <Foundation/Foundation.h>
#import "THCaptureUtilities.h"

@protocol THCaptureDelegate;
@interface THCapture : NSObject{
    //video writing
	AVAssetWriter *videoWriter;
	AVAssetWriterInput *videoWriterInput;
	AVAssetWriterInputPixelBufferAdaptor *avAdaptor;
    
    //recording state
	BOOL           _recording;     //正在录制中
    BOOL           _writing;       //正在将帧写入文件
	NSDate         *startedAt;     //录制的开始时间
    CGContextRef   context;        //绘制layer的context
    NSTimer        *timer;         //按帧率写屏的定时器
    
    //Capture Layer
    CALayer *_captureLayer;              //要绘制的目标layer
    NSUInteger  _frameRate;              //帧速
    id<THCaptureDelegate> _delegate;     //代理
}
@property(assign) NSUInteger frameRate;
@property(nonatomic, assign) CALayer *captureLayer;
@property(nonatomic, assign) id<THCaptureDelegate> delegate;

//开始录制
- (bool)startRecording;
//结束录制
- (void)stopRecording;

@end


@protocol THCaptureDelegate <NSObject>

- (void)recordingFinished:(NSString*)outputPath;
- (void)recordingFaild:(NSError *)error;

@end