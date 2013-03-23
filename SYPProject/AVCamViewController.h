/*
    AVCamViewController.h
    FaXian
 
    Created by liubo on 11-08-31.
    Copyright 2011 __DaTou__. All rights reserved.
*/
#import <UIKit/UIKit.h>
#import <mediaplayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AVCamPreviewView.h"
#import "ISirisView.h"
#import "AppUI.h"
#import "HandleImage.h"

@class AVCamCaptureManager, AVCamPreviewView, AVCaptureVideoPreviewLayer, ISIrisView;

@protocol AVCamViewControllerDelegate;

@interface AVCamViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    id <AVCamViewControllerDelegate> delegate;
    
    int iScaleStyle;
    int iAutoRotate;

    MPVolumeView *iVolumeView;
    UISlider *iScaleSlider;
    UIButton *iButtonslider;
    
    UIButton *devicebutton;
    UIButton *flashbutton;
    float iCurrZoomValue;
    BOOL iEnableVolumeSnap;
    CGPoint iTapPoint;
    CGPoint iDrawRectPoint;
    
    CALayer *focusBox;
    CALayer *exposeBox;
    CGSize iPhotoSize;
    
    NSString *iFileName;
    NSString *iDirPath;
    NSString *iFullFileName;
    TNMInt iUpLoadImageW;
    TNMInt iUpLoadImageH;
    TNMInt iImageType;
    TNMInt iImageQuality;
    UIImage *iImagePrepareToSave;
    
    
    AVCamPreviewView *iVideoPreviewView;
    UIImageView *iBottomBarImageView;
    UIButton *iTakePhotoButton;
    UIButton *iCancelButton;
    
    UIView* iCamview;
    UIView* volumeViewSlider;
    
    id iObserver;
    ISIrisView *irisView_;
    BOOL iBoolStopsessionFnish;
    CGPoint iFocusPoint;
}
@property (nonatomic,retain) AVCamCaptureManager *captureManager;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, retain) ISIrisView *irisView;
#pragma mark Toolbar Actions

- (void) getAVCapturePicture :(const char *)aDirPath :(const char *)aFileName :(TNMInt)aImageType :(TNMInt)aImageQuality :(TNMInt)aImageW :(TNMInt)aImageH :(TNMInt)aScaleStyle :(TNMInt)aAutoRotate;
- (void)captureStillImage;
- (void)returnToBackView;
- (void)handleExternalVolumeChanged;

- (AudioFileID)openAudioFile:(NSString*)filePath;
- (UInt32)audioFileSize:(AudioFileID)fileDescriptor;
- (void)setEnableVolumeSnap:(BOOL)aEnable;
- (void)setAVCamParameter:(const char *)aFileName:(const char *)aDirPath:(int)aImageType:(int)aImageQuality;
- (void)dismissThisViewController;
- (BOOL) switchcamera;
- (void) changeflashstate;
- (void) handleConvertToBitmap:(NSData *)aImageData:(bool)aNeedSwitchView;
- (void) camViewSaveRotateBitmap:(const char *)aFileName:(TNMInt)aRotate:(TNMInt)aQuality;
- (void) saveCurrentImageToAlbum;
- (void) discardCurrentImage;

- (float) getCurrentZoomValue;
- (NSString *) getFullFileName;
- (void) callAnimationForCameraOpen;
- (void) callAnimationForCameraClose;
- (void) setScaleSliderAndButtonHidden;
- (void) setScaleSliderAndButtonShow;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)tapToFocus:(CGPoint)aPoint;
- (void)tapToFocusExpose:(CGPoint)aPoint;
- (void)resetFocusAndExpose;
- (void)setDrawRectPoint:(CGPoint)aPoint;
- (CALayer *)createLayerBoxWithColor:(UIColor *)color;
+ (CGSize)sizeForGravity:(NSString *)gravity frameSize:(CGSize)frameSize apertureSize:(CGSize)apertureSize;
+ (void)addAdjustingAnimationToLayer:(CALayer *)layer removeAnimation:(BOOL)remove;
- (CGPoint)translatePoint:(CGPoint)point fromGravity:(NSString *)gravity1 toGravity:(NSString *)gravity2;
- (void)drawFocusBoxAtPointOfInterest:(CGPoint)point;
- (void)drawExposeBoxAtPointOfInterest:(CGPoint)point;
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates;
@end

