/*
    AVCamCaptureManager.h
    FaXian
 
    Created by liubo on 11-08-31.
    Copyright 2011 __DaTou__. All rights reserved.
*/
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AVCamViewController.h"
@protocol AVCamCaptureManagerDelegate;

@interface AVCamCaptureManager : NSObject {
    bool canCapture;
    AVCaptureConnection * iStillImageConnection;
}

@property (nonatomic,retain) AVCaptureSession *session;
@property (nonatomic,assign) AVCaptureVideoOrientation orientation;
@property (nonatomic,retain) AVCaptureDeviceInput *videoInput;
@property (nonatomic,retain) AVCaptureDeviceInput *audioInput;
@property (nonatomic,retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic,assign) id deviceConnectedObserver;
@property (nonatomic,assign) id deviceDisconnectedObserver;
@property (nonatomic,assign) UIBackgroundTaskIdentifier backgroundRecordingID;
@property (nonatomic,assign) id <AVCamCaptureManagerDelegate> delegate;

- (BOOL) setupSession:(CGSize *)aSize;
- (void) captureStillImage;
- (NSUInteger) cameraCount;
- (BOOL) switchcamera;
- (void) changeflashstate:(UIButton *)flashbutton;
- (void) focusAtPoint:(CGPoint)point;
- (void) exposureAtPoint:(CGPoint)point;
- (BOOL) hasFocus;
- (BOOL) hasExposure;
- (void) setFocusMode:(AVCaptureFocusMode)focusMode;
- (void) avControllerServerHasDied;
@end

// These delegate methods can be called on any arbitrary thread. If the delegate does something with the UI when called, make sure to send it to the main thread.
@protocol AVCamCaptureManagerDelegate <NSObject>
@optional
- (void) captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error;
- (void) captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager;
- (UIImage *) captureManagerWriteImage:(UIImage *)aImage:(NSString *)aDirPath:(NSString *)aFileName;
- (void)switchViewToScript;
+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType fromConnections:(NSArray *)connections;
@end
