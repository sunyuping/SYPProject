//
//  CYImageAVCapture.h
//  CYFilter
//
//  Created by chen yi on 12-12-23.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYCapture.h"


@interface CYImageAVCapture : CYCapture<AVCaptureVideoDataOutputSampleBufferDelegate>
{
	AVCaptureSession *_avCaptureSession;
	AVCaptureDevice *_avCaptureDevice;
	AVCaptureDeviceInput *_videoInput;
	AVCaptureVideoDataOutput *_videoOutput;
	BOOL _firstFrame; //是否为第一帧
}
@property(nonatomic,retain)AVCaptureSession *avCaptureSession;
@property(nonatomic,retain)AVCaptureDevice *avCaptureDevice;
@property(nonatomic,retain)AVCaptureDeviceInput *videoInput;
@property(nonatomic,retain)AVCaptureVideoDataOutput *videoOutput;

- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition;

@end
