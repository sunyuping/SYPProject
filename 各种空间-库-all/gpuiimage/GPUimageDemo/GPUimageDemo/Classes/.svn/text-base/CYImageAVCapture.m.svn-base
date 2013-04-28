//
//  CYImageAVCapture.m
//  CYFilter
//
//  Created by chen yi on 12-12-23.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYImageAVCapture.h"
#import <CoreMedia/CoreMedia.h>

NSString* const kCYImageAVCaptureResult = @"kCYImageAVCaptureResult";

@interface  CYImageAVCapture()
{
	dispatch_queue_t cameraProcessingQueue;
	AVCaptureStillImageOutput *_photoOutput;
	AVCaptureVideoPreviewLayer* previewLayer;
}
@property(nonatomic,retain)AVCaptureStillImageOutput *photoOutput;

@end


@implementation  CYImageAVCapture

@synthesize previewView = _previewView;

@synthesize avCaptureDevice = _avCaptureDevice;
@synthesize avCaptureSession = _avCaptureSession;
@synthesize videoInput = _videoInput;
@synthesize videoOutput = _videoOutput;
@synthesize photoOutput = _photoOutput;

- (void)dealloc{
	[self.avCaptureSession stopRunning];
	self.avCaptureSession = nil;
	self.avCaptureDevice = nil;
	self.videoInput = nil;
	self.videoOutput = nil;
	self.photoOutput = nil;
	[previewLayer release];
	dispatch_release(cameraProcessingQueue);
	
	[super dealloc];
}

- (AVCaptureDevice *)getCameraDevice:(AVCaptureDevicePosition)cameraPosition
{
	//获取前置摄像头设备
	NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameras)
	{
        if (device.position == cameraPosition)
            return device;
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}

- (void)setPreviewView:(UIView *)previewView{
	
	[previewView retain];
	[_previewView release];
	_previewView = previewView;
	
	previewLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.avCaptureSession];
	previewLayer.frame = _previewView.bounds;
	previewLayer.videoGravity= AVLayerVideoGravityResizeAspectFill;
	
	[_previewView.layer insertSublayer:previewLayer atIndex: 0];
}

- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition{
	self = [super init];
	if (self) {
		
		
		_avCaptureDevice = [self getCameraDevice:cameraPosition];
//		NSAssert(_avCaptureDevice, @"相机初始化失败");
		
		//input
		NSError *error = nil;
		self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.avCaptureDevice error:&error];
		if (!_videoInput || error)
		{
 			self.avCaptureDevice= nil;
		}

		_avCaptureSession = [[AVCaptureSession alloc]init];
		_avCaptureSession.sessionPreset = sessionPreset;

		//output 
		_videoOutput = [[AVCaptureVideoDataOutput alloc]init];
		[_videoOutput setVideoSettings:[NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithInt:kCVPixelFormatType_32BGRA],(id)kCVPixelBufferPixelFormatTypeKey,
										[NSNumber numberWithFloat:640],AVVideoWidthKey,
										[NSNumber numberWithFloat:960],AVVideoHeightKey,nil]];
		_photoOutput = [[AVCaptureStillImageOutput alloc]init];
		[_photoOutput setOutputSettings:[NSDictionary dictionaryWithObject:AVVideoCodecJPEG
																		forKey:AVVideoCodecKey]];
		
		[_avCaptureSession beginConfiguration];
		
		if ([_avCaptureSession canAddInput:_videoInput]) {
			[_avCaptureSession addInput:_videoInput];
		}
		if ([_avCaptureSession canAddOutput:_photoOutput]) {
			[_avCaptureSession addOutput:_photoOutput];
		}
		if ([_avCaptureSession canAddOutput:_videoOutput]) {
			[_avCaptureSession addOutput:_videoOutput];
		}
		[_avCaptureSession commitConfiguration];
				
		cameraProcessingQueue =  dispatch_queue_create("CYImagePickerController.cameraProcessingQueue", NULL);
		[_videoOutput setSampleBufferDelegate:self queue:cameraProcessingQueue];
	}
	
	return self;
}


//开始采集
- (void)startCameraCapture{
	if (self.delegate && [self.delegate respondsToSelector:@selector(cyCaptureWillBeginCapture)]) {
		[self.delegate cyCaptureWillBeginCapture];
	}

	[self.avCaptureSession startRunning];
}

//暂停采集
- (void)pauseCameraCapture{
	
}

- (void)captureToGetResult{
	
	[_photoOutput captureStillImageAsynchronouslyFromConnection:[[self.photoOutput connections]objectAtIndex:0]
											  completionHandler:
	 ^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
		 
 
		 UIImage * resultImage; // = [self imageFromSampleBuffer:imageDataSampleBuffer];
 
		 NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
		 resultImage = [UIImage imageWithData:imageData];
 		 NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
		 [resultDic setValue: resultImage forKey:kCYImageAVCaptureResult];
		 
		 if (self.delegate && [self.delegate respondsToSelector:@selector(cyCaptureDidEndCapture:)]) {
			 [self.delegate cyCaptureDidEndCapture:resultDic];
		 }
	 }];
}

- (UIImage *)imageFromLayer:(CALayer *)layer
{
	UIGraphicsBeginImageContext([layer frame].size);
	
	[layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return outputImage;
}

//停止采集
- (void)stopCameraCapture
{
	[self.avCaptureSession stopRunning];
	
}

//旋转摄像头
- (void)rotateCamera
{
	AVCaptureDevicePosition currentCameraPosition = [self.avCaptureDevice  position];
    
    if (currentCameraPosition == AVCaptureDevicePositionBack){
        currentCameraPosition = AVCaptureDevicePositionFront;
    }
    else{
        currentCameraPosition = AVCaptureDevicePositionBack;
    }
	
	AVCaptureDevice *newDevice = [self getCameraDevice:currentCameraPosition];
	self.avCaptureDevice = newDevice;

	NSError *error = nil;
	AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.avCaptureDevice error:&error];

	if(newVideoInput){
		
		[_avCaptureSession beginConfiguration];
		
		[_avCaptureSession removeInput:self.videoInput];
		if ([_avCaptureSession canAddInput:newVideoInput]) {
 			self.videoInput = newVideoInput;
			[_avCaptureSession addInput:newVideoInput];
		}else{
			[_avCaptureSession addInput:self.videoInput];
		}
		
		[_avCaptureSession  commitConfiguration];
	}
	
	[newVideoInput release];
}
@end
