//
//  MyTestViewController.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "BlueToothViewController.h"
#import "MyTestViewController.h"
#import "RRAttributedLabel.h"
#import "NSAttributedString_Attributes.h"
#import "RRUtility.h"

#import "CoreVideo/CoreVideo.h"
#import "CoreMedia/CoreMedia.h"
@implementation MyTestViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
- (void)dealloc { 
    //     [self.myWebView release]; 
    [super dealloc]; 
    [tmplable release];

} 
- (void)loadView
{
    [super loadView];
    // Implement loadView to create a view hierarchy programmatically, without using a nib.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
     NSString *info = [NSString stringWithFormat:@"系统信息屏幕宽度=%d",[RRUtility getScreenWidth]];
    
    tmplable =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, [RRUtility getScreenWidth], 100)];
    tmplable.text = info;
    [self.view addSubview:tmplable];
    
    tmplable.text  =[RRUtility getlocalWiFiIPAddress];
        
    NSString* txt = @"扩展labbel测试""变化颜色""点击事件"; 
	/**(1)** Build the NSAttributedString *******/
	NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:txt];
	// for those calls we don't specify a range so it affects the whole string
	[attrStr setFont:[UIFont fontWithName:@"Helvetica" size:18]];
	[attrStr setTextColor:[UIColor grayColor]];
    
	// now we only change the color of "Hello"
	[attrStr setTextColor:[UIColor colorWithRed:0.f green:0.f blue:0.5 alpha:1.f] range:[txt rangeOfString:@"变化颜色"]];
	[attrStr setTextBold:YES range:[txt rangeOfString:@"变化颜色"]];
	
	/**(2)** Affect the NSAttributedString to the OHAttributedLabel *******/
     RRAttributedLabel *label1 =[[RRAttributedLabel alloc] initWithFrame:CGRectMake(10, 110, self.view.bounds.size.width, 100)];
	label1.attributedText = attrStr;
	// and add a link to the "share your food!" text
	[label1 addCustomLink:[NSURL URLWithString:@"http://www.renren.com"] inRange:[txt rangeOfString:@"点击事件"]];
    
	// Use the "Justified" alignment
	label1.textAlignment = UITextAlignmentJustify;
	// "Hello World!" will be displayed in the label, justified, "Hello" in red and " World!" in gray.	
    [self.view addSubview:label1];
    [label1 release];
//
    UIButton *tmpbutton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tmpbutton addTarget:self action:@selector(setupCaptureSession) forControlEvents:UIControlEventTouchDown];
    [tmpbutton setFrame:CGRectMake(10, 300, 100, 100)];
    [tmpbutton setTitle:@"开始定位" forState:UIControlStateNormal];
    [self.view addSubview:tmpbutton];
    

    //测试将摄像头捕获的视频数据转为jpeg格式
    testAvView = [[RRUIImageView alloc]initWithFrame:CGRectMake(5, 100, 310, 200)];
    [testAvView setImageViewShowPosition:0.4 left:0];
    [testAvView setImageWithUrl:@"http://www.onezt.com/upimg/allimg/091223/01510510.jpg"];
    [self.view addSubview:testAvView];
    [testAvView release];
    testAvView.canMove=YES;
    
    UIButton *photoget =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [photoget addTarget:self action:@selector(photogetimage) forControlEvents:UIControlEventTouchDown];
    [photoget setFrame:CGRectMake(210, 300, 100, 100)];
    [photoget setTitle:@"拍照" forState:UIControlStateNormal];
    [self.view addSubview:photoget];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
}
-(void)changepage{
    BlueToothViewController *blueview=[[BlueToothViewController alloc] init];
    [self presentModalViewController:blueview animated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
// Create a UIImage from sample buffer data  
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer   
{  
    // Get a CMSampleBuffer's Core Video image buffer for the media data  
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);   
    // Lock the base address of the pixel buffer  
    CVPixelBufferLockBaseAddress(imageBuffer, 0);   
    
    // Get the number of bytes per row for the pixel buffer  
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);   
    
    // Get the number of bytes per row for the pixel buffer  
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);   
    // Get the pixel buffer width and height  
    size_t width = CVPixelBufferGetWidth(imageBuffer);   
    size_t height = CVPixelBufferGetHeight(imageBuffer);   
    
    // Create a device-dependent RGB color space  
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();   
    
    // Create a bitmap graphics context with the sample buffer data  
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,   
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);   
    // Create a Quartz image from the pixel data in the bitmap graphics context  
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);   
    // Unlock the pixel buffer  
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);  
    
    // Free up the context and color space  
    CGContextRelease(context);   
    CGColorSpaceRelease(colorSpace);  
    
    // Create an image object from the Quartz image  
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];  
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];  
    
    // Release the Quartz image  
    CGImageRelease(quartzImage);  
    
    return (image);  
}     
-(void)photogetimage{

    isgetpic = YES;

}
- (void)captureOutput:(AVCaptureOutput *)captureOutput   
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer   
       fromConnection:(AVCaptureConnection *)connection  
{   
    // Create a UIImage from the sample buffer data  
    if (isgetpic) {
//        if(UIGraphicsBeginImageContextWithOptions != NULL)
//        {
//            UIGraphicsBeginImageContextWithOptions(preLayer.frame.size, NO, 0.0);
//        } else {
//            UIGraphicsBeginImageContext(preLayer.frame.size);
//        }
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        [preLayer renderInContext:context];
//        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
        
//         UIImage *image = [self imageFromSampleBuffer:sampleBuffer];  
//        // NSData *iData = UIImageJPEGRepresentation(image, 0.5);//这里的mData是NSData对象，后面的0.5代表生成的图片质量  
//        [testAvView setImage:image];
//        [testAvView setNeedsLayout];
//        [session stopRunning];
//        [preLayer removeFromSuperlayer];
//        [session release];
//        session=nil;
        isgetpic =NO;
//        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
//        
//        CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer); 
//        /*Lock the image buffer*/
//        CVPixelBufferLockBaseAddress(imageBuffer,0); 
//        /*Get information about the image*/
//        uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer); 
//        size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer); 
//        size_t width = CVPixelBufferGetWidth(imageBuffer); 
//        size_t height = CVPixelBufferGetHeight(imageBuffer);  
//        
//        /*Create a CGImageRef from the CVImageBufferRef*/
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB(); 
//        CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//        CGImageRef newImage = CGBitmapContextCreateImage(newContext); 
//        
//        /*We release some components*/
//        CGContextRelease(newContext); 
//        CGColorSpaceRelease(colorSpace);
//        
//        /*We display the result on the image view (We need to change the orientation of the image so that the video is displayed correctly).
//         Same thing as for the CALayer we are not in the main thread so ...*/
//        UIImage *image= [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
//        
//        /*We relase the CGImageRef*/
//        CGImageRelease(newImage);
//        [testAvView setImage:image];
//    
//        /*We unlock the  image buffer*/
//        CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//        [pool drain];
//        
        
        [newStillImageOutput captureStillImageAsynchronouslyFromConnection:iStillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            
            if (imageDataSampleBuffer != NULL) {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                
                UIImage* imgAlbum = [[UIImage alloc] initWithData:imageData];
                [testAvView setImage:imgAlbum];
                NSLog(@"syp===success");
            }else{
                NSLog(@"syp===error=======");
                
            }
        }];
        
        
        [testAvView setNeedsLayout];
        [session stopRunning];
        [preLayer removeFromSuperlayer];
        [newStillImageOutput release];
        [session release];
        session=nil;
            
            
    
    }

} 
// Create and configure a capture session and start it running  
- (void)setupCaptureSession   
{  
    NSError *error = nil;  
    
    // Create the session  
    if (session) {
        if ([session isRunning]) {
            return;
        }
    }
    isgetpic = NO;
    session = [[AVCaptureSession alloc] init];  
    
    // Configure the session to produce lower resolution video frames, if your   
    // processing algorithm can cope. We'll specify medium quality for the  
    // chosen device.  
    session.sessionPreset = AVCaptureSessionPresetMedium;  
    
    // Find a suitable AVCaptureDevice  
    AVCaptureDevice *device = [AVCaptureDevice  
                               defaultDeviceWithMediaType:AVMediaTypeVideo];//这里默认是使用后置摄像头，你可以改成前置摄像头  
    
    // Create a device input with the device and add it to the session.  
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device   
                                                                        error:&error];  
    if (!input) {  
        // Handling the error appropriately.  
    }  
    [session addInput:input];  
    
    // Create a VideoDataOutput and add it to the session  
    AVCaptureVideoDataOutput *output = [[[AVCaptureVideoDataOutput alloc] init] autorelease];  
    [session addOutput:output];  
    // Setup the still image file output
    newStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey,Nil];
    [newStillImageOutput setOutputSettings:outputSettings];
    [outputSettings release];
    [session addOutput:newStillImageOutput];
    for ( AVCaptureConnection *connection in [newStillImageOutput connections] ) {
		for ( AVCaptureInputPort *port in [connection inputPorts] ) {
			if ( [[port mediaType] isEqual:AVMediaTypeVideo] ) {
				iStillImageConnection = connection;
                [iStillImageConnection retain];
			}
		}
	}
    // Configure your output.  
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);  
    [output setSampleBufferDelegate:self queue:queue];  
    dispatch_release(queue);  
    
    // Specify the pixel format  
    output.videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:  
                            [NSNumber numberWithInt:kCVPixelFormatType_32BGRA], kCVPixelBufferPixelFormatTypeKey,  
                            [NSNumber numberWithInt: 320], (id)kCVPixelBufferWidthKey,  
                            [NSNumber numberWithInt: 480], (id)kCVPixelBufferHeightKey,  
                            nil];  
    
    preLayer = [AVCaptureVideoPreviewLayer layerWithSession: session];  
    //preLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];  
    preLayer.frame = CGRectMake(0, 10, 320, 240);  
    preLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;    
    [self.view.layer addSublayer:preLayer];  
    // If you wish to cap the frame rate to a known value, such as 15 fps, set   
    // minFrameDuration.  
  //  output.minFrameDuration = CMTimeMake(1, 15);  
    
    // Start the session running to start the flow of data  
    [session startRunning];  
    
    // Assign session to an ivar.  
    //[self setSession:session];  
}
- (void) captureStillImage{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    AVCaptureDevice *device = [AVCaptureDevice  
                               defaultDeviceWithMediaType:AVMediaTypeVideo];//这里默认是使用后置摄像头，你可以改成前置摄像头  
    if([device flashMode] == AVCaptureFlashModeOff && version > 4.2){
        //如果闪光灯关闭，则走截图方式，nnd真快
       // canCapture = true;
    
    }
    [newStillImageOutput captureStillImageAsynchronouslyFromConnection:iStillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {

        if (imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            
            /*UIImage* imgAlbum = [[UIImage alloc] initWithData:imageData];
             //save to album;
             UIImageWriteToSavedPhotosAlbum(imgAlbum, nil, nil, nil);
             [imgAlbum release];*/
            [NSThread detachNewThreadSelector:@selector(_saveToAlbum:) toTarget:self withObject:imageData];
            
            
        }else{
            
            
        }
    }];
}
@end
