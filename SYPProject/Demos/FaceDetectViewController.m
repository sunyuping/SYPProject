//
//  FaceDetectViewController.m
//  SYPProject
//
//  Created by sunyuping on 13-5-17.
//
//

#import "FaceDetectViewController.h"


#define navBarHeight    44.
#define markViewTag    100

@implementation FaceDetectViewController
@synthesize imageView;
@synthesize viewShow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)setUI
{
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //    [self loadImage:nil];
    self.imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, self.view.height-50)] autorelease];
    self.imageView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.imageView];
    
    UIButton *loadImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [loadImage setText:@"选择图片"];
    [loadImage addTarget:self action:@selector(loadImage:) forControlEvents:UIControlEventTouchUpInside];
    [loadImage setFrame:CGRectMake(0, 5, 100, 20)];
     [loadImage setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:loadImage];
    
    self.viewShow = [[[UIView alloc] initWithFrame:self.imageView.frame] autorelease];
    [self.view addSubview:self.viewShow];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - methods
-(void)setShowViewFrame
{
    CGFloat scale = 1.;
    
    CGSize imgSize = imageView.image.size;
    
    CGRect vFrame = self.view.frame;
    vFrame.size.height -= navBarHeight;
    vFrame.origin.y = navBarHeight;
    
    CGRect sFrame = viewShow.frame;
    
    if (imgSize.width/CGRectGetWidth(vFrame) > imgSize.height/CGRectGetHeight(vFrame)) {
        sFrame.size.width = CGRectGetWidth(vFrame);
        sFrame.size.height = imgSize.height * CGRectGetWidth(vFrame)/imgSize.width;
        
        scale = CGRectGetWidth(vFrame)/imgSize.width;
    }
    else{
        sFrame.size.height = CGRectGetHeight(vFrame);
        sFrame.size.width = imgSize.width * CGRectGetHeight(vFrame)/imgSize.height;
        
        scale = CGRectGetHeight(vFrame)/imgSize.height;
    }
    sFrame.origin.x = (CGRectGetWidth(vFrame)-CGRectGetWidth(sFrame))/2.;
    sFrame.origin.y = vFrame.origin.y + (CGRectGetHeight(vFrame)-CGRectGetHeight(sFrame))/2.;
    
    viewShow.frame = sFrame;
    
    UIImage *newImg = [self scaleImage:imageView.image toScale:scale];//图片根据imgV的frame进行重新缩放生成
    imageView.image = newImg;
    
}

-(void)dealImageWhenItChanged
{
    self.imageViewCrop.hidden = YES;
    self.imageView.hidden = NO;
    
    [self removeAllMarkViews];
    [self setShowViewFrame];
    
    [self showProgressIndicator:@"Detecting.."];
    rectFaceDetect = CGRectZero;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self faceDetect:imageView.image];
    });
    
    
}

-(void)removeAllMarkViews
{
    //清除原来标记的View
    for (UIView *vv in self.viewShow.subviews) {
        if (vv.tag == markViewTag) {
            [vv removeFromSuperview];
        }
    }
}
#pragma mark - ibaction
- (void)loadImage:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Use Photo from Library", @"Take Photo with Camera", @"Use Default Lena", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    [actionSheet showInView:self.view];
    [actionSheet release];
}

//将图片切成正方形，按照人脸来决定剪切的范围,多个人脸，仅按照一个人脸来决定
- (void)cropImage:(id)sender {
    if (CGRectGetHeight(rectFaceDetect)==0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Failed"
                                                       message:@"No image or the face detecting failed"
                                                      delegate:self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else
    {
        [self showProgressIndicator:@"Croping"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CGRect crpRect = [self getCropRectBgFaceDetect:rectFaceDetect];
            UIImage *newImg = [self croppedPhotoWithCropRect:self.imageView.image toFrame:crpRect];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self hideProgressIndicator];
                
                self.imageViewCrop.image = newImg;
                CGRect sFrame = self.viewShow.frame;
                sFrame.size = newImg.size;
                sFrame.origin.x = (CGRectGetWidth(self.view.bounds)-newImg.size.width)/2.0;
                sFrame.origin.y = navBarHeight + (CGRectGetHeight(self.view.bounds)-navBarHeight-newImg.size.height)/2.0;
                self.viewShow.frame = sFrame;
                
                self.imageViewCrop.hidden = NO;
                self.imageView.hidden = YES;
                [self removeAllMarkViews];
            });
        });
    }
}


#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex > 2) {
        return;
    }
    else if(buttonIndex !=2)
    {
        
        UIImagePickerControllerSourceType sourceType = (buttonIndex == 0)?UIImagePickerControllerSourceTypePhotoLibrary:UIImagePickerControllerSourceTypeCamera;
        
        if([UIImagePickerController isSourceTypeAvailable:sourceType]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = sourceType;
            picker.delegate = self;
            picker.allowsEditing = NO;
            [self presentModalViewController:picker animated:YES];
            [picker release];
        }
    }
    else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ian1" ofType:@"png"];
        imageView.image = [UIImage imageWithContentsOfFile:path];
        
        [self dealImageWhenItChanged];//人脸识别去
    }
    
	
}


#pragma mark - 人脸检测方法
- (void)faceDetect:(UIImage *)aImage
{
    
    //Create a CIImage version of your photo
    CIImage* image = [CIImage imageWithCGImage:aImage.CGImage];
    
    //create a face detector
    //此处是CIDetectorAccuracyHigh，若用于real-time的人脸检测，则用CIDetectorAccuracyLow，更快
    NSDictionary  *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                      forKey:CIDetectorAccuracy];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:opts];
    
    //Pull out the features of the face and loop through them
    NSArray* features = [detector featuresInImage:image];
    
    if ([features count]==0) {
        NSLog(@">>>>> 人脸监测【失败】啦 ～！！！");
        
    }
    NSLog(@">>>>> 人脸监测【成功】～！！！>>>>>> ");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self markAfterFaceDetect:features];
    });
    
}

//人脸标识
-(void)markAfterFaceDetect:(NSArray *)features
{
    [self hideProgressIndicator];
    [self setShowViewFrame];
    if ([features count]==0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Failed"
                                                       message:@"The face detecting failed"
                                                      delegate:self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    
    for (CIFaceFeature *f in features)
    {
        //旋转180，仅y
        CGRect aRect = f.bounds;
        aRect.origin.y = self.viewShow.bounds.size.height - aRect.size.height - aRect.origin.y;//self.bounds.size
        
        UIView *vv = [[UIView alloc]initWithFrame:aRect];
        vv.tag = markViewTag;
        [vv setTransform:CGAffineTransformMakeScale(1, -1)];
        vv.backgroundColor = [UIColor redColor];
        vv.alpha = 0.6;
        [self.viewShow addSubview:vv];
        [vv release];
        
        rectFaceDetect = aRect;
        
        
        NSLog(@"%@",NSStringFromCGRect(f.bounds));
        if (f.hasLeftEyePosition){
            printf("Left eye %g %g\n", f.leftEyePosition.x, f.leftEyePosition.y);
            
            UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
            vv.tag = markViewTag;
            //旋转180，仅y
            CGPoint newCenter =  f.leftEyePosition;
            newCenter.y = self.viewShow.bounds.size.height-newCenter.y;
            vv.center = newCenter;
            
            vv.backgroundColor = [UIColor yellowColor];
            [vv setTransform:CGAffineTransformMakeScale(1, -1)];
            vv.alpha = 0.6;
            [self.viewShow addSubview:vv];
            [vv release];
        }
        if (f.hasRightEyePosition)
        {
            printf("Right eye %g %g\n", f.rightEyePosition.x, f.rightEyePosition.y);
            
            UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
            vv.tag = markViewTag;
            //旋转180，仅y
            CGPoint newCenter =  f.rightEyePosition;
            newCenter.y = self.viewShow.bounds.size.height-newCenter.y;
            vv.center = newCenter;
            
            vv.backgroundColor = [UIColor blueColor];
            [vv setTransform:CGAffineTransformMakeScale(1, -1)];
            vv.alpha = 0.6;
            [self.viewShow addSubview:vv];
            [vv release];
        }
        if (f.hasMouthPosition)
        {
            printf("Mouth %g %g\n", f.mouthPosition.x, f.mouthPosition.y);
            
            UIView *vv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
            vv.tag = markViewTag;
            //旋转180，仅y
            CGPoint newCenter =  f.mouthPosition;
            newCenter.y = self.viewShow.bounds.size.height-newCenter.y;
            vv.center = newCenter;
            
            vv.backgroundColor = [UIColor greenColor];
            [vv setTransform:CGAffineTransformMakeScale(1, -1)];
            vv.alpha = 0.6;
            [self.viewShow addSubview:vv];
            [vv release];
            
        }
    }
    
    
}
#pragma mark - 图片剪切
- (UIImage *) croppedPhotoWithCropRect:(UIImage *)aImage toFrame:(CGRect)aFrame
{
    //框的坐标
    CGRect cropRect = aFrame;
    
    //根据比例得出选中框实际圈中的范围
    //    CGSize nowImageSize = self.cropperImageView.frame.size;
    //    CGSize realImageSize = self.cropperImageView.image.size;
    //    CGFloat nowScaleW = realImageSize.width/nowImageSize.width;
    //    CGFloat nowScaleH = realImageSize.height/nowImageSize.height;
    //    cropRect.origin.x *= nowScaleW;
    //    cropRect.origin.y *= nowScaleH;
    //    cropRect.size.width *= nowScaleW;
    //    cropRect.size.height *= nowScaleH;
    
    //根据范围剪切图片得到新图片
    CGImageRef imageRef = CGImageCreateWithImageInRect([aImage CGImage], cropRect);
    UIImage *result = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return result;
}
-(CGRect)getCropRectBgFaceDetect:(CGRect)aFaceDetRect
{
    CGRect faceDetRect = aFaceDetRect;
    CGRect aImgRect = self.viewShow.frame;
    CGRect aCrpRect = [self getCropRectWhenFaceDetectFailed];
    
    //找到人脸中心
    CGPoint centerPoint =CGPointMake(0, 0);
    centerPoint.x = faceDetRect.origin.x + faceDetRect.size.width/2.0;
    centerPoint.y = faceDetRect.origin.y + faceDetRect.size.height/2.0;
    
    //将aCrpRect中心点移到人脸中心
    aCrpRect.origin.x = centerPoint.x - aCrpRect.size.width/2.0;
    aCrpRect.origin.y = centerPoint.y - aCrpRect.size.height/2.0;
    
    //判断aCrpRect超出情况
    if (aCrpRect.origin.x < 0) {
        aCrpRect.origin.x =0;
    }
    if (aCrpRect.origin.x+aCrpRect.size.width > aImgRect.origin.x + aImgRect.size.width) {
        aCrpRect.origin.x = aImgRect.origin.x + aImgRect.size.width - aCrpRect.size.width;
    }
    if (aCrpRect.origin.y < 0) {
        aCrpRect.origin.y =0;
    }
    if (aCrpRect.origin.y+aCrpRect.size.height > aImgRect.origin.y + aImgRect.size.height) {
        aCrpRect.origin.y = aImgRect.origin.y + aImgRect.size.height - aCrpRect.size.height;
    }
    return aCrpRect;
}

-(CGRect)getCropRectWhenFaceDetectFailed
{
    CGRect imgVRect = self.viewShow.frame;
    CGRect crpRect = self.viewShow.frame;
    if (CGRectGetHeight(crpRect)>CGRectGetWidth(crpRect)) {
        crpRect.size.height = CGRectGetWidth(crpRect);
    }
    else
    {
        crpRect.size.width = CGRectGetHeight(crpRect);
    }
    crpRect.origin.x = (CGRectGetWidth(imgVRect)-CGRectGetWidth(crpRect))/2.0;
    crpRect.origin.y = (CGRectGetHeight(imgVRect)-CGRectGetHeight(crpRect))/2.0;
    
    return crpRect;
}


#pragma mark - ScaleImageSize
//将图片进行缩放重新生成
- (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize {
    if (image) {
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
        [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return scaledImage;
    }
    return nil;
}


- (void)showProgressIndicator:(NSString *)text {
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	self.view.userInteractionEnabled = FALSE;
	if(!progressHUD) {
		CGFloat w = 160.0f, h = 120.0f;
		progressHUD = [[UIProgressHUD alloc] initWithFrame:CGRectMake((self.view.frame.size.width-w)/2, (self.view.frame.size.height-h)/2, w, h)];
		[progressHUD setText:text];
		[progressHUD showInView:self.view];
	}
}

- (void)hideProgressIndicator {
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	self.view.userInteractionEnabled = TRUE;
	if(progressHUD) {
		[progressHUD hide];
		[progressHUD release];
		progressHUD = nil;
        
	}
}
#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
	static int kMaxResolution = 640;
	
	CGImageRef imgRef = image.CGImage;
	CGFloat width = CGImageGetWidth(imgRef);
	CGFloat height = CGImageGetHeight(imgRef);
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	CGRect bounds = CGRectMake(0, 0, width, height);
	if (width > kMaxResolution || height > kMaxResolution) {
		CGFloat ratio = width/height;
		if (ratio > 1) {
			bounds.size.width = kMaxResolution;
			bounds.size.height = bounds.size.width / ratio;
		} else {
			bounds.size.height = kMaxResolution;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
	CGFloat scaleRatio = bounds.size.width / width;
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
	CGFloat boundHeight;
	
	UIImageOrientation orient = image.imageOrientation;
	switch(orient) {
		case UIImageOrientationUp:
			transform = CGAffineTransformIdentity;
			break;
		case UIImageOrientationUpMirrored:
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			break;
		case UIImageOrientationDown:
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
			transform = CGAffineTransformScale(transform, 1.0, -1.0);
			break;
		case UIImageOrientationLeftMirrored:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
			transform = CGAffineTransformScale(transform, -1.0, 1.0);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
		case UIImageOrientationLeft:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
			break;
		case UIImageOrientationRightMirrored:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeScale(-1.0, 1.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		case UIImageOrientationRight:
			boundHeight = bounds.size.height;
			bounds.size.height = bounds.size.width;
			bounds.size.width = boundHeight;
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
			transform = CGAffineTransformRotate(transform, M_PI / 2.0);
			break;
		default:
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
	}
	
	UIGraphicsBeginImageContext(bounds.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
		CGContextScaleCTM(context, -scaleRatio, scaleRatio);
		CGContextTranslateCTM(context, -height, 0);
	} else {
		CGContextScaleCTM(context, scaleRatio, -scaleRatio);
		CGContextTranslateCTM(context, 0, -height);
	}
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return imageCopy;
}

- (void)imagePickerController:(UIImagePickerController *)picker
		didFinishPickingImage:(UIImage *)image
				  editingInfo:(NSDictionary *)editingInfo
{
	imageView.image = [self scaleAndRotateImage:image];
    [self dealImageWhenItChanged];//人脸识别去
    
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];
}


- (void)dealloc {
    [imageView release];
    [viewShow release];
    [_imageViewCrop release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setImageView:nil];
    [self setViewShow:nil];
    [self setImageViewCrop:nil];
    [super viewDidUnload];
}

@end
