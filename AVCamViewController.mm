/*
    AVCamViewController.m
    FaXian

    Created by liubo on 11-08-31.
    Copyright 2011 __DaTou__. All rights reserved.
*/

#import "AVCamViewController.h"
#import "AVCamCaptureManager.h"

#import "HybrowserViewController.h"
#import "HybrowserAppDelegate.h"

#include "NMService.h"
#include "NMAutoreleasePool.h"
#include "SkImageEncoder.h"


@interface AVCamViewController (InternalMethods)
- (void)updateButtonStates;
@end

@interface AVCamViewController (AVCamCaptureManagerDelegate) <AVCamCaptureManagerDelegate>
@end

@implementation AVCamViewController
@synthesize captureManager;
@synthesize captureVideoPreviewLayer;
@synthesize irisView = irisView_;
- (void)dealloc{
    if(iObserver)
    {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter removeObserver:iObserver name:AVCaptureSessionDidStartRunningNotification object:nil];
        iObserver = nil;
    }

    if (iFileName){
        [iFileName release];
        iFileName = NULL;
    }
    if (iDirPath){
        [iDirPath release];
        iDirPath = NULL;
    }
    if (iButtonslider){
        [iButtonslider release];
        iButtonslider = NULL;
    }
    if (iScaleSlider){
        [iScaleSlider release];
        iScaleSlider = NULL;
    }
    if (iTakePhotoButton){
        [iTakePhotoButton release];
        iTakePhotoButton = NULL;
    }
    if (iCancelButton){
        [iCancelButton release];
        iCancelButton=NULL;
    }
    if (iFullFileName){
        [iFullFileName release];
        iFullFileName=NULL;
    }
    if (iBottomBarImageView){
        [iBottomBarImageView release];
        iBottomBarImageView=NULL;
    }
    [focusBox release];
    [exposeBox release];
    [iVolumeView release];
	[captureManager release];
    [iVideoPreviewView release];
	[captureVideoPreviewLayer release];
//	NSLog(@"captureVideoPreviewLayer.retaincount:%d",[captureVideoPreviewLayer retainCount]);
    
    [super dealloc];
}

- (void)viewDidLoad{
    if ([self captureManager] == nil) {
		AVCamCaptureManager *manager = [[AVCamCaptureManager alloc] init];
		[self setCaptureManager:manager];
		[manager release];
		
		[[self captureManager] setDelegate:self];
        
		if ([[self captureManager] setupSession:&iPhotoSize]) {
			AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[[self captureManager] session]];
            
            // Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
			/*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[[[self captureManager] session] startRunning];
			});
            */
//			AVCamPreviewView *view = [self videoPreviewView];

            //initWithFrame
            iVideoPreviewView = [[AVCamPreviewView alloc] initWithFrame:CGRectMake(0, 0, 320, 428)];
            [iVideoPreviewView setBackgroundColor:[UIColor clearColor]];
			[self.view addSubview:iVideoPreviewView];
            [iVideoPreviewView release];
            
            AVCamPreviewView *camview = [[[AVCamPreviewView alloc] initWithFrame:CGRectMake(0, 0, 320, 428)] autorelease];
            [camview setBackgroundColor:[UIColor clearColor]];
			[self.view addSubview:camview];
            
			CALayer *viewLayer = [iVideoPreviewView layer];
			[viewLayer setMasksToBounds:YES];
            
			CGRect bounds = [iVideoPreviewView bounds];
			[newCaptureVideoPreviewLayer setFrame:bounds];
			
			if ([newCaptureVideoPreviewLayer isOrientationSupported]) {
				[newCaptureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
			}
			
			[newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
			
			[viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
			
			[self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
            [newCaptureVideoPreviewLayer release];
			
            [self updateButtonStates];
            
            [[MPMusicPlayerController applicationMusicPlayer] beginGeneratingPlaybackNotifications];
            iVolumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(0, 480, 320, 40)]; 
            [self.view addSubview:iVolumeView]; 
            [iVolumeView release];
            //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleExternalVolumeChanged:) name:MPMusicPlayerControllerVolumeDidChangeNotification object:nil];          
//            NSString *filename = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"caf"];
//            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filename]; 
//            AVAudioPlayer *Player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
//            [Player prepareToPlay];
            
            iBottomBarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 416, 320, 64)];
            [iBottomBarImageView setImage:[UIImage imageNamed:@"BottomBar.png"]];
            [self.view addSubview:iBottomBarImageView];
            [iBottomBarImageView release];
            
            iCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 438, 41, 33)];
            [iCancelButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
            [iCancelButton addTarget:self action:@selector(returnToBackView) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:iCancelButton];
            [iCancelButton release];
            
            iTakePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 433, 101, 42)];
            [iTakePhotoButton addTarget:self action:@selector(captureStillImage) forControlEvents:UIControlEventTouchUpInside];
            [iTakePhotoButton setImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
            [self.view addSubview:iTakePhotoButton];
            [iTakePhotoButton release];
            
            iButtonslider = [[UIButton alloc] initWithFrame:CGRectMake(0, 380, 320, 30)];
            [iButtonslider setImage:[UIImage imageNamed:@"iphone_photo_zoom.png"] forState:UIControlStateNormal];
            [iButtonslider setEnabled:YES];
            [iButtonslider setHidden:YES];
            
            iScaleSlider = [[UISlider alloc] initWithFrame:CGRectMake(42, 380, 236, 30)];
            [iScaleSlider setMinimumValue:1.0];
            [iScaleSlider setMaximumValue:6.0];
            [iScaleSlider setBackgroundColor:[UIColor clearColor]];
            UIImage *stetchTrack = [[UIImage imageNamed:@"iphone_photo_track.png"]
                                    stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
            [iScaleSlider setThumbImage:[UIImage imageNamed:@"iphone_photo_knob.png"] forState:UIControlStateNormal];
            [iScaleSlider setMinimumTrackImage:stetchTrack forState:UIControlStateNormal];
            [iScaleSlider setMaximumTrackImage:stetchTrack forState:UIControlStateNormal];
            [iScaleSlider setContinuous:YES];
            [iScaleSlider setHidden:YES];
            [iScaleSlider addTarget:self action:@selector(iScaleSliderOnValueChanged) forControlEvents:UIControlEventValueChanged];
            [self.view addSubview:iButtonslider];
            [self.view addSubview:iScaleSlider]; 
            [iButtonslider release];
            [iScaleSlider release];
            iCurrZoomValue = 1.0;
            
            BOOL hasfrontcamera =false;
            NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            for (AVCaptureDevice *device in devices) {
                if ([device position] == AVCaptureDevicePositionFront) {
                    hasfrontcamera = true;
                }
            }
            if (hasfrontcamera) {    
                devicebutton = [[UIButton alloc] initWithFrame:CGRectMake(245, 10, 69, 36)];
                [devicebutton addTarget:self action:@selector(switchcamera) forControlEvents:UIControlEventTouchUpInside];
                [devicebutton setBackgroundImage:[UIImage imageNamed:@"iphone_photo_switch.png"] forState:UIControlStateNormal];
                devicebutton.backgroundColor = [UIColor clearColor];
                devicebutton.alpha = 0.8;
                [self.view addSubview:devicebutton];
                [devicebutton release];
                
                flashbutton = [[UIButton alloc] initWithFrame:CGRectMake(6, 10, 84, 36)];
                [flashbutton addTarget:self action:@selector(changeflashstate) forControlEvents:UIControlEventTouchUpInside];
                [flashbutton setImage:[UIImage imageNamed:@"iphone_flash_off.png"] forState:UIControlStateNormal];
                flashbutton.backgroundColor = [UIColor clearColor];
                flashbutton.alpha = 0.8;
                [self.view addSubview:flashbutton];
                [flashbutton release];
            }
            //if ([[captureManager session] isRunning]){
                
                focusBox = [self createLayerBoxWithColor:[UIColor colorWithRed:0.93f green:1.0f blue:1.0f alpha:1.0f]];                
                [[[self view] layer] addSublayer:focusBox];
                [focusBox retain];
                
                exposeBox = [self createLayerBoxWithColor:[UIColor colorWithRed:0.93f green:1.0f blue:1.0f alpha:1.0f]]; 
                [[[self view] layer] addSublayer:exposeBox];
                [exposeBox retain];
                
                [captureManager setOrientation:AVCaptureVideoOrientationPortrait];
                [captureManager setDelegate:self];
                
                [viewLayer insertSublayer:captureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
            /*}
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                    message:@"Failed to start session."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Okay"
                                                          otherButtonTitles:nil];
                [alertView show];
                [alertView release];                
            }
            */
            [self.view bringSubviewToFront: self.irisView];
		}
        
        
        void (^carmeraInitComplete)(NSNotification *) = ^(NSNotification *notification) {
			//AVCaptureDevice *device = [notification object];
			//[self callAnimationForCameraOpen];
            // NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            //[notificationCenter removeObserver:iObserver name:AVCaptureSessionDidStartRunningNotification object:nil];
            //iObserver = nil;
            //[self resetFocusAndExpose];
            
            //[self performSelectorOnMainThread:@selector(callAnimationForCameraOpen) withObject:nil waitUntilDone:YES];
             //NSLog(@"carmeraInitComplete");
        };
       
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        iObserver = [notificationCenter addObserverForName:AVCaptureSessionDidStartRunningNotification object:nil queue:nil usingBlock:carmeraInitComplete];
             
	}	
    ISIrisView *irisView = [[ISIrisView alloc] initWithFrame:CGRectMake(0, 0, 320, 428)];
    self.irisView = irisView;
    [self.view addSubview:irisView];
    [irisView release];
 //   [self callAnimationForCameraOpen];   
    
    iUpLoadImageW = 621;
 	iUpLoadImageH = 621;
    iBoolStopsessionFnish = TRUE;
    [super viewDidLoad];
}


- (void)viewDidUnload{
    
    HybrowserAppDelegate* maindelegate = (HybrowserAppDelegate*)[[UIApplication sharedApplication] delegate] ;
    maindelegate.iVolumeObserver = nil;
    if(iObserver)
    {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter removeObserver:iObserver name:AVCaptureSessionDidStartRunningNotification object:nil];
        iObserver = nil;
    }
    
    if (iFileName){
        [iFileName release];
        iFileName = NULL;
    }
    if (iDirPath){
        [iDirPath release];
        iDirPath = NULL;
    }
    if (iButtonslider){
        [iButtonslider release];
        iButtonslider = NULL;
    }
    if (iScaleSlider){
        [iScaleSlider release];
        iScaleSlider = NULL;
    }
    if (iTakePhotoButton){
        [iTakePhotoButton release];
        iTakePhotoButton = NULL;
    }
    if (iCancelButton){
        [iCancelButton release];
        iCancelButton=NULL;
    }
    if (iFullFileName){
        [iFullFileName release];
        iFullFileName=NULL;
    }
    if (iBottomBarImageView){
        [iBottomBarImageView release];
        iBottomBarImageView=NULL;
    }
    [focusBox release];
    [exposeBox release];
    [iVolumeView release];
	[captureManager release];
    [iVideoPreviewView release];
	[captureVideoPreviewLayer release];
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"avcontroller didReceiveMemoryWarning");
}
- (void) setStopSessionFlag{
    iBoolStopsessionFnish = TRUE;
}
- (void) sessionStartRunning{
// NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    if([[captureManager session] isRunning] == FALSE){
        [[captureManager session] startRunning];
        [self callAnimationForCameraOpen];
        [self resetFocusAndExpose];
        [iVolumeView setHidden:NO];
        [iTakePhotoButton setEnabled:YES];
        [self setEnableVolumeSnap:TRUE];
/*    }else{
        [iTakePhotoButton setEnabled:YES];
        [self setEnableVolumeSnap:TRUE];
    }
*/
//  [pool release];
}
- (void) sessionStopRunning{
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [[captureManager session] stopRunning];
    [self performSelector:@selector(setStopSessionFlag) withObject:Nil afterDelay:3.0];
    //[pool release];
}
- (void)viewDidAppear:(BOOL)animated{
    [iTakePhotoButton setEnabled:NO];
    if (iBoolStopsessionFnish == TRUE && ([[captureManager session] isRunning] == FALSE)){
        //[[captureManager session] startRunning];
        [self performSelector:@selector(sessionStartRunning) withObject:Nil afterDelay:0.1];
    }else if ([[captureManager session] isRunning]){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(sessionStopRunning) object:nil];
        [[self irisView] setStatisIrisViewShown:NO];
        [iVolumeView setHidden:NO];
        [iTakePhotoButton setEnabled:YES];
        [self setEnableVolumeSnap:TRUE];
        iBoolStopsessionFnish=TRUE;
    }else{
        [self performSelector:@selector(sessionStartRunning) withObject:Nil afterDelay:3.0];
        iBoolStopsessionFnish=TRUE;
    }
    HybrowserAppDelegate* maindelegate = (HybrowserAppDelegate*)[[UIApplication sharedApplication] delegate] ;
    maindelegate.iVolumeObserver = self;
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    HybrowserAppDelegate* maindelegate = (HybrowserAppDelegate*)[[UIApplication sharedApplication] delegate] ;
    
    maindelegate.iVolumeObserver = nil;
    
    if(iObserver)
    {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter removeObserver:iObserver name:AVCaptureSessionDidStartRunningNotification object:nil];
        iObserver = nil;
    } 
    [iVolumeView setHidden:YES];
    [self setEnableVolumeSnap:FALSE];
    [super viewDidDisappear:animated];
}
- (void) getAVCapturePicture :(const char *)aDirPath :(const char *)aFileName :(TNMInt)aImageType :(TNMInt)aImageQuality :(TNMInt)aImageW :(TNMInt)aImageH :(TNMInt)aScaleStyle :(TNMInt)aAutoRotate{
 	iImageType = aImageType;
 	iImageQuality = aImageQuality;
 	iUpLoadImageW = 621;
 	iUpLoadImageH = 621;
 	iScaleStyle = aScaleStyle;
 	iAutoRotate = aAutoRotate;
    if (iDirPath){
        [iDirPath release];
        iDirPath=NULL;
    }
    iDirPath = [[NSString alloc] initWithUTF8String:aDirPath];
    if (iFileName){
        [iFileName release];
        iFileName=NULL;
    }
 	iFileName = [[NSString alloc] initWithUTF8String:aFileName];
    
    if (iFullFileName){
        [iFullFileName release];
        iFullFileName=NULL;
    }
    iFullFileName = [iDirPath stringByAppendingString:iFileName];
    [iFullFileName retain];
    [[UIApplication sharedApplication] setStatusBarHidden:YES]; 
  
}
-(AudioFileID)openAudioFile:(NSString*)filePath  {  
    AudioFileID outAFID;      
    NSURL * afUrl = [NSURL fileURLWithPath:filePath]; 
#if TARGET_OS_IPHONE   
    OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, kAudioFileReadPermission, 0, &outAFID);  
#else  
    OSStatus result = AudioFileOpenURL((CFURLRef)afUrl, fsRdPerm, 0, &outAFID);  
#endif     
    if (result != 0)
        NSLog(@"cannot openf file: %@",filePath);  
    
    return outAFID;  
}
-(UInt32)audioFileSize:(AudioFileID)fileDescriptor  {  
    UInt64 outDataSize = 0;    
    UInt32 thePropSize = sizeof(UInt64);   
    OSStatus result = AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outDataSize);  
    if(result != 0)
        NSLog(@"cannot find file size");   
    
    return (UInt32)outDataSize;  
}
- (void)iScaleSliderOnValueChanged{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    TNMFloat newvalue = [iScaleSlider value];
    if (iVideoPreviewView){
        iVideoPreviewView.transform=CGAffineTransformScale(iVideoPreviewView.transform, newvalue/iCurrZoomValue, newvalue/iCurrZoomValue);
        iCurrZoomValue=newvalue;
    }
    [self performSelector:@selector(setScaleSliderAndButtonHidden) withObject:Nil afterDelay:5];
}
- (void)setAVCamParameter:(const char *)aFileName:(const char *)aDirPath:(int)aImageType:(int)aImageQuality{
    if (iFileName){
        [iFileName release];
        iFileName = NULL;
    }
    iFileName = [[NSString alloc] initWithUTF8String:aFileName];
    if (iDirPath){
        [iDirPath release];
        iDirPath = NULL;
    }
    iDirPath = [[NSString alloc] initWithUTF8String:aDirPath];
    iImageType=aImageType;
    iImageQuality= aImageQuality;
}
- (void)setEnableVolumeSnap:(BOOL)aEnable{
    iEnableVolumeSnap=aEnable;	
}
- (void)handleExternalVolumeChanged{
    if(iEnableVolumeSnap==TRUE){
        [self captureStillImage];
    }
 }
- (void)returnToBackView{
    iBoolStopsessionFnish=FALSE;
    [self performSelector:@selector(sessionStopRunning) withObject:Nil afterDelay:10.0];
    //[NSThread detachNewThreadSelector:@selector(sessionStopRunning) toTarget:self withObject:nil];
    //[self performSelector:@selector(setStopSessionFlag) withObject:Nil afterDelay:2.5];
    [[self irisView] setStatisIrisViewShown:YES];
    [self dismissThisViewController];
    if (CABAppUI::Instance()){
        CABAppUI::Instance()->NotifyActivityResult(1, -3, nil, 1000, nil, 0);
    }
}
-(void)dismissThisViewController{
    //NSLog(@"dismissThisViewController");
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self setEnableVolumeSnap:FALSE];
    [self dismissModalViewControllerAnimated:NO];
}
- (BOOL) switchcamera{
    [[self captureManager] switchcamera];
    return TRUE;
}
- (void) changeflashstate{
    [[self captureManager] changeflashstate:flashbutton];
}

- (void)captureStillImage{
    if ([[captureManager session] isRunning]){
        [iTakePhotoButton setEnabled:NO];
        [self setEnableVolumeSnap:FALSE];
        [self callAnimationForCameraClose];
        [[self captureManager] captureStillImage];
    }
}
- (void)setScaleSliderAndButtonHidden{
    [iScaleSlider setHidden:TRUE];
    [iButtonslider setHidden:TRUE]; 
}
- (void)setScaleSliderAndButtonShow{
    if ([iScaleSlider isHidden]==TRUE){
        [self performSelector:@selector(setScaleSliderAndButtonHidden) withObject:Nil afterDelay:5];
        [iScaleSlider setHidden:FALSE];
        [iButtonslider setHidden:FALSE];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint tapPoint = [touch locationInView:iVideoPreviewView];
    if (tapPoint.y <= 428){ 
        if ([touch tapCount] == 1) {
            [self setDrawRectPoint:tapPoint];
            [self performSelector:@selector(tapToFocusExpose:) withObject:[NSValue valueWithCGPoint:tapPoint] afterDelay:0.3];
        } else if ([touch tapCount] == 2) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapToFocusExpose:) object:[NSValue valueWithCGPoint:iFocusPoint]];
            [self resetFocusAndExpose];
      }
    }
}
- (void)tapToFocusExpose:(CGPoint)point{
    if ([[[[self captureManager] videoInput] device] isFocusPointOfInterestSupported]) {
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:iTapPoint];
        [captureManager focusAtPoint:convertedFocusPoint];
//      [self drawFocusBoxAtPointOfInterest:iDrawRectPoint];
    }
    if ([[[[self captureManager] videoInput] device] isExposurePointOfInterestSupported]) {
        CGPoint convertedExposurePoint = [self convertToPointOfInterestFromViewCoordinates:iTapPoint];
        [[self captureManager] exposureAtPoint:convertedExposurePoint];
        [self drawExposeBoxAtPointOfInterest:iDrawRectPoint];
        [self setScaleSliderAndButtonShow];
    }
}
- (void)tapToFocus:(CGPoint)point{
    if ([[[[self captureManager] videoInput] device] isFocusPointOfInterestSupported]) {
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:iTapPoint];
        [captureManager focusAtPoint:convertedFocusPoint];
        [self drawFocusBoxAtPointOfInterest:iDrawRectPoint];
    }
}

- (void)resetFocusAndExpose{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    [[self captureManager] focusAtPoint:pointOfInterest];
    [[self captureManager] exposureAtPoint:pointOfInterest];
    
    CGRect bounds = [self->iVideoPreviewView bounds];
    CGPoint screenCenter = CGPointMake(bounds.size.width / 2.f, bounds.size.height / 2.f);
    
//    [self drawFocusBoxAtPointOfInterest:screenCenter];
    [self drawExposeBoxAtPointOfInterest:screenCenter];
    
    [[self captureManager] setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
}
- (void)setDrawRectPoint:(CGPoint)aPoint{
    iFocusPoint = aPoint;
    CGRect bounds = [self->iVideoPreviewView bounds];
    CGPoint screenCenter = CGPointMake(bounds.size.width / 2.f, bounds.size.height / 2.f);
    iDrawRectPoint.x = (aPoint.x - screenCenter.x)*iCurrZoomValue + screenCenter.x;
    iDrawRectPoint.y = (aPoint.y - screenCenter.y)*iCurrZoomValue + screenCenter.y;
    iTapPoint.x = screenCenter.x*iCurrZoomValue - screenCenter.x + aPoint.x;
    iTapPoint.y = screenCenter.y*iCurrZoomValue - screenCenter.y + aPoint.y;
}
- (CALayer *)createLayerBoxWithColor:(UIColor *)color{
    NSDictionary *unanimatedActions = [[[NSDictionary alloc] initWithObjectsAndKeys:Nil, @"bounds",Nil, @"frame",Nil, @"position", Nil] autorelease];
    CALayer *box = [[[CALayer alloc] init] autorelease];
    [box setActions:unanimatedActions];
    [box setBorderWidth:1.f];
    [box setBorderColor:[color CGColor]];
    [box setOpacity:0.f];

    return box;
}

+ (CGSize)sizeForGravity:(NSString *)gravity frameSize:(CGSize)frameSize apertureSize:(CGSize)apertureSize{
    CGFloat apertureRatio = apertureSize.height / apertureSize.width;
    CGFloat viewRatio = frameSize.width / frameSize.height;
    
    CGSize size;
    if ([gravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
        if (viewRatio > apertureRatio) {
            size.width = frameSize.width;
            size.height = apertureSize.width * (frameSize.width / apertureSize.height);
        } else {
            size.width = apertureSize.height * (frameSize.height / apertureSize.width);
            size.height = frameSize.height;
        }
    } else if ([gravity isEqualToString:AVLayerVideoGravityResizeAspect]) {
        if (viewRatio > apertureRatio) {
            size.width = apertureSize.height * (frameSize.height / apertureSize.width);
            size.height = frameSize.height;
        } else {
            size.width = frameSize.width;
            size.height = apertureSize.width * (frameSize.width / apertureSize.height);
        }
    } else if ([gravity isEqualToString:AVLayerVideoGravityResize]) {
        size.width = frameSize.width;
        size.height = frameSize.height;
    }
    
    return size;
}

+ (void)addAdjustingAnimationToLayer:(CALayer *)layer removeAnimation:(BOOL)remove{
    if (remove) {
        [layer removeAnimationForKey:@"animateOpacity"];
    }
    if ([layer animationForKey:@"animateOpacity"] == nil) {
        [layer setHidden:NO];
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        [opacityAnimation setDuration:.3f];
        [opacityAnimation setRepeatCount:1.f];
        [opacityAnimation setAutoreverses:YES];
        [opacityAnimation setFromValue:[NSNumber numberWithFloat:1.f]];
        [opacityAnimation setToValue:[NSNumber numberWithFloat:.0f]];
        [layer addAnimation:opacityAnimation forKey:@"animateOpacity"];
    }
}

- (CGPoint)translatePoint:(CGPoint)point fromGravity:(NSString *)oldGravity toGravity:(NSString *)newGravity{
    CGPoint newPoint;
    
    CGSize frameSize = [self->iVideoPreviewView frame].size;
    
    CGSize apertureSize=iPhotoSize ;
    
    CGSize oldSize = [AVCamViewController sizeForGravity:oldGravity frameSize:frameSize apertureSize:apertureSize];
    
    CGSize newSize = [AVCamViewController sizeForGravity:newGravity frameSize:frameSize apertureSize:apertureSize];
    
    if (oldSize.height < newSize.height) {
        newPoint.y = ((point.y * newSize.height) / oldSize.height) - ((newSize.height - oldSize.height) / 2.f);
    } else if (oldSize.height > newSize.height) {
        newPoint.y = ((point.y * newSize.height) / oldSize.height) + ((oldSize.height - newSize.height) / 2.f) * (newSize.height / oldSize.height);
    } else if (oldSize.height == newSize.height) {
        newPoint.y = point.y;
    }
    
    if (oldSize.width < newSize.width) {
        newPoint.x = (((point.x - ((newSize.width - oldSize.width) / 2.f)) * newSize.width) / oldSize.width);
    } else if (oldSize.width > newSize.width) {
        newPoint.x = ((point.x * newSize.width) / oldSize.width) + ((oldSize.width - newSize.width) / 2.f);
    } else if (oldSize.width == newSize.width) {
        newPoint.x = point.x;
    }
    
    return newPoint;
}
- (void)drawFocusBoxAtPointOfInterest:(CGPoint)point{
    if ([[self captureManager] hasFocus]) {
        CGSize frameSize = [self->iVideoPreviewView frame].size;
        
        CGSize apertureSize = iPhotoSize;
        
        CGSize oldBoxSize = [AVCamViewController sizeForGravity:[[self captureVideoPreviewLayer] videoGravity] frameSize:frameSize apertureSize:apertureSize];
        
        CGPoint focusPointOfInterest = [[[captureManager videoInput] device] focusPointOfInterest];
        CGSize newBoxSize;
        if (focusPointOfInterest.x == .5f && focusPointOfInterest.y == .5f) {
            newBoxSize.width = (120.f / frameSize.width) * oldBoxSize.width;
            newBoxSize.height = (120.f / frameSize.height) * oldBoxSize.height;
        } else {
            newBoxSize.width = (120.f / frameSize.width) * oldBoxSize.width;
            newBoxSize.height = (120.f / frameSize.height) * oldBoxSize.height;
        }
        
        [focusBox setFrame:CGRectMake(0.f, 0.f, newBoxSize.width, newBoxSize.height)];
        [focusBox setPosition:point];
        [AVCamViewController addAdjustingAnimationToLayer:focusBox removeAnimation:YES];
    }
}

- (void)drawExposeBoxAtPointOfInterest:(CGPoint)point{
    if ([[self captureManager] hasExposure]) {
        CGSize frameSize = [self->iVideoPreviewView frame].size;
        
        CGSize apertureSize = iPhotoSize;
        
        CGSize oldBoxSize = [AVCamViewController sizeForGravity:[[self captureVideoPreviewLayer] videoGravity] frameSize:frameSize apertureSize:apertureSize];
        
        CGPoint exposurePointOfInterest = [[[captureManager videoInput] device] exposurePointOfInterest];
        CGSize newBoxSize;
        if (exposurePointOfInterest.x == .5f && exposurePointOfInterest.y == .5f) {
            newBoxSize.width = (80.f / frameSize.width) * oldBoxSize.width;
            newBoxSize.height = (80.f / frameSize.height) * oldBoxSize.height;
        } else {
            newBoxSize.width = (80.f / frameSize.width) * oldBoxSize.width;
            newBoxSize.height = (80.f / frameSize.height) * oldBoxSize.height;
        }
        
        [exposeBox setFrame:CGRectMake(0.f, 0.f, newBoxSize.width, newBoxSize.height)];
        [exposeBox setPosition:point];
        [AVCamViewController addAdjustingAnimationToLayer:exposeBox removeAnimation:YES];
    }
}

- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates {
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = [self->iVideoPreviewView frame].size;
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = [self captureVideoPreviewLayer];
    
    if ([[self captureVideoPreviewLayer] isMirrored]) {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }    
    
    if ( [[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [[[self captureManager] videoInput] ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}
- (void) saveCurrentImageToAlbum{
    iBoolStopsessionFnish=FALSE;
    [self performSelector:@selector(sessionStopRunning) withObject:Nil afterDelay:10.0];
    //[NSThread detachNewThreadSelector:@selector(sessionStopRunning) toTarget:self withObject:nil];
    //[self performSelector:@selector(setStopSessionFlag) withObject:Nil afterDelay:2.5];
    [[self irisView] setStatisIrisViewShown:YES];
/*    UIImageWriteToSavedPhotosAlbum(self->iImagePrepareToSave, nil, nil, nil);
    if (self->iImagePrepareToSave){
        [self->iImagePrepareToSave release];
        iImagePrepareToSave=NULL;
    }*/
}
- (void) discardCurrentImage{
    [[self irisView] setHidden:YES];  
    self.irisView->statisIrisView_.hidden = YES;
    if (self->iImagePrepareToSave){
        [self->iImagePrepareToSave release];
        iImagePrepareToSave=NULL;
    }
}
- (void) camViewSaveRotateBitmap:(const char *)aFileName:(TNMInt)aRotate:(TNMInt)aQuality{
    HybrowserAppDelegate *maindelegate = ((HybrowserAppDelegate*)[[UIApplication sharedApplication] delegate]); 
    CUIBitmap *bitmap= SaveRotateBitmap(aFileName, aRotate ,aQuality, iUpLoadImageW, iUpLoadImageW ,maindelegate.iCaptureBitmap);
    SETOBJECT(maindelegate.iCaptureBitmap, bitmap);
}

- (void) takeScreenShot:(UIImage*) image{
    CNMService* newService = new CNMService();
    CFThread* newThread = newService->GetThread();
    CFThread::SetThreadSelf( newThread );
    newThread->iArg1 = newService;
    newThread->iArg2 = CNMAutoreleasePool::CreateInstance();
    
    [self _takeScreenShot:image];
    
    CNMAutoreleasePool::Instance()->Release();
    delete newService;
}

- (void) _takeScreenShot:(UIImage*) image{
    CUIBitmap* bitmap = ConvertToUIBitMap(image);
    CUIBitmap* tbitmap = CUIBitmap::Bitmap();
    tbitmap->SetConfig(CUIBitmap::kUIRGB_565_Config, 608,608);//脚本给得大小
    tbitmap->AllocPixels();
    CUICanvas* canvas = CUICanvas::CanvasWithBitmap(tbitmap);
    
    float camscreenheight = 428.0;
    float camscreenwidth = 320.0;//[UIScreen mainScreen].bounds.size.width;
    
    float wratio = bitmap->Width()/camscreenheight;
    float hratio = bitmap->Height()/camscreenwidth;
    
    float w = 300.0*wratio/iCurrZoomValue;
    float h = 300.0*hratio/iCurrZoomValue;
    CGRect rect = CGRectMake((bitmap->Width() - w)/2, (bitmap->Height() - h)/2,h,h) ;
    TNMFloat xscaleradio = (TNMFloat)iUpLoadImageW/h;
    TNMFloat yscaleradio = (TNMFloat)iUpLoadImageH/h;
    canvas->Scale(yscaleradio,xscaleradio);
    canvas->Translate((bitmap->Height())-rect.origin.y,-rect.origin.x);
    //canvas->Translate( 620,-126);
    canvas->Rotate(90);
    canvas->DrawBitmap(bitmap,0,0);
    
    HybrowserAppDelegate *maindelegate = ((HybrowserAppDelegate*)[[UIApplication sharedApplication] delegate]);     
    SETOBJECT(maindelegate.iCaptureBitmap, tbitmap);

    SkImageEncoder::EncodeFile([iFullFileName cStringUsingEncoding:NSUTF8StringEncoding],*((SkBitmap*)tbitmap->GetInternal()),SkImageEncoder::kJPEG_Type,iImageQuality);

    [self performSelectorOnMainThread:@selector(switchViewToScript) withObject:nil waitUntilDone:NO];
    //[self switchViewToScript];
}

- (void) _handleConvertToBitmapInThread:(NSData *)aImageData{

    CNMService* newService = new CNMService();
    CFThread* newThread = newService->GetThread();
    CFThread::SetThreadSelf( newThread );
    newThread->iArg1 = newService;
    newThread->iArg2 = CNMAutoreleasePool::CreateInstance();
    
    [self _handleConvertToBitmap:aImageData];
    
    CNMAutoreleasePool::Instance()->Release();
    delete newService;
}

- (void) _handleConvertToBitmap:(NSData *)aImageData{
    CGImageRef imageRef = [iImagePrepareToSave CGImage];
    float imagew = CGImageGetWidth(imageRef);//iphone3 = 2048
    float imageh = CGImageGetHeight(imageRef);//iphone3 = 1536
    
    float camscreenheight = 428.0;
    float camscreenwidth = 320.0;//[UIScreen mainScreen].bounds.size.width;
    
    float wratio = imagew/camscreenheight;
    float hratio = imageh/camscreenwidth;
    
    float w = 300.0*wratio/iCurrZoomValue;
    float h = 300.0*hratio/iCurrZoomValue;
    CGRect rect = CGRectMake((imagew - w)/2, (imageh - h)/2,h,h) ;
    
    HybrowserAppDelegate *maindelegate = ((HybrowserAppDelegate*)[[UIApplication sharedApplication] delegate]);     
    CUIBitmap *bitmap = invokeCallback(aImageData, NO, iImagePrepareToSave, iFullFileName, rect, iUpLoadImageW, iUpLoadImageH, maindelegate.iCaptureBitmap, iImageQuality);
    SETOBJECT(maindelegate.iCaptureBitmap, bitmap);
}

- (void) handleConvertToBitmap:(NSData *)aImageData{
    if (iImagePrepareToSave){
        [iImagePrepareToSave release];
        iImagePrepareToSave=nil;
    }
    iImagePrepareToSave = [[UIImage alloc] initWithData:aImageData];
    [self _handleConvertToBitmapInThread:aImageData];
    [self performSelectorOnMainThread:@selector(switchViewToScript) withObject:nil waitUntilDone:YES];

    
    //[self switchViewToScript];
/*    else
    {
        [NSThread detachNewThreadSelector:@selector(_handleConvertToBitmapInThread:) toTarget:self withObject:aImageData];
        [self switchViewToScript];
    }*/

}
- (float) getCurrentZoomValue{
    return iCurrZoomValue;
}
- (NSString *) getFullFileName{
    return iFullFileName;
}
- (void)callAnimationForCameraOpen{
    [self.irisView openIris];
}
- (void)callAnimationForCameraClose{
    [self.irisView closeIris];
}
@end

@implementation AVCamViewController (InternalMethods)

- (void)updateButtonStates{
	NSUInteger cameraCount = [[self captureManager] cameraCount];
    
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        if (cameraCount < 2) {
            if (cameraCount < 1) {
                [iTakePhotoButton setEnabled:NO];
                [self setEnableVolumeSnap:FALSE];	
            } 
            else {
                [iTakePhotoButton setEnabled:YES];
                [self setEnableVolumeSnap:TRUE];
            }
        } else {
            [iTakePhotoButton setEnabled:YES];
            [self setEnableVolumeSnap:TRUE];
        }
    });
}
@end
@implementation AVCamViewController (AVCamCaptureManagerDelegate)
- (void)captureManager:(AVCamCaptureManager *)captureManager didFailWithError:(NSError *)error{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                            message:[error localizedFailureReason]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                  otherButtonTitles:nil];
//        [[captureManager session] stopRunning];
//        [[captureManager session] startRunning];
        [alertView show];
        [alertView release];
    });
}

- (void)switchViewToScript{
    [iTakePhotoButton setEnabled:YES];
    HybrowserAppDelegate *maindelegate = ((HybrowserAppDelegate*)[[UIApplication sharedApplication] delegate]); 
    CABAppUI::Instance()->NotifyActivityResultWithBitmap(1, 0, (TNMChar*)[iFullFileName UTF8String], maindelegate.iCaptureBitmap, 1000, nil, 0); 
    [self dismissThisViewController];
}
- (void)captureManagerDeviceConfigurationChanged:(AVCamCaptureManager *)captureManager{
	[self updateButtonStates];
}
@end