//
//  CYCapture.h
//  CYFilter
//
//  Created by chen yi on 12-12-23.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define CYCapture_USE_GPUIMAGE     //使用GPUImage库采集
#define CYCapture_USE_AVFOUNDATION //使用AVFoundation库采集


extern NSString* const kCYImageAVCaptureResult;

@protocol CYCaptureDelegate;

@interface CYCapture : NSObject
{
 
}

@property(nonatomic,assign)BOOL isCaptureing;
@property(nonatomic,retain)UIView *previewView;
@property(nonatomic,assign)id<CYCaptureDelegate>delegate;

//开始采集
- (void)startCameraCapture;

//暂停采集
- (void)pauseCameraCapture;

//采集结束，得到结果
- (void)captureToGetResult;

//停止采集
- (void)stopCameraCapture;

//旋转摄像头
- (void)rotateCamera;
@end


@protocol CYCaptureDelegate <NSObject>

@optional

//是否支持点击自动对焦
- (BOOL)cyCaptureShouldAutoFocusCameraWhenTapPreviewView;

//开始采集回掉
- (void)cyCaptureWillBeginCapture;

//采集完毕数据回掉
- (void)cyCaptureDidEndCapture:(NSDictionary *)captureResultDic;


@end