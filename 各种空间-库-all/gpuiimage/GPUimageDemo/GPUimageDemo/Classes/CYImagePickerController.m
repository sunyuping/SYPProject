//
//  CYImagePickerController.m
//  CYFilter
//
//  Created by yi chen on 12-7-20.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYImagePickerController.h"
#import "CYFilter.h"

#import "GPUImageGaussianSelectiveBlurCircleFilter.h"
#import "CYImageFilterTypes.h"
#import "InfColorBarPicker.h"

#import "CYImageAVCapture.h"
#import "CYPassthroughView.h"

typedef enum CYImageEditMode {
	
	CYImageEditModeScrawl, //涂鸦状态
	CYImageEditModeText,   //输入文字状态
	
} CYImageEditMode;


/**
 *	 info dictionary keys
 */
NSString * const kCYImagePickerImage = @"kCYImagePickerImage";
NSString * const kCYImagePickerGIF   = @"kCYImagePickerGIF";
NSString * const kCYImagePickerVideo = @"kCYImagePickerVideo";
NSString * const kCYImagePickerDismissTimeSeconds = @"kCYImagePickerDismissTimeSeconds";

#define kGaussianBlurSizeStart  1.0f
#define kGaussianBlurSizeEnd  1.0f


#define  kFiltersCount 20
#define  kFilterSelectViewHeight 100
#define  kFilterSelectViewWidth 320
#define  kBottomBarViewHeight 53
#define  kBottomBarViewWidth 320
#define  kFilterSelectViewUpY   ([UIScreen mainScreen].bounds.size.height -  kBottomBarViewHeight - kFilterSelectViewHeight + 5)
#define  kFilterSelectViewDownY ([UIScreen mainScreen].bounds.size.height - kBottomBarViewHeight)

#define kSnapPickerViewUpY (screenHeight - 250 + 40)
#define kSnapPickerViewDownY screenHeight
#define kSnapInputTextFieldHeight 30
static CGFloat kMaxImageWidth = 320; //导入照片的时限制最大的宽度

@interface CYImagePickerController ()
{
	NSDictionary *filterTypeDic;
	
	//	用于从系统的照片库拾取照片
	GPUImageStillCamera *_stillCameraBack;	//	镜头相机采集后部
	GPUImageVideoCamera *_videoCamera;		//	视频采集
    GPUImagePicture *_sourcePicture;		//	附加图片 混合效果
	
	UIImageOrientation staticPictureOriginalOrientation;
	
	int filterTypeId;
	int _currentFilterIndex;
	
	BOOL isblurApply;
	GPUImageRotationMode rotatioMode;
	
	BOOL showBigFocusCameraFlag;
	
	CYImageAVCapture *avCapture;
	
	CGFloat screenWidth;
	CGFloat screenHeight;
}

@property(nonatomic)GPUImageShowcaseFilterType filterType;
@property (nonatomic)int filterTypeId;
@property(nonatomic,assign)int currentFilterIndex;

//	私有成员
@property(nonatomic,retain)CYPassthroughView *containerView;

@property(nonatomic,retain)NSArray *jsonObjectArray;
@property(nonatomic,retain)UIImagePickerController *localImagePickerController;
@property(nonatomic,retain)UIButton *turnCameraDeviceButton;
@property(nonatomic,retain)UIView *bottomBarView;
@property(nonatomic,retain)UIButton *flashChangeButton;
@property(nonatomic,retain)UIButton *startCaptureButton;
@property(nonatomic,retain)UIButton *pickPictureButton;
@property(nonatomic,retain)UIButton *cancelPickButton;
@property(nonatomic,retain)UIButton *showSelectViewButton;
@property(nonatomic,retain)UIScrollView * filterSelectScrollView;
@property(nonatomic,retain)GPUImagePicture *editPicture;
@property(nonatomic,retain)GPUImageOutput<GPUImageInput> *filterBack;
@property(nonatomic,retain)GPUImageOutput<GPUImageInput> *originFilter;
@property(nonatomic,retain)UIImage *originImage;
@property(nonatomic,retain)CYFilterChain *filterChain;
@property(nonatomic,copy) NSString *filterClassNameString;
@property(nonatomic,assign)	BOOL isFilterSelectScrollViewHidden;

@property (nonatomic, retain) GPUImagePicture *internalSourcePicture1;
@property (nonatomic, retain) GPUImagePicture *internalSourcePicture2;
@property (nonatomic, retain) GPUImagePicture *internalSourcePicture3;
@property (nonatomic, retain) GPUImagePicture *internalSourcePicture4;
@property (nonatomic, retain) GPUImagePicture *internalSourcePicture5;

@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeftGestureRecognizer;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeRightGestureRecognizer;

@property (nonatomic, retain) UIImageView *focusCameraFlagView;

@property(nonatomic,retain)UIButton *snapRetakeButton;
@property(nonatomic,retain)UIButton *snapSaveToAlbumButton;
@property(nonatomic,retain)UIButton *snapSendButton;
@property(nonatomic,retain)UIButton *snapSetTimeButton;
@property(nonatomic,retain)UIPickerView *snapPickerView;
@property(nonatomic,assign)NSInteger snapDismissTimeSecond;
@property(nonatomic,retain)NSMutableArray *snapTimesSelectArray;

@property(nonatomic,assign)CYImageEditMode imageEditMode;
@property(nonatomic,retain)UITextField *snapInputTextField;
@property(nonatomic,retain)InfColorBarPicker *colorBarPicker;
@property(nonatomic,retain)InfColorBarView *colorBarView;

@end

@implementation CYImagePickerController

@synthesize pickerState = _pickerState;
@synthesize editImage = _editImage;
@synthesize filterType = _filterType;
@synthesize filterTypeId = _filterTypeId;
@synthesize currentFilterIndex = _currentFilterIndex;
@synthesize localImagePickerController = _localImagePickerController;
@synthesize containerView = _containerView;
@synthesize jsonObjectArray = _jsonObjectArray;
@synthesize editPicture = _editPicture;
@synthesize filterBackView = _filterBackView;
@synthesize filterBack = _filterBack;
@synthesize originFilter = _originFilter;
@synthesize originImage = _originImage;
@synthesize filterChain = _filterChain;
@synthesize turnCameraDeviceButton = _turnCameraDeviceButton;
@synthesize bottomBarView = _bottomBarView;
@synthesize flashChangeButton = _flashChangeButton;
@synthesize startCaptureButton = _startCaptureButton;
@synthesize pickPictureButton = _pickPictureButton;
@synthesize cancelPickButton = _cancelPickButton;

@synthesize showSelectViewButton = _showSelectViewButton;
@synthesize filterSelectScrollView = _filterSelectScrollView;
@synthesize filterClassNameString = _filterClassNameString;

@synthesize isFilterSelectScrollViewHidden = _isFilterSelectScrollViewHidden;

@synthesize internalSourcePicture1;
@synthesize internalSourcePicture2;
@synthesize internalSourcePicture3;
@synthesize internalSourcePicture4;
@synthesize internalSourcePicture5;

@synthesize swipeLeftGestureRecognizer = _swipeLeftGestureRecognizer;
@synthesize swipeRightGestureRecognizer = _swipeRightGestureRecognizer;

@synthesize focusCameraFlagView = _focusCameraFlagView;

@synthesize snapRetakeButton = _snapRetakeButton;
@synthesize snapSaveToAlbumButton = _snapSaveToAlbumButton;
@synthesize snapSetTimeButton = _snapSetTimeButton;
@synthesize snapSendButton = _snapSendButton;
@synthesize snapPickerView = _snapPickerView;
@synthesize snapDismissTimeSecond = _snapDismissTimeSecond;
@synthesize snapTimesSelectArray = _snapTimesSelectArray;

@synthesize snapScrawlView = _snapScrawlView;
@synthesize imageEditMode = _imageEditMode;
@synthesize snapInputTextField = _snapInputTextField;
@synthesize colorBarPicker = _colorBarPicker;
@synthesize colorBarView = _colorBarView;

#pragma mark - dealloc
- (void)dealloc{
	[_stillCameraBack stopCameraCapture];
	
	[self removeAllTarget];
	[self.filterBackView removeFromSuperview];
	[self.snapScrawlView removeFromSuperview];
	
	RELEASE_SAFELY(filterTypeDic);
	RELEASE_SAFELY(_editImage);
	RELEASE_SAFELY(_localImagePickerController);
	RELEASE_SAFELY(_jsonObjectArray);
	
	RELEASE_SAFELY(_turnCameraDeviceButton);
	RELEASE_SAFELY(_bottomBarView);
	RELEASE_SAFELY(_flashChangeButton);
	RELEASE_SAFELY(_startCaptureButton);
	RELEASE_SAFELY(_pickPictureButton);
	RELEASE_SAFELY(_cancelPickButton);
	RELEASE_SAFELY(_showSelectViewButton);
	RELEASE_SAFELY(_filterSelectScrollView);
	
	//	滤镜处理
	
	RELEASE_SAFELY(_stillCameraBack);
	RELEASE_SAFELY(_filterBack);
	RELEASE_SAFELY(_filterBackView);
	
	RELEASE_SAFELY(_originFilter);
	RELEASE_SAFELY(_originImage);
	
	RELEASE_SAFELY(_filterChain);
	
	RELEASE_SAFELY(_sourcePicture);
	RELEASE_SAFELY(_editPicture);
	RELEASE_SAFELY(_filterClassNameString);
	
    self.internalSourcePicture1 = nil;
    self.internalSourcePicture2 = nil;
    self.internalSourcePicture3 = nil;
    self.internalSourcePicture4 = nil;
    self.internalSourcePicture5 = nil;
	
	self.swipeRightGestureRecognizer = nil;
	self.swipeLeftGestureRecognizer = nil;
	self.focusCameraFlagView = nil;
	[self removeObserver:self forKeyPath:@"pickerState"];
	[[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	
	RELEASE_SAFELY(_snapRetakeButton);
	RELEASE_SAFELY(_snapSaveToAlbumButton);
	RELEASE_SAFELY(_snapSetTimeButton);
	RELEASE_SAFELY(_snapSendButton);
	RELEASE_SAFELY(_snapPickerView);
	RELEASE_SAFELY(_snapTimesSelectArray);
	RELEASE_SAFELY(_snapScrawlView);
	RELEASE_SAFELY(_colorBarPicker);
	RELEASE_SAFELY(_colorBarView);;
	RELEASE_SAFELY(_snapInputTextField);
    [super dealloc];
}

#pragma mark init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
		//注册监听
		[self addObserver:self forKeyPath:@"pickerState" options:NSKeyValueObservingOptionNew context:nil];
		//注册屏幕旋转监听
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleOrientationDidChangeNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
		//键盘
		[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleUIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
 		
		NSArray *keys = [CYImageFilterTypes filterTypeNameStringsArray];
		NSMutableArray *objects = [NSMutableArray arrayWithCapacity:keys.count];
		for (int i = 0 ; i < keys.count; i ++) {
			NSNumber *keyIndex = [NSNumber numberWithInt:i];
			[objects addObject:keyIndex];
		}
		filterTypeDic = [[NSDictionary alloc]initWithObjects:objects forKeys:keys];
		
		///原始滤镜
		GPUImageBrightnessFilter *originFilter = [[GPUImageBrightnessFilter alloc]init];
#warning 强制改大小
		[originFilter forceProcessingAtSize:[UIScreen mainScreen].bounds.size];
		//		[originFilter forceProcessingAtSize:CGSizeMake(320, 480)];
		
		self.originFilter = originFilter;
		[originFilter release];
		
		self.pickerState = CYImagePickerStateCapture;
		if (self.pickerState == CYImagePickerStateCapture &&
			![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
			self.pickerState = CYImagePickerStateEditing;
		}
		
		//标记是否涂鸦 还是输入框
		self.imageEditMode = CYImageEditModeText;
		
		self.snapTimesSelectArray = [NSMutableArray arrayWithObjects:
									 @"       1 second",
									 @"       2 seconds",
									 @"       3 second",
									 @"       4 seconds",
									 @"       5 seconds",
									 @"       6 seconds",
									 @"       7 seconds",
									 @"       8 seconds",
									 @"       9 seconds",
									 @"       10 seconds",nil];
		_snapDismissTimeSecond = 3;
	}
    return self;
}

- (id)initWithState:(CYImagePickerState) state editImage:(UIImage *)editImage{
	if (self = [self init]) {
		
		self.pickerState = state;
		if (CYImagePickerStateEditing == self.pickerState   && editImage ) {
			self.editImage = editImage;
		}
		
		if (self.pickerState == CYImagePickerStateCapture &&
			![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
			self.pickerState = CYImagePickerStateEditing;
		}
	}
	return self;
}

#pragma mark common init filters
/*
 *	初始化滤镜的一些操作
 */
- (void)commonInitFilter{
	////test
	
	//	avCapture = [[CYImageAVCapture alloc]initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
	//	avCapture.previewView = self.filterBackView;
	//	avCapture.delegate = self;
	//	return ;
	
	//默认是自动闪光 后相机 拍照模式
	if ( self.pickerState == CYImagePickerStateCapture &&
		[UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
		if (!_stillCameraBack &&  CYImagePickerStateCapture == self.pickerState ) {
			_stillCameraBack = [[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPresetMedium
																  cameraPosition:AVCaptureDevicePositionBack];
			_stillCameraBack.outputImageOrientation = UIInterfaceOrientationPortrait;
			NSError *error = nil;
			[_stillCameraBack.inputCamera lockForConfiguration:&error];
			if (!error) {
				if ([_stillCameraBack.inputCamera isFlashModeSupported:AVCaptureFlashModeAuto]) {
					[_stillCameraBack.inputCamera setFlashMode:AVCaptureFlashModeAuto];
				}
			}
			[_stillCameraBack.inputCamera unlockForConfiguration];
		}
	}
	self.currentFilterIndex = 0; //没有滤镜
	[self resetFilter];
}

#pragma mark - view life
- (void)loadView{
	[super loadView];
	
	screenWidth = [UIScreen mainScreen].bounds.size.width;
	screenHeight = [UIScreen mainScreen].bounds.size.height;
	
	self.containerView = [[[CYPassthroughView alloc]initWithFrame:CGRectMake(0,
																			 0,
																			 [UIScreen mainScreen].bounds.size.width,
																			 [UIScreen mainScreen].bounds.size.height)]autorelease];
	self.containerView.userInteractionEnabled = YES;
	self.containerView.backgroundColor = [UIColor clearColor];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToShowInputTextField:)];
	[self.containerView addGestureRecognizer:tap];
	//	self.view = self.containerView;
	tap.delegate = self;
	[tap release];
	
	//涂鸦图层
	CYScrawlView *scrawView = [[CYScrawlView alloc]initWithFrame:self.filterBackView.frame];
	//	scrawView.backgroundColor = [UIColor greenColor];
	
	tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToShowInputTextField:)];
	self.snapScrawlView = scrawView;
	[scrawView addGestureRecognizer:tap];
	tap.delegate = self;
	[tap release];
	
	scrawView.delegate = self;
	[scrawView release];
	
//	self.view = self.containerView;
	[self.view addSubview:scrawView];
	[self.view addSubview:self.filterBackView];
	
	
	[self.view addSubview:self.containerView];

	self.view.backgroundColor = [UIColor clearColor];
	self.view.userInteractionEnabled = YES;
	[self.containerView addSubview:self.filterSelectScrollView];
	
	//旋转摄像头。。。将切换按钮加到预览图上面
	[self.view addSubview:self.turnCameraDeviceButton];
	[self.view addSubview:self.flashChangeButton];
	self.flashChangeButton.hidden = NO;
	//底部布局
	[self.view addSubview:self.bottomBarView];
	[self.view addSubview:self.showSelectViewButton];
	//定焦标记 插入的位置就在取景图层上面
	[self.view insertSubview:self.focusCameraFlagView aboveSubview:self.filterBackView];
	
	///适合snap
	[self.containerView addSubview:self.snapInputTextField];
	[self.containerView addSubview:self.snapRetakeButton];
	[self.containerView addSubview:self.snapSendButton];
	[self.containerView addSubview:self.snapSetTimeButton];
	[self.containerView addSubview:self.snapSaveToAlbumButton];
	[self.containerView addSubview:self.snapPickerView];
	[self.containerView addSubview:self.snapInputTextField];
	
	//颜色拾取器
	self.colorBarPicker = [[[InfColorBarPicker alloc]initWithFrame:CGRectMake(80, 0, 150, 20)]autorelease];
	self.colorBarView  = [[[InfColorBarView alloc]initWithFrame:_colorBarPicker.frame]autorelease];
	[self.containerView addSubview:self.colorBarView];
	[self.containerView addSubview:self.colorBarPicker];
	
	//穿透touch
	self.containerView.passthroughViews = [NSMutableArray arrayWithObjects:self.snapScrawlView, nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
 	///http://stackoverflow.com/questions/5957903/providing-autorotation-support-to-a-subview-loaded-programmatically-ipad
	
	
	[[UIDevice currentDevice]beginGeneratingDeviceOrientationNotifications];
	
	[self commonInitFilter];
	[self processPatternImage];
}

 
- (void)protectSomeSubViewNonAutoRotate{
 	
	if (self.pickerState == CYImagePickerStateEditing) {
		[self.filterBackView removeFromSuperview];
		[self.snapScrawlView removeFromSuperview];

		[self.view.window addSubview:self.filterBackView];
		[self.view.window addSubview:self.snapScrawlView];
		
		[self.view.window sendSubviewToBack:self.filterBackView	];
		[self.view.window sendSubviewToBack:self.snapScrawlView];
	}
}


- (void)recoverSomeSubViewNonAutoRotate{
	
	if (self.pickerState == CYImagePickerStateCapture) {
		[self.filterBackView removeFromSuperview];
		[self.snapScrawlView removeFromSuperview];
		
		[self.view insertSubview:self.filterBackView atIndex:0];
		[self.view insertSubview:self.snapScrawlView atIndex:1];
		[self.view.window bringSubviewToFront:self.view];
	}
		
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    NSLog(@"～～～～～～～～～～～～～～～didReceiveMemoryWarning = %@",[[self class] description]);
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	RELEASE_SAFELY(_turnCameraDeviceButton);
	RELEASE_SAFELY(_bottomBarView);
	RELEASE_SAFELY(_flashChangeButton);
	RELEASE_SAFELY(_startCaptureButton);
	RELEASE_SAFELY(_filterSelectScrollView);
	RELEASE_SAFELY(_pickPictureButton);
	RELEASE_SAFELY(_cancelPickButton);
 	RELEASE_SAFELY(_filterBackView);
	RELEASE_SAFELY(_focusCameraFlagView);
	RELEASE_SAFELY(_snapInputTextField);
	NSLog(@"@@@@@@@@@@@@@内存警告！！！！！！！！！！！！！！");
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	//隐藏状态栏
	[[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	
	//监控对焦
	AVCaptureDevice *device = [ _stillCameraBack inputCamera ];
	if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus] || [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
		[device addObserver:self forKeyPath:@"adjustingFocus" options:NSKeyValueObservingOptionNew context:nil];
	}
	showBigFocusCameraFlag = YES;
	
	[self checkInterfaceElementHiddenOrNot];
}

/*
 * 加载完毕
 */
- (void)viewDidAppear:(BOOL)animated{
	
	[super viewDidAppear:animated];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
	
	//	[avCapture startCameraCapture];
	//	return;
	
	if (self.pickerState == CYImagePickerStateEditing
		&& !self.editPicture) {
		
		[self performSelector:@selector(clickPickPictureButton) withObject:nil afterDelay:4];
		return;
	}
	
	[self prepareTarget];
	
	if (CYImagePickerStateCapture == self.pickerState) {
		[self focusCameraAtPoint:CGPointMake(0.5, 0.5)];//自动对焦到中间
	}
}

/*	准备开始采集
 */
- (void)prepareToCapture{
	[self prepareTarget];
	
}
/*	界面消失
 */
- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
    [_stillCameraBack pauseCameraCapture];
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
	
	AVCaptureDevice *device = [ _stillCameraBack inputCamera ];
	
	if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]
		|| [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
		[device removeObserver:self forKeyPath:@"adjustingFocus"];
	}
	showBigFocusCameraFlag = NO;
}

#pragma mark view
/*
 *	滤镜预览
 */
- (GPUImageView *)filterBackView{
	if (!_filterBackView) {
		UIScreen *screen = [UIScreen mainScreen];
		_filterBackView = [[GPUImageView alloc]initWithFrame:CGRectMake(0,
																		0,
																		screen.bounds.size.width,
																		screen.bounds.size.height )];
		_filterBackView.backgroundColor = [UIColor clearColor];
		_filterBackView.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusCameraTapGesture:)];
		[_filterBackView addGestureRecognizer:tap];
		tap.delegate = self;
		[tap release];
		
	}
	return _filterBackView;
}

/*	左滑动手势
 */
- (UISwipeGestureRecognizer *)swipeLeftGestureRecognizer{
	if (!_swipeLeftGestureRecognizer) {
		UISwipeGestureRecognizer *swipe =
		[[ UISwipeGestureRecognizer alloc]initWithTarget: self action:@selector(swipeToChangeFilter:)];
        [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
		_swipeLeftGestureRecognizer = swipe;
		[_filterBackView addGestureRecognizer:swipe];
	}
	return _swipeLeftGestureRecognizer;
}

/*	右边滑动手势
 */
- (UISwipeGestureRecognizer *)swipeRightGestureRecognizer{
	if (!_swipeRightGestureRecognizer) {
		UISwipeGestureRecognizer *swipe = [[ UISwipeGestureRecognizer alloc]initWithTarget: self action:@selector(swipeToChangeFilter:)];
        [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
		[_filterBackView addGestureRecognizer:swipe];
		_swipeRightGestureRecognizer = swipe;
	}
	return _swipeRightGestureRecognizer;
}
/*	底部栏
 */
- (UIView *)bottomBarView{
	
	if (!_bottomBarView) {
		
		UIImage *bgImage = [UIImage imageNamed:@"bottombar.png"];
		UIView *bottomBarView = [[UIView alloc]initWithFrame:CGRectMake(0,
																		[UIScreen mainScreen].bounds.size.height - kBottomBarViewHeight,
																		kBottomBarViewWidth,
																		kBottomBarViewHeight)];
		bottomBarView.backgroundColor = [UIColor grayColor];
		
		bottomBarView.alpha = 1;
		bottomBarView.userInteractionEnabled = YES;
		
		UIImageView *bgImageView =[[[UIImageView alloc]initWithImage:bgImage]autorelease];
		bgImageView.frame = CGRectMake(0,
									   - (bgImage.size.height - kBottomBarViewHeight),
									   bgImage.size.width,
									   bgImage.size.height);
		[bottomBarView addSubview:bgImageView];
		
		_bottomBarView = bottomBarView;
		[_bottomBarView addSubview:self.startCaptureButton];
		[_bottomBarView addSubview:self.pickPictureButton];
		[_bottomBarView addSubview:self.cancelPickButton];
	}
	return _bottomBarView;
}

/*
 *	滤镜选择列表
 */
- (UIScrollView *)filterSelectScrollView{
	
	if (!_filterSelectScrollView) {
		_isFilterSelectScrollViewHidden = YES;
		//背景
		UIImage *bgImage = [UIImage imageNamed:@"filter_select_bg.png"];
		
		CGFloat y = _isFilterSelectScrollViewHidden?kFilterSelectViewDownY:kFilterSelectViewUpY;
		UIScrollView *filterSelectView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, y, 320, bgImage.size.height)];
		filterSelectView.userInteractionEnabled = YES;
		filterSelectView.backgroundColor = [UIColor clearColor];
		filterSelectView.showsVerticalScrollIndicator  = NO;
		filterSelectView.showsHorizontalScrollIndicator = NO;
		
		[filterSelectView setBackgroundColor:[UIColor colorWithPatternImage:bgImage]];
		
		UIImage *buttonbgImage = [UIImage imageNamed:@"filter_pattern.png"];
		CGFloat buttonWidth = buttonbgImage.size.width ;
		CGFloat buttonHeight = buttonbgImage.size.height ;
		
		NSInteger count =  [self.jsonObjectArray count]; // kFiltersCount;
		NSInteger x = 0;
		
		filterSelectView.contentSize = CGSizeMake(count * buttonWidth, buttonHeight);
		filterSelectView.contentSize = CGSizeMake(10 + (count)*(buttonWidth+6), buttonHeight);
		
		for (int i = 0 ; i < count; i ++) {
			x = 10 + i *( buttonWidth  + 6);
			UIButton *oneeffect = [UIButton buttonWithType:UIButtonTypeCustom];
			[oneeffect setImage:buttonbgImage forState:UIControlStateNormal];
			[oneeffect setImage:buttonbgImage forState:UIControlStateSelected];
			
			oneeffect.tag = i; //编号
			[oneeffect setFrame:CGRectMake(x, (kFilterSelectViewHeight - buttonHeight - 2 - 13)/2, buttonWidth, buttonHeight )];
			[oneeffect setBackgroundColor:[UIColor clearColor]];
			
			NSString *titile = [[self.jsonObjectArray objectAtIndex:i] objectForKey:@"filterName"];
			UILabel *nameLabel = [[UILabel alloc]init];
			nameLabel.backgroundColor = [UIColor clearColor];
			nameLabel.text = titile;
			nameLabel.font =[UIFont systemFontOfSize:11];
			nameLabel.textColor = [UIColor whiteColor];
			CGSize size = [titile sizeWithFont:nameLabel.font constrainedToSize:CGSizeMake(oneeffect.frame.size.width, 13)];
			nameLabel.frame = CGRectMake(oneeffect.frame.origin.x + (oneeffect.frame.size.width - size.width)/2,
										 oneeffect.frame.origin.y + oneeffect.frame.size.height + 2,
										 size.width,
										 size.height);
			[filterSelectView addSubview:nameLabel];
			[nameLabel release];
  			
			[oneeffect addTarget:self action:@selector(clickSelectFilterButton:) forControlEvents:UIControlEventTouchUpInside];
			[filterSelectView addSubview:oneeffect];
		}
		_filterSelectScrollView = filterSelectView;
		[self resetFilterButtonAppearanceSelectedIndex:0 animationScroll:NO];
	}
	
	return _filterSelectScrollView;
}

/*
 切换摄像头按钮
 */
- (UIButton *)turnCameraDeviceButton{
	if (!_turnCameraDeviceButton) {
		
		UIImage *bgImage = [UIImage imageNamed:@"button_bg.png"];
		bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
		
		UIButton *turnCameraDeviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
		turnCameraDeviceButton.frame = CGRectMake(320 - 10 - 65, 10, 65, 30);
		turnCameraDeviceButton.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
		UIImage *turnImage = [UIImage imageNamed:@"turn_camera.png"];
		[turnCameraDeviceButton setImage:turnImage forState:UIControlStateNormal];
		
		[turnCameraDeviceButton setBackgroundImage:bgImage forState:UIControlStateNormal];
		
		[turnCameraDeviceButton addTarget:self
								   action:@selector(clickturnCameraDeviceButton)
						 forControlEvents:UIControlEventTouchUpInside];
		_turnCameraDeviceButton = [turnCameraDeviceButton retain];
		
	}
	return _turnCameraDeviceButton;
}

/*
 闪光灯切换按钮
 */
- (UIButton *)flashChangeButton{
	if (!_flashChangeButton) {
		
		UIImage *bgImage = [UIImage imageNamed:@"button_bg.png"];
		bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
		
		UIButton *flashChangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		flashChangeButton.frame = CGRectMake(10, 10, 65, 30);
		
		[flashChangeButton setBackgroundColor:[UIColor clearColor]];
		flashChangeButton.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
		
		[flashChangeButton setBackgroundImage:bgImage forState:UIControlStateNormal];
		
		UIImage *flashImage = [UIImage imageNamed:@"flash.png"];
		[flashChangeButton setImage:flashImage forState:UIControlStateNormal];
		[flashChangeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
		[flashChangeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
		
		[flashChangeButton setTitle:@"自动" forState:UIControlStateNormal];
		flashChangeButton.titleLabel.font = [UIFont systemFontOfSize:12];
		[flashChangeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		
		[flashChangeButton addTarget:self
							  action:@selector(clickFlashChangeButton)
					forControlEvents:UIControlEventTouchUpInside];
		_flashChangeButton = [flashChangeButton retain];
		
	}
	return _flashChangeButton;
	
}

/*
 *	拍照按钮
 */
- (UIButton *)startCaptureButton{
	if (!_startCaptureButton) {
		
		UIImage *image = [UIImage imageNamed:@"start_capture.png"];
		UIImage *imageSel = [UIImage imageNamed:@"start_capture_sel.png"];
		
		UIButton *startCaptureButton = [UIButton buttonWithType:UIButtonTypeCustom];
		startCaptureButton.frame = CGRectMake((kBottomBarViewWidth - image.size.width)/2.0,
											  (kBottomBarViewHeight - image.size.height)/2.0,
											  image.size.width,
											  image.size.height);
		[startCaptureButton setImage:image forState:UIControlStateNormal];
		[startCaptureButton setImage:imageSel forState:UIControlStateSelected];
		[startCaptureButton setImage:imageSel forState:UIControlStateHighlighted];
		
		[startCaptureButton addTarget:self
							   action:@selector(takeOnePicture:)
					 forControlEvents:UIControlEventTouchUpInside];
		
		_startCaptureButton = [startCaptureButton retain];
	}
	return _startCaptureButton;
}

/**
 选图按钮
 */
- (UIButton *)pickPictureButton{
	if (!_pickPictureButton) {
		UIImage *image = [UIImage imageNamed:@"pick_picture.png"];
		UIImage *imageSel = [UIImage imageNamed:@"pick_picture_sel.png"];
		
		UIButton *pickPictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
		
		[pickPictureButton setImage:image forState:UIControlStateNormal];
		[pickPictureButton setImage:imageSel forState:UIControlStateSelected];
		[pickPictureButton setImage:imageSel forState:UIControlStateHighlighted];
		
		pickPictureButton.frame = CGRectMake((kBottomBarViewWidth - kBottomBarViewHeight) ,
											 0,
											 kBottomBarViewHeight,
											 kBottomBarViewHeight);
		[pickPictureButton addTarget:self
							  action:@selector(clickPickPictureButton)
					forControlEvents:UIControlEventTouchUpInside];
		
		_pickPictureButton = [pickPictureButton retain];
	}
	return _pickPictureButton;
}

/*	滤镜出现按钮
 */
- (UIButton *)showSelectViewButton{
	
	if (!_showSelectViewButton) {
		UIImage *bgImage = [UIImage imageNamed:@"button_bg.png"];
		bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
		
		UIButton *showSelectViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[showSelectViewButton setBackgroundColor:[UIColor clearColor]];
		showSelectViewButton.autoresizingMask =  UIViewAutoresizingFlexibleWidth ;
		
		UIImage *showImage = [UIImage imageNamed:@"show_filter.png"];
		
		[showSelectViewButton setBackgroundImage:bgImage forState:UIControlStateNormal];
		[showSelectViewButton setImage:showImage forState:UIControlStateNormal];
		
		showSelectViewButton.frame = CGRectMake(kBottomBarViewWidth - 50 - 10,
												self.filterSelectScrollView.frame.origin.y - bgImage.size.height - 5,
												50,
												bgImage.size.height);
		[showSelectViewButton addTarget:self
								 action:@selector(clickShowFilterButton)
					   forControlEvents:UIControlEventTouchUpInside];
		[showSelectViewButton setSelected:NO];
		
		
		_showSelectViewButton = [showSelectViewButton retain];
	}
	return _showSelectViewButton;
}



/*	取消按钮
 */
- (UIButton *)cancelPickButton{
	if (!_cancelPickButton) {
		UIButton *cancelPickButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[cancelPickButton setBackgroundColor:[UIColor clearColor]];
		
		UIImage *image = [UIImage imageNamed:@"cancel_pick.png"];
		UIImage *imageSel = [UIImage imageNamed:@"cancel_pick_sel.png"];
		[cancelPickButton setImage:image forState:UIControlStateNormal];
		[cancelPickButton setImage:imageSel forState:UIControlStateSelected];
		[cancelPickButton setImage:imageSel forState:UIControlStateHighlighted];
		
		cancelPickButton.frame = CGRectMake(0,
											0,
											kBottomBarViewHeight,
											kBottomBarViewHeight);
		[cancelPickButton addTarget:self
							 action:@selector(clickCancelPickButton)
				   forControlEvents:UIControlEventTouchUpInside];
		_cancelPickButton = [cancelPickButton retain];
	}
	return _cancelPickButton;
}

/*	重拍按钮
 */
- (UIButton *)snapRetakeButton{
	if (!_snapRetakeButton) {
		UIButton *retakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[retakeButton setBackgroundColor:[UIColor clearColor]];
		
        UIImage *image = [UIImage imageNamed:@"x.png"];
        UIImage *imageSel = [UIImage imageNamed:@"x_pressed.png"];
        [retakeButton setImage:image forState:UIControlStateNormal];
        [retakeButton setImage:imageSel forState:UIControlStateSelected];
        [retakeButton setImage:imageSel forState:UIControlStateHighlighted];
		
		retakeButton.frame = CGRectMake(0,
										0,
										image.size.width,
										image.size.height);
		[retakeButton addTarget:self
						 action:@selector(clickRetakeButton)
			   forControlEvents:UIControlEventTouchUpInside];
		retakeButton.hidden = YES;
		_snapRetakeButton = [retakeButton retain];
	}
	
	return _snapRetakeButton;
}


/*  取消或者保存 按钮
 */
- (UIButton *)snapSendButton{
	if (!_snapSendButton) {
		
		
		UIImage *image = [UIImage imageNamed:@"Send_Foreground.png"];
		UIImage *imageSel = [UIImage imageNamed:@"Send_Pressed.png"];
		
		
		UIButton *finishPickButton = [UIButton buttonWithType:UIButtonTypeCustom];
		finishPickButton.hidden  = YES;
		[finishPickButton setImage:image forState:UIControlStateNormal];
		[finishPickButton setImage:imageSel forState:UIControlStateSelected];
		[finishPickButton setImage:imageSel forState:UIControlStateHighlighted];
		
		UIImage *imageBg = [UIImage imageNamed:@"Send_Background.png"];
		[finishPickButton setBackgroundImage:imageBg forState:UIControlStateNormal];
		
		[finishPickButton setBackgroundColor:[UIColor clearColor]];
		
		finishPickButton.frame = CGRectMake((kBottomBarViewWidth - image.size.width) ,
											[UIScreen mainScreen].bounds.size.height - kBottomBarViewHeight,
											image.size.width,
											image.size.height);
		[finishPickButton addTarget:self
							 action:@selector(clickFinishPickButton)
				   forControlEvents:UIControlEventTouchUpInside];
		_snapSendButton = [finishPickButton retain];
	}
	return  _snapSendButton;
}
/*
 选择时间
 */
- (UIButton *)snapSetTimeButton{
	if (!_snapSetTimeButton) {
		UIButton *cancelPickButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[cancelPickButton setBackgroundColor:[UIColor clearColor]];
		
		UIImage *image = [UIImage imageNamed:@"Timer.png"];
		UIImage *imageSel = [UIImage imageNamed:@"Timer_Pressed.png"];
		[cancelPickButton setBackgroundImage:image forState:UIControlStateNormal];
		[cancelPickButton setBackgroundImage:image forState:UIControlStateSelected];
		[cancelPickButton setBackgroundImage:imageSel forState:UIControlStateHighlighted];
		
		[cancelPickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[cancelPickButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
		
		NSString *string = [NSString stringWithFormat:@"%d",_snapDismissTimeSecond];
		
		[cancelPickButton setTitle:string
						  forState:UIControlStateNormal];
		
		cancelPickButton.frame = CGRectMake(0,
											[UIScreen mainScreen].bounds.size.height - image.size.height  ,
											image.size.width,
											image.size.height);
		[cancelPickButton addTarget:self
							 action:@selector(clickSnapSetTimeButton:)
				   forControlEvents:UIControlEventTouchUpInside];
		_snapSetTimeButton = [cancelPickButton retain];
	}
	return _snapSetTimeButton;
}

/*	时间拾取器
 */
- (UIPickerView *)snapPickerView{
	if (!_snapPickerView) {
		//默认是隐藏的
		_snapPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,
																		kSnapPickerViewDownY,
																		[UIScreen mainScreen].bounds.size.width,
																		250)];
		_snapPickerView.delegate = self;
		_snapPickerView.dataSource = self;
		_snapPickerView.showsSelectionIndicator = YES;
		
		[_snapPickerView selectRow:_snapDismissTimeSecond -1 inComponent:0 animated:NO];
	}
	
	return _snapPickerView;
}


/*	标记正在对焦
 */
- (UIImageView *)focusCameraFlagView{
	if (!_focusCameraFlagView) {
		UIImage *image = [UIImage imageNamed:@"focus_bigflag.png"];
		_focusCameraFlagView = [[UIImageView alloc]initWithImage:image];
		_focusCameraFlagView.autoresizingMask  = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		_focusCameraFlagView.center = self.filterBackView.center;
		_focusCameraFlagView.alpha = 0.0;//默认隐藏
		_focusCameraFlagView.hidden = YES;
		
		_focusCameraFlagView.userInteractionEnabled = YES;
	}
	return _focusCameraFlagView;
}

/*	附加的文字输入框
 */
- (UITextField *)snapInputTextField{
	if (!_snapInputTextField) {
		
		_snapInputTextField = [[UITextField alloc ]initWithFrame:CGRectMake(0,
																			screenHeight,
																			screenWidth,
																			kSnapInputTextFieldHeight)];
		_snapInputTextField.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
		_snapInputTextField.returnKeyType = UIReturnKeyDone;
		_snapInputTextField.delegate = self;
	}
	return _snapInputTextField;
}

#pragma mark - move select filterscrollview

/*
 *	下拉滤镜选择列表
 */
- (void)pullFilterSelectScrollViewDown{
	[self.showSelectViewButton setSelected:NO];
	
	if (_isFilterSelectScrollViewHidden) {
		return;
	}else {
		[self.showSelectViewButton setEnabled:NO];
		[UIView animateWithDuration:0.2 animations:^(){
			CGRect r = self.filterSelectScrollView.frame ;
			self.filterSelectScrollView.frame = CGRectMake(r.origin.x,
														   kFilterSelectViewDownY,
														   r.size.width,
														   r.size.height);
			r = self.showSelectViewButton.frame;
			self.showSelectViewButton.frame = CGRectMake(r.origin.x,
														 self.filterSelectScrollView.frame.origin.y - r.size.height - 5,
														 50,
														 r.size.height);
		}completion:^(BOOL finished){
			self.isFilterSelectScrollViewHidden = YES;
			[self.showSelectViewButton setEnabled:YES];
		}];
		
	}
}

/*
 *	上推滤镜选择列表
 */
- (void)pushFilterSelectScrollViewUp{
	
	[self.showSelectViewButton setSelected:YES];
	
	if (!_isFilterSelectScrollViewHidden) {
		return;
	}else {
		[self.showSelectViewButton setEnabled:NO];
		
		[UIView animateWithDuration:0.2 animations:^(){
			CGRect r = self.filterSelectScrollView.frame;
			self.filterSelectScrollView.frame = CGRectMake(r.origin.x,
														   kFilterSelectViewUpY,
														   r.size.width,
														   r.size.height);
			
			r = self.showSelectViewButton.frame;
			self.showSelectViewButton.frame = CGRectMake(r.origin.x,
														 self.filterSelectScrollView.frame.origin.y - r.size.height - 5,
														 50,
														 r.size.height);
		}completion:^(BOOL finished){
			self.isFilterSelectScrollViewHidden = NO;
			[self.showSelectViewButton setEnabled:YES];
		}];
		
	}
}

#pragma mark - event action

/*
 滤镜选中事件
 */
- (void)clickSelectFilterButton:(id)sender{
	if (self.filterSelectScrollView.userInteractionEnabled == NO) {
		return;
	}
	
	NSLog(@"click select button tag %d",((UIButton *)sender).tag);

	NSInteger index = ((UIButton *)sender).tag;
	if (index < [self.jsonObjectArray count] && index >= 0) {
		self.currentFilterIndex = index;
	}
}

/*	闪光灯切换
 */
- (void)clickFlashChangeButton{
	
	//流程应该这样：自动-->打开-->关闭-->自动
	NSError *error = nil;
	//操作硬件应该先加上锁
	[_stillCameraBack.inputCamera lockForConfiguration:&error];
	if (!error) {
		
		if ([_stillCameraBack.inputCamera isFlashModeSupported:AVCaptureFlashModeOn]
			&&_stillCameraBack.inputCamera.flashMode == AVCaptureFlashModeAuto) {
			
			_stillCameraBack.inputCamera.flashMode = AVCaptureFlashModeOn ;
			[self.flashChangeButton setTitle:@"打开" forState:UIControlStateNormal];
			
		}else if ([_stillCameraBack.inputCamera isFlashModeSupported:AVCaptureFlashModeOff]
				  &&_stillCameraBack.inputCamera.flashMode == AVCaptureFlashModeOn){
			
			_stillCameraBack.inputCamera.flashMode = AVCaptureFlashModeOff;
			[self.flashChangeButton setTitle:@"关闭" forState:UIControlStateNormal];
			
		}else{
			if ([_stillCameraBack.inputCamera isFlashModeSupported:AVCaptureFlashModeAuto]) {
				_stillCameraBack.inputCamera.flashMode = AVCaptureFlashModeAuto;
				[self.flashChangeButton setTitle:@"自动" forState:UIControlStateNormal];
			}
		}
		
	}
	[_stillCameraBack.inputCamera unlockForConfiguration];
}
/*
 摄像头旋转
 */
- (void)clickturnCameraDeviceButton{
	[avCapture rotateCamera];
	
	if (self.pickerState == CYImagePickerStateCapture) {
		[_stillCameraBack rotateCamera];
	}
	
	//决定是否隐藏闪光灯按钮
	if ([_stillCameraBack cameraPosition] == AVCaptureDevicePositionBack) {
		self.flashChangeButton.hidden = NO;
	}else{
		self.flashChangeButton.hidden = YES;
	}
	
	return;
}

/*
 *	选择一张照片
 */
- (void)clickPickPictureButton{
	
	if (!_localImagePickerController) {
		_localImagePickerController = [[UIImagePickerController alloc]init];
	}
	[_localImagePickerController setDelegate:self];
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
		_localImagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
#ifdef __IPHONE_6_0
	[self presentViewController:_localImagePickerController animated:NO completion:^(){
		
	}];
#elif
	[self presentModalViewController:_localImagePickerController animated:NO ];
#endif
	
}



/*	点击滤镜出现按钮
 */
- (void)clickShowFilterButton{
	
	if (self.showSelectViewButton.selected) {
		
		[self pullFilterSelectScrollViewDown];
	}else{
		
		[self pushFilterSelectScrollViewUp];
	}
}

/*	点击结束或保存按钮
 */
- (void)clickFinishPickButton{
	if (self.pickerState == CYImagePickerStateEditing) {
		self.filterSelectScrollView.userInteractionEnabled = NO;
		UIImage * image = [self.filterBack  imageFromCurrentlyProcessedOutput];
		
		//imageFromCurrentlyProcessedOutputWithOrientation:staticPictureOriginalOrientation];
		
		//		if (image) {
		//			UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
		//		}
		//混合涂鸦层面
        UIImage *mixImage = [self capturedImage:image MixWithScrawlView:self.snapScrawlView];
		
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
		if (image) {
			[dic setValue:mixImage forKey:kCYImagePickerImage];
			[dic setValue:[NSNumber numberWithInteger:self.snapDismissTimeSecond] forKey:kCYImagePickerDismissTimeSeconds];
		}
		
//		UIImageView *imageView = [[[UIImageView alloc]initWithImage:mixImage]autorelease];
//		[self.view addSubview:imageView];
		
		if (self.delegate && [self.delegate respondsToSelector:@selector(cyImagePickerController:didFinishPickingMediaWithInfo:)]){
			[self.delegate cyImagePickerController:self didFinishPickingMediaWithInfo:dic];
		}
		
	}else if(self.pickerState == CYImagePickerStateCapture){
        if (self.delegate && [self.delegate respondsToSelector:@selector(cyImagePickerControllerDidCancel:)]){
            [self.delegate cyImagePickerControllerDidCancel:self];
        }
	}else{
		
	}
}

/*	混合最终的图片
 */
- (UIImage * )capturedImage :(UIImage *)image MixWithScrawlView:(UIView *)scrawlView{
	
	UIGraphicsBeginImageContext(image.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:scrawlView.bounds];
	[scrawlView.layer renderInContext:context];
	UIImage *imageresult = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    return imageresult;
}

/*	取消按钮
 */
- (void)clickCancelPickButton{
	
	//	if(self.pickerState == CYImagePickerStateCapture){
	
	[_stillCameraBack stopCameraCapture];
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(cyImagePickerControllerDidCancel:)]){
		[self.delegate cyImagePickerControllerDidCancel:self];
	}
	
	//	}
}

/*
 重拍一张照片
 */
- (void)clickRetakeButton{
	[self.snapScrawlView removeAllPaintPath];
	//	[avCapture startCameraCapture];
	[self layoutSubView:UIInterfaceOrientationPortrait];//布局成正常的
	
	self.pickerState = CYImagePickerStateCapture;
	
	if (self.pickerState == CYImagePickerStateCapture) {
		
		[self retakeOnePictureWhenEditing];
		[self focusCameraAtPoint:CGPointMake(0.5, 0.5)];//自动对焦到中间
	}
}

/*	点击修改时间按钮
 */
- (void)clickSnapSetTimeButton:(id)sender{
	
	[self showTimePicker];
}


/*	展示时间
 */
- (void)showTimePicker{
	[UIView animateWithDuration:0.2 animations:^() {
		self.snapPickerView.frame = CGRectMake(0,
											   self.snapPickerView.superview.bounds.size.height - 250 + 40,
											   self.snapPickerView.bounds.size.width,
											   self.snapPickerView.bounds.size.height);
	}];
}

/*
 隐藏时间
 */
- (void)hiddenTimePicker{
	[UIView animateWithDuration:0.2 animations:^() {
		self.snapPickerView.frame = CGRectMake(0,
											   kSnapPickerViewDownY,
											   self.snapPickerView.bounds.size.width,
											   self.snapPickerView.bounds.size.height);
	}];
}


/*	保存到相册
 */
- (UIButton *)snapSaveToAlbumButton{
	if (!_snapSaveToAlbumButton) {
		UIButton *cancelPickButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[cancelPickButton setBackgroundColor:[UIColor clearColor]];
		
		//保存按钮
		UIImage *image = [UIImage imageNamed:@"Save.png"];
		UIImage *imageSel = [UIImage imageNamed:@"Save_Pressed.png"];
		[cancelPickButton setImage:image forState:UIControlStateNormal];
		[cancelPickButton setImage:imageSel forState:UIControlStateSelected];
		[cancelPickButton setImage:imageSel forState:UIControlStateHighlighted];
		
		UIImage *imageDisable = [UIImage imageNamed:@"Saved.png"];
		
		[cancelPickButton setImage:imageDisable forState:UIControlStateDisabled];
		
		[cancelPickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		
		
		cancelPickButton.frame = CGRectMake(self.snapSetTimeButton.frame.origin.x + self.snapSetTimeButton.frame.size.width  ,
											[UIScreen mainScreen].bounds.size.height - image.size.height  ,
											image.size.width,
											image.size.height);
		[cancelPickButton addTarget:self
							 action:@selector(clickSnapSaveToAlbumButton)
				   forControlEvents:UIControlEventTouchUpInside];
		_snapSaveToAlbumButton = [cancelPickButton retain];
	}
	return _snapSaveToAlbumButton;
}

/*	保存相册
 */
- (void)clickSnapSaveToAlbumButton{
	UIImage *image = [self.filterBack  imageFromCurrentlyProcessedOutput];//imageFromCurrentlyProcessedOutputWithOrientation:staticPictureOriginalOrientation];
	
	UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

/*	保存相册
 */
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
	if (error != NULL)
    {
		// Show error message...
		
    }
    else  // No errors
    {
		self.snapSaveToAlbumButton.enabled = NO;
    }
}


/* 设置按钮外观
 */
- (void)resetFilterButtonAppearanceSelectedIndex:(int)currentFilterIndex animationScroll:(BOOL)animationScroll{
	
	for(UIView *view in _filterSelectScrollView.subviews){
        if([view isKindOfClass:[UIButton class]]){
			UIButton *button = (UIButton * )view;
			if (button.tag != currentFilterIndex) {
				[(UIButton *)button setSelected:NO];
			}
			else{
				[button setSelected:YES];
				if (animationScroll) {
					CGFloat x = button.frame.origin.x - 100;
					if (x < 0) {
						x = 0;
					}
					if (x > self.filterSelectScrollView.contentSize.width - self.filterSelectScrollView.frame.size.width) {
						x = self.filterSelectScrollView.contentSize.width - self.filterSelectScrollView.frame.size.width;
					}
					[self.filterSelectScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
				}
			}
			
			button.layer.cornerRadius = 15.0f;
			button.layer.masksToBounds = YES;
			button.clipsToBounds = YES;
			
			if (!button.isSelected) {
				button.layer.borderWidth = 4.5;
				button.layer.borderColor = [[UIColor clearColor] CGColor];
			}else{
				button.layer.borderWidth = 4.5;
				button.layer.borderColor = [[UIColor redColor] CGColor];
			}
        }
    }
}



/*	展示大标记的对焦
 */
- (void)showFocusCameraFlagView:(NSTimeInterval )animationTime locationPoint:(CGPoint)point{
	UIImage *image = nil;
 	if (!showBigFocusCameraFlag) {
		image = [UIImage imageNamed:@"focus_littleflag.png"];
		self.focusCameraFlagView.image = image;
		self.focusCameraFlagView.frame = CGRectMake(point.x - image.size.width / 2 - 25,
													point.y - image.size.height / 2 - 25,
													image.size.width + 50, image.size.height + 50);
		
	}else{
		image = [UIImage imageNamed:@"focus_bigflag.png"];
		self.focusCameraFlagView.image = image;
		self.focusCameraFlagView.frame = CGRectMake(point.x - image.size.width / 2 - 50,
													point.y - image.size.height / 2 - 50,
													image.size.width + 100,
													image.size.height + 100);
		
	}
	
	self.focusCameraFlagView.alpha = 1.0;
	self.focusCameraFlagView.hidden = NO;
	[UIView animateWithDuration:animationTime delay:0 options:UIViewAnimationCurveEaseOut animations:^(){
		self.focusCameraFlagView.frame = CGRectMake(point.x - image.size.width / 2,
													point.y - image.size.height / 2,
													image.size.width,
													image.size.height);
	} completion:^(BOOL finish){
	}];
}

/*	隐藏对焦标记
 */
- (void)hiddenFocusCameraFlagView:(NSTimeInterval)autoHiddenTimeInterval{
	NSLog(@"隐藏");
	[UIView animateWithDuration:autoHiddenTimeInterval animations:^() {
		self.focusCameraFlagView.hidden = YES;
	}];
}
#pragma mark - 拍照

/*
 拍摄一张照片并记录
 */
- (void)takeOnePicture:(id)sender{
	//	[avCapture captureToGetResult];
	//
	[self showFlashEffect];
	
	if (CYImagePickerStateCapture == self.pickerState ) {
		
        [self takeOnePictureWhenCapturing];
		
    }else{//可能是视频  gif
		
	}
}


/*	显示拍照一闪的效果
 */
- (void)showFlashEffect{
	// Flash the screen white and fade it out to give UI feedback that a still image was taken
	//    UIView *flashView = [[UIView alloc] initWithFrame:[[avCapture previewView] frame]];
	UIView *flashView = [[UIView alloc] initWithFrame:[self.filterBackView frame]];
	
    [flashView setBackgroundColor:[UIColor whiteColor]];
    [[[self view] window] addSubview:flashView];
    
    [UIView animateWithDuration:.5f
                     animations:^{
                         [flashView setAlpha:0.f];
                     }
                     completion:^(BOOL finished){
                         [flashView removeFromSuperview];
                         [flashView release];
                     }
     ];
}

/*
 正在动态滤镜状态下拍照
 */
- (void)takeOnePictureWhenCapturing{
	self.startCaptureButton.hidden = YES;
    self.filterSelectScrollView.userInteractionEnabled = NO;
	self.pickerState = CYImagePickerStateEditing;
	
	
	
	
	@autoreleasepool {
        __block UIImage * caputuredImage = nil;
		
		[_stillCameraBack capturePhotoAsImageProcessedUpToFilter:self.originFilter
										   withCompletionHandler:^(UIImage *image, NSError *error){
											   caputuredImage = image;
											   NSLog(@"图片的大小 ：%@",NSStringFromCGSize(image.size));
											   
											   NSLog(@"retain count %d image retaincount %d",[caputuredImage retainCount],[image retainCount]);
											   NSData *highQualityData = UIImageJPEGRepresentation(image,1.0);
											   NSLog(@"图片的大小：%d",highQualityData.length / 1024);
											   
											   //限制图片大小
											   CGSize size = image.size;
											   if (size.width > kMaxImageWidth) { //限制图片质量
												   caputuredImage = [image scaleImage:image  toScale: kMaxImageWidth / size.width];
											   }
											   NSLog(@"retain count %d image retaincount %d",[caputuredImage retainCount],[image retainCount]);
											   
											   
											   runOnMainQueueWithoutDeadlocking( ^(){
												   staticPictureOriginalOrientation = caputuredImage.imageOrientation;
												   GPUImagePicture *editPicture = [[GPUImagePicture alloc] initWithImage:caputuredImage smoothlyScaleOutput:NO];
												   self.editPicture = editPicture;
												   [editPicture release];
												   
												   [self prepareTarget];
												   //等照片数据读取完之后，比如做照片收缩动画等操作。
												  
												   
												   
												   
												   
												   //为了防止两个图片自动旋转
												   [self protectSomeSubViewNonAutoRotate];
												   
												   
												   
												   //                                                       [self pushFilterSelectScrollViewUp];
												   self.filterSelectScrollView.userInteractionEnabled = YES;
											   });
										   }];
    }
}

/*
 正在编辑状态下 点击拍照
 */
- (void)retakeOnePictureWhenEditing{

    if (_stillCameraBack && [UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.filterSelectScrollView.userInteractionEnabled = NO;
		
        //如果正在编辑状态 直接返回 暂时这样处理
        self.pickerState = CYImagePickerStateCapture;
		
		
		//为了去掉保护自动旋转
		[self recoverSomeSubViewNonAutoRotate];
		
		
		self.startCaptureButton.hidden = YES;
		
		[_stillCameraBack resumeCameraCapture];
		
		//重启实时滤镜
		[self resetFilter];
		[self prepareTarget];
		
		//出现拍照按钮
		self.startCaptureButton.hidden = NO;
		self.filterSelectScrollView.userInteractionEnabled = YES;
		
    }else{
		[self clickCancelPickButton];
	}
}



#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
	
	return YES;
}

/*	点击某个点 自动对焦
 */
- (void) focusCameraAtPoint:(CGPoint)point
{
    AVCaptureDevice *device = [ _stillCameraBack inputCamera ];
	
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
		
        NSError *error;
		//设置自动对焦的位置
        if ([device lockForConfiguration:&error]) {
			[device setFocusPointOfInterest:point];
			[device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        }
    }
}

/*	对焦摄像头 点击事件
 */
- (void)focusCameraTapGesture:(UITapGestureRecognizer *)recognizer{
	
	if (self.pickerState == CYImagePickerStateCapture ) {
		CGPoint point = [recognizer locationInView:recognizer.view];
		
		point.x = point.x / self.filterBackView.frame.size.width;
		point.y = point.y / self.filterBackView.frame.size.height;
		
		[self focusCameraAtPoint:point];
		
		AVCaptureDevice *device = [ _stillCameraBack inputCamera ];
		if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]
			|| [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
			//显示小的对焦标记
			point = [recognizer locationInView:self.view];
			showBigFocusCameraFlag = NO;
			[self showFocusCameraFlagView:0.5 locationPoint:point];
		}
	}
	
	if (self.pickerState == CYImagePickerStateEditing) {
		[self hiddenTimePicker];
		
	}
}

/*	左滑右滑动 切换滤镜
 */
- (void)swipeToChangeFilter:(UISwipeGestureRecognizer * )recognizer{
	
	if (self.pickerState == CYImagePickerStateEditing) {
		return;
	}
	NSLog(@"UISwipeGestureRecognizer  direction %d",recognizer.direction);
	if (UISwipeGestureRecognizerDirectionRight == recognizer.direction) {
		self.currentFilterIndex = self.currentFilterIndex + 1;
	}
	if(UISwipeGestureRecognizerDirectionLeft == recognizer.direction){
		self.currentFilterIndex = self.currentFilterIndex - 1;
	}
	
	[self resetFilterButtonAppearanceSelectedIndex:self.currentFilterIndex animationScroll:YES];
}

/*	点击出现输入框
 */
- (void)tapToShowInputTextField:(UITapGestureRecognizer	*)tapGesture{
	
	if (self.pickerState ==CYImagePickerStateEditing) {
		CGPoint tapPoint = [tapGesture locationInView:self.snapInputTextField.superview];
		
		if (self.snapInputTextField.hidden == YES) {
			
			self.snapInputTextField.hidden = NO;
			self.snapInputTextField.center = tapPoint;
			[self.snapInputTextField becomeFirstResponder];
		}else{
			self.snapInputTextField.hidden = YES;
			[self.snapInputTextField resignFirstResponder];
		}
	}else{
		[self focusCameraTapGesture:tapGesture];
	}
	
	//隐藏了
	[self hiddenTimePicker];
}
#pragma mark - setter

/*
 *	重置滤镜类名，将会使得滤镜重置
 */
- (void)setFilterClassNameString:(NSString *)filterClassNameString{
	
	if ([filterClassNameString isEqualToString:@""]) {
		return;
	}
	NSLog(@"filterClassName = %@",filterClassNameString);
	
	NSString *s = [filterClassNameString copy];
	[_filterClassNameString release];
	_filterClassNameString = s;
	
	[self resetFilter];
	[self prepareTarget];
}

/*	重置当前滤镜索引号
 */
- (void)setCurrentFilterIndex:(int)currentFilterIndex{
	
	if (currentFilterIndex < [self.jsonObjectArray count] && currentFilterIndex >= 0) {
		_currentFilterIndex = currentFilterIndex;
	}else{
		return;
	}
	
	int index = currentFilterIndex;
	if (index < self.jsonObjectArray.count) {
		id jsonObject = [self.jsonObjectArray objectAtIndex:index];
		
		NSString *typeString = [jsonObject objectForKey:@"filterTypeEnum"];
		if (typeString) {
			NSLog(@"type string %@",typeString);
			self.filterType = [[filterTypeDic objectForKey:typeString]intValue];
		}
		
        _filterTypeId = [[jsonObject objectForKey:@"filterTypeID"]integerValue]  ;
		
        NSString *filterClassNameString = [jsonObject objectForKey:@"filterAction"];
		self.filterClassNameString = filterClassNameString; //重置类名将会重置滤镜
    }
	
	[self resetFilterButtonAppearanceSelectedIndex:currentFilterIndex animationScroll:NO];
}

/*	原始编辑
 */
- (void)setEditImage:(UIImage *)editImage{
	[_editImage release];
	_editImage = [editImage retain];
	
	if (_editImage) {
		self.editPicture = [[GPUImagePicture alloc]initWithImage:_editImage smoothlyScaleOutput:NO];
	}else{
		self.editPicture = nil;
	}
}
#pragma mark - 滤镜更新
/*
 *	重置滤镜
 */
- (void)resetFilter{
	
	self.filterBack = [self filterFromClassNameString:self.filterClassNameString];
}

/*	通过滤镜名称获取滤镜
 */
- (GPUImageOutput<GPUImageInput> *)filterFromClassNameString :(NSString *)nameString{
	Class filterClass = NSClassFromString(nameString);
	NSLog(@"class name == %@",nameString);
	NSObject *instance = [[filterClass alloc]init];
	self.internalSourcePicture1 = nil;
	self.internalSourcePicture2 = nil;
	self.internalSourcePicture3 = nil;
	self.internalSourcePicture4 = nil;
	self.internalSourcePicture5 = nil;
	
	//曲线调整的滤镜
	if ([instance isKindOfClass:[GPUImageToneCurveFilter class]]){
		
		[instance release];
		
		GPUImageOutput<GPUImageInput> * filter = nil;
		int key = _filterTypeId - 23;
      	switch (key) {
			case 1:{
				filter = [[GPUImageContrastFilter alloc] init];
				[(GPUImageContrastFilter *) filter setContrast:1.75];
			} break;
			case 2: {
				filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"crossprocess"];
			} break;
			case 3: {
				filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"02"];
			} break;
			case 4: {
				filter = [[GPUImageGrayscaleFilter alloc] init];
			} break;
			case 5: {
				filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"17"];
			} break;
			case 6: {
				filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"aqua"];
			} break;
			case 7: {
				filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"yellow-red"];
			} break;
			case 8: {
				filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"06"];
			} break;
			case 9: {
				filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"purple-green"];
			} break;
			case 10: {
				filter = [[GPUImageToneCurveFilter alloc] initWithACV:@"test"];
			} break;
				//添加更多种类的 adobe photoshop 曲线调整文件
			default:
				filter = [[GPUImageRGBFilter alloc] init];
				break;
		}
  		return [filter autorelease];
    }//普通滤镜
    else if ([instance isKindOfClass:GPUImageFilter.class]
			 ||	[instance isKindOfClass:GPUImageFilterGroup.class])
	{
		
		GPUImageOutput<GPUImageInput> *filterBack= (GPUImageOutput<GPUImageInput> *)instance;
  		
        if ([instance isKindOfClass:CYImageFilter.class]){
			CYImageFilter *filter = (CYImageFilter * )filterBack;
			
            self.internalSourcePicture1 = nil;
            self.internalSourcePicture2 = nil;
            self.internalSourcePicture3 = nil;
            self.internalSourcePicture4 = nil;
            self.internalSourcePicture5 = nil;
			
			@autoreleasepool {
				for (int i = 0 ;i < filter.pictureImagePaths.count ; i ++  ){
					GPUImagePicture *picture = nil;
					
					@autoreleasepool {
						NSString *imagePath = [NSString stringWithFormat:@"%@.png",[filter.pictureImagePaths objectAtIndex:i]];
						UIImage * image =   [UIImage imageNamed:imagePath];
						if (image.size.width	> kMaxImageWidth) { //限制图片质量
							image = [image scaleImage:image  toScale: kMaxImageWidth / image.size.width];
						}
						
						picture = [[GPUImagePicture alloc] initWithImage:image];
					}
					//最多就五张图片
					if(0 == i){
						self.internalSourcePicture1 = picture;
						[self.internalSourcePicture1 addTarget: filter atTextureLocation :1];
					} else if(1 == i){
						self.internalSourcePicture2 = picture;
						[self.internalSourcePicture2 addTarget: filter atTextureLocation :2];
					}
					else if(2 == i){
						self.internalSourcePicture3 = picture;
						[self.internalSourcePicture3 addTarget: filter atTextureLocation :3];
					}
					else if(3 == i){
						self.internalSourcePicture4 = picture;
						[self.internalSourcePicture4 addTarget: filter atTextureLocation :4];
					}
					else if(4 == i){
						self.internalSourcePicture5 = picture;
						[self.internalSourcePicture5 addTarget: filter atTextureLocation :5];
					}
					[picture release];
				}
			}
		}
		
		return [filterBack autorelease];
    } //自定义的滤镜
	else if([filterClass.class isSubclassOfClass:CYFilterChain.class ]){
		
		CYFilterChain *filterChain = (CYFilterChain *)instance;
		
		GPUImageOutput<GPUImageInput> *filterBack= [(filterChain).finallyFilter retain];
  		
		self.filterChain = filterChain;
		RELEASE_SAFELY(filterChain);
		
		return [filterBack autorelease];
		
	}else{ //若没有指定滤镜类型，给个原始滤镜，保留原来的画质
		
		GPUImageOutput<GPUImageInput> *filterBack= [[GPUImageBrightnessFilter alloc]init];
  		RELEASE_SAFELY(instance);
		return [filterBack autorelease];
	}
	
}

- (void)removeAllTarget{
	
	[_stillCameraBack removeAllTargets];
	
	[self.editPicture removeAllTargets];
	
	[self.originFilter removeAllTargets];
	
	[self.filterBack removeAllTargets];
	
}
/*
 *	准备采集源i
 */
- (void)prepareTarget{
	[self updateFilterValue:self.filterBack currentSelectIndex:self.currentFilterIndex];
	
    // 实时滤镜
	if (self.pickerState == CYImagePickerStateCapture) {
		[self prepareTargetForLiveCaptureImage];
	}else {
		[self prepareTargetForStaticEditingImage];
	}
}

/*	准备静态编辑滤镜
 */
-(void)prepareTargetForStaticEditingImage{
	
	if (self.editPicture) {
		[self removeAllTarget];
		
		[self.editPicture addTarget:self.originFilter];
		
		[self.originFilter setInputRotation:rotatioMode atIndex:0];
		
		[self.originFilter addTarget:self.filterBack];
		
		[self.filterBack addTarget:self.filterBackView];
		
		[self.editPicture processImage];
	}
}

/*	准备实时采集滤镜
 */
- (void)prepareTargetForLiveCaptureImage{
	
	//此处正常的方向
	staticPictureOriginalOrientation = UIImageOrientationUp;
	
	[_stillCameraBack startCameraCapture];
	[_stillCameraBack resumeCameraCapture];
	
	
	[self removeAllTarget];
	[_stillCameraBack addTarget:self.originFilter];
	
	[self.originFilter addTarget:self.filterBack];
	
	rotatioMode = kGPUImageNoRotation;
	[self.originFilter setInputRotation:rotatioMode atIndex:0];
	
	[self.filterBack addTarget:self.filterBackView];
 	
}

/*
 *	更新滤镜的参数值，更新值的时候要视具体的滤镜类型而定
 */
- (void)updateFilterValue:(GPUImageOutput<GPUImageInput> * )filter currentSelectIndex:(int)index{
    float value = 0.0f;
	id jsonObject = [self.jsonObjectArray objectAtIndex:index];
	
	if ([jsonObject objectForKey:@"value"]) {
		//	更新滤镜参数值
		value =    [[jsonObject objectForKey:@"value"]floatValue];
	}
	NSLog(@"update filter Value");
	
	NSString *typeString = [jsonObject objectForKey:@"filterTypeEnum"];
	if (typeString) {
		NSLog(@"type string %@",typeString);
		self.filterType = [[filterTypeDic objectForKey:typeString]intValue];
	}
	
	switch(_filterType)
	{
		case GPUIMAGE_SEPIA:{
			[(GPUImageSepiaFilter *)filter setIntensity:value];
			
		} break;
			
		case GPUIMAGE_CROSSHATCH: {
			[(GPUImageCrosshatchFilter *)filter setCrossHatchSpacing:value];
			
		} break;
			
		case GPUIMAGE_SWIRL: {
			[(GPUImageSwirlFilter *)filter setAngle:value];
		} break;
			
		case GPUIMAGE_EMBOSS:{
			//	漫画
			[(GPUImageEmbossFilter *)filter setIntensity:value];
		}break;
			
		case GPUIMAGE_PIXELLATE: {
			[(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:value];
			
		} break;
			
		case GPUIMAGE_VIGNETTE: {
			[(GPUImageVignetteFilter *)filter setVignetteEnd:value];
			
		} break;
			
		case GPUIMAGE_GAUSSIAN: {
			[(GPUImageGaussianBlurFilter *)filter setBlurSize:value];
			
		} break;
			
		case GPUIMAGE_BULGE:{
			[(GPUImageBulgeDistortionFilter *)filter setScale:value];
		}break;
			
		case GPUIMAGE_SHARPEN: {
			//锐化
			[(GPUImageSharpenFilter *)filter setSharpness:value];
		}break;
			
		case GPUIMAGE_MONOCHROME: {
			[(GPUImageMonochromeFilter *)filter setIntensity:value];
		}break;
			
		case GPUIMAGE_GLASSSPHERE:{
			[(GPUImageGlassSphereFilter *)filter setRadius:value];
			[(GPUImageGlassSphereFilter *)filter setRefractiveIndex: 0.6];
			
		}break;
			
		default: break;
	}
}
#pragma mark - other

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
{
	UIImage *img = nil;
	
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context,
								   color.CGColor);
	CGContextFillRect(context, rect);
	img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return img;
}
/*
 *	json解析出来的数组，每个元素是一个dictionary
 */
- (NSArray *)jsonObjectArray{
	if (!_jsonObjectArray) {
		NSString * filePath = [[NSBundle mainBundle] pathForResource:@"filters" ofType:@"json"];
		NSString * jsonString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
		SBJsonParser *sb = [[SBJsonParser alloc]init];
		_jsonObjectArray = [[sb  objectWithString:jsonString] retain];
		[sb release];
		NSLog(@"json data == %@",[_jsonObjectArray description]);
	}
	return _jsonObjectArray;
}

/*	转化滤镜缩略图
 */
- (void)processPatternImage{
	
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(){
		@autoreleasepool {
			for (int i = 1 ; i < [self.jsonObjectArray count]; i ++) {
				NSString *filterNameString = [[self.jsonObjectArray objectAtIndex:i]
											  objectForKey:@"filterAction"];
				if (filterNameString && ![filterNameString isEqualToString:@""]){
					
					NSLog(@"缩略图 class name == %@ %d",filterNameString,i);
					
					
					UIButton *button = (UIButton *) [self.filterSelectScrollView viewWithTag:i];
					UIImage *image = [UIImage imageNamed:@"filter_pattern.png"];
					if (image.scale) {
						image = [image getSubImage:CGRectMake(9, 9, 114, 114) ];
					}else{
						image = [image getSubImage:CGRectMake(4.5, 4.5, 57, 57) ];
					}
					
					GPUImageOutput<GPUImageInput>* filter = [self filterFromClassNameString:filterNameString];
					[self updateFilterValue:filter currentSelectIndex:i];
					
					image = [filter imageByFilteringImage:image];
					
					dispatch_async(dispatch_get_main_queue(), ^(){
						[button setImage:image forState:UIControlStateNormal];
						[button setImage:image forState:UIControlStateSelected];
						button.imageView.layer.cornerRadius = 10;
						button.imageView.layer.masksToBounds = YES;
					});
					
				}
			}
		}
	});
}
#pragma mark - key observe

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	if ([keyPath isEqualToString:@"pickerState"]) {
		[self checkInterfaceElementHiddenOrNot];
	}
	
	if ([keyPath isEqualToString:@"adjustingFocus" ]) {
		NSLog(@"对焦状态改变");
		AVCaptureDevice *device = [ _stillCameraBack inputCamera ];
		if (device.isAdjustingFocus) {
			if (showBigFocusCameraFlag) {
				[self showFocusCameraFlagView:0.2 locationPoint:self.filterBackView.center];
			}
		}else{
			[self hiddenFocusCameraFlagView:2];
		}
	}
}

/*	界面显示状态
 */
- (void)checkInterfaceElementHiddenOrNot{
	BOOL hidden = YES;
	
	if (self.pickerState == CYImagePickerStateEditing) {
		hidden = YES;
		
		[self.filterBackView removeGestureRecognizer:self.swipeLeftGestureRecognizer];
		[self.filterBackView removeGestureRecognizer:self.swipeRightGestureRecognizer];
	}else{
		hidden = NO;
		
		[self.filterBackView addGestureRecognizer:self.swipeLeftGestureRecognizer];
		[self.filterBackView addGestureRecognizer:self.swipeRightGestureRecognizer];
	}
	
	self.pickPictureButton.hidden = hidden;
	self.turnCameraDeviceButton.hidden = hidden;
	self.flashChangeButton.hidden = hidden;
	self.startCaptureButton.hidden = hidden;
 	self.cancelPickButton.hidden = hidden;
	self.focusCameraFlagView.hidden = hidden;
	
	if ([_stillCameraBack cameraPosition] == AVCaptureDevicePositionBack && !hidden ) {
		self.flashChangeButton.hidden = NO;
	}else{
		self.flashChangeButton.hidden = YES;
	}
	//snap
	self.bottomBarView.hidden = hidden;
	self.snapRetakeButton.hidden = !hidden;
	self.snapSaveToAlbumButton.hidden = !hidden;
	self.snapSendButton.hidden = !hidden;
	self.snapSetTimeButton.hidden = !hidden;
	self.showSelectViewButton.hidden = hidden;
	self.filterSelectScrollView.hidden = hidden;
	self.colorBarPicker.hidden = !hidden;
	self.colorBarView.hidden = !hidden;
	self.snapScrawlView.userInteractionEnabled = hidden;
	self.snapScrawlView.hidden = !hidden;
	self.snapInputTextField.hidden = hidden;
}

#pragma mark - 屏幕旋转

#ifdef __IPHONE_6_0
- (BOOL)shouldAutorotate{
	if (self.pickerState == CYImagePickerStateCapture) {
		return NO;
	}
	return YES;
}
- (NSUInteger)supportedInterfaceOrientations{
	
	return UIInterfaceOrientationMaskAllButUpsideDown;
}
#endif


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

	if (self.pickerState == CYImagePickerStateCapture) {
		[super didRotateFromInterfaceOrientation:toInterfaceOrientation];
		return;
	}
	
	self.view.hidden = YES;
	self.containerView.hidden = YES;
	self.containerView.alpha = 0.0f;
	
	[self getUIKeyboardView].hidden = YES;
	[self.view.window bringSubviewToFront:self.filterBackView];
	[self.view.window bringSubviewToFront:self.snapScrawlView];
	
	[self layoutSubView:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	self.view.hidden =  NO;
	self.containerView.hidden = NO;
	self.containerView.alpha = 1.0f;
	
	[self getUIKeyboardView].hidden = NO;
	[self.view.window bringSubviewToFront:self.view];
}

/*	角度到弧度旋转
 */
- (CGAffineTransform)affineTransform:(float)degree{
	
	return CGAffineTransformMakeRotation(degree * M_PI / 180.0f);
}

/*	重新布局子视图
 */
- (void)layoutSubView:(UIInterfaceOrientation)toInterfaceOrientation{
	CGFloat oldSnapPickY = self.snapPickerView.frame.origin.y;
	BOOL isDown = oldSnapPickY == kSnapPickerViewDownY?YES:NO;
	
	screenWidth = [UIScreen mainScreen].bounds.size.width;
	screenHeight = [UIScreen mainScreen].bounds.size.height;
	NSLog(@"屏幕的宽高，%f  %f",screenWidth,screenHeight);
	
	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft
		|| toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		screenWidth = [UIScreen mainScreen].bounds.size.height;
		screenHeight = [UIScreen mainScreen].bounds.size.width;
	}
	//	self.containerView.layer.borderColor = [UIColor redColor].CGColor;
	//	self.containerView.layer.borderWidth = 1.0;
	//
	UIView *keyboard = [self getUIKeyboardView];
	NSLog(@"键盘旋转前的位置 %@",NSStringFromCGRect(keyboard.frame));
	self.containerView.hidden = YES;
	
	BOOL isInputFieldShow = NO;
	
	if( [self.snapInputTextField isEditing] ) {
 		keyboard.hidden = YES;
		isInputFieldShow = YES;
	}
	
	[UIView animateWithDuration:0.1 animations:^(){
		
	}completion:^(BOOL finshed){
		if (finshed) {
			
			self.snapInputTextField.frame = CGRectMake(0,
													   screenHeight - 250,
													   screenWidth,
													   kSnapInputTextFieldHeight);
			
			self.snapRetakeButton.frame = CGRectMake(0,0,self.snapRetakeButton.frame.size.width, self.snapRetakeButton.frame.size.height);
			self.snapSendButton.frame = CGRectMake((screenWidth - self.snapSendButton.frame.size.width) ,
												   screenHeight - kBottomBarViewHeight,
												   self.snapSendButton.frame.size.width,
												   self.snapSendButton.frame.size.height);
			
			self.snapSetTimeButton.frame = CGRectMake(0,
													  screenHeight - self.snapSetTimeButton.frame.size.height  ,
													  self.snapSetTimeButton.frame.size.width,
													  self.snapSetTimeButton.frame.size.height);
			
			self.snapSaveToAlbumButton.frame = CGRectMake(self.snapSetTimeButton.frame.origin.x + self.snapSetTimeButton.frame.size.width  ,
														  screenHeight - self.snapSaveToAlbumButton.frame.size.height  ,
														  self.snapSaveToAlbumButton.frame.size.width,
														  self.snapSaveToAlbumButton.frame.size.height);
			
			
			self.snapPickerView.frame = CGRectMake(self.snapPickerView.frame.origin.x,
												   isDown?kSnapPickerViewDownY:kSnapPickerViewUpY,
												   screenWidth,
												   self.snapPickerView.bounds.size.height);
 			self.containerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
			
			[self.containerView layoutIfNeeded];
			self.containerView.hidden = NO;
		}
	}];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return NO;
}

/*	监测屏幕旋转
 */
- (void)handleOrientationDidChangeNotification:(NSNotification*)notification{
	if (self.pickerState == CYImagePickerStateEditing) {
		NSLog(@"handleOrientationDidChangeNotification  隐藏键盘");
		[self getUIKeyboardView].hidden = YES;
	}
}

#pragma mark - 键盘通知事件

- (void)handleUIKeyboardWillShowNotification:(NSNotification*)notification{
	
	NSDictionary *userInfo = notification.userInfo;
	CGRect  keybordRect ;
	[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]getValue:&keybordRect];
	
	NSNumber *time = nil ;
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]getValue:time];
	
	[UIView animateWithDuration:time.floatValue animations:^() {
		
		self.snapInputTextField.frame  = CGRectMake(self.snapInputTextField.frame.origin.x,
													keybordRect.origin.y - self.snapInputTextField.bounds.size.height,
													screenWidth,
													self.snapInputTextField.frame.size.height);
	}];
}

- (UIView *)getUIKeyboardView{
	//The UIWindow that contains the keyboard view - It some situations it will be better to actually
	//iterate through each window to figure out where the keyboard is, but In my applications case
	//I know that the second window has the keyboard so I just reference it directly
	if ([[UIApplication sharedApplication] windows].count <= 1) {
		return nil;
	}
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	
	//Because we cant get access to the UIPeripheral throught the SDK we will just use UIView.
	//UIPeripheral is a subclass of UIView anyways
	UIView* keyboard = nil;
	
    //Iterate though each view inside of the selected Window
	for(int i = 0; i < [tempWindow.subviews count]; i++)
	{
		//Get a reference of the current view
		keyboard = [tempWindow.subviews objectAtIndex:i];
		
		//Assuming this is for 4.0+, In 3.0 you would use "<UIKeyboard"
		if([[keyboard description] hasPrefix:@"<UIPeripheral"] == YES) {
			//Keyboard is now a UIView reference to the UIPeripheral we want
			NSLog(@"!!!!!!!!!!!!!!Keyboard Frame: %@",NSStringFromCGRect(keyboard.frame));
		}
	}
	keyboard.layer.borderColor = [UIColor yellowColor].CGColor;
	keyboard.layer.borderWidth = 1.0f;
	return keyboard;
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	
	@autoreleasepool {
		//check image
		UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
		CGSize size = image.size;
		if (size.width	> kMaxImageWidth) { //限制图片质量
			
            image = [image scaleImage:image  toScale: kMaxImageWidth / size.width];
		}
		if (!image) {
			NSLog(@"imagePickerController Error, can't get Originalimage");
			return;
		}
		
		staticPictureOriginalOrientation = image.imageOrientation;
		
		GPUImagePicture *editPicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:NO];
		self.editPicture = editPicture;
		[editPicture release];
	}
	self.pickerState = CYImagePickerStateEditing;
	
#ifdef __IPHONE_6_0
	[picker dismissViewControllerAnimated:NO completion:^(){
		
	}];
#elif
	[picker dismissModalViewControllerAnimated:NO];
#endif
	[self resetFilter];
	[self prepareTarget];
	
	[self pushFilterSelectScrollViewUp];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	
#ifdef __IPHONE_6_0
	[picker dismissViewControllerAnimated:NO completion:^(){
		
	}];
#elif
	[picker dismissModalViewControllerAnimated:NO];
#endif
	[self prepareTarget];
	
}


#pragma mark -  UIPickerViewDataSource


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [self.snapTimesSelectArray count];;
}


#pragma mark -	UIPickerViewDelegate
// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
	return pickerView.frame.size.width;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
	return pickerView.frame.size.height / 5;
}

// these methods return either a plain NSString, a NSAttributedString, or a view (e.g UILabel) to display the row for the component.
// for the view versions, we cache any hidden and thus unused views and pass them back for reuse.
// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	return [_snapTimesSelectArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	self.snapDismissTimeSecond = row + 1;
	NSString *string = [NSString stringWithFormat:@"%d",self.snapDismissTimeSecond];
	
	[self.snapSetTimeButton setTitle:string  forState:UIControlStateNormal];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
}

#pragma mark - CYScrawlViewDelegate 涂鸦

- (void)scrawlViewPaintBegain:(CYScrawlView *)scrawlView{
	
	scrawlView.currentPaintColor = [UIColor colorWithHue: self.colorBarPicker.value
											  saturation: 1.0f
											  brightness: 1.0f
												   alpha: 1.0f ];
}

- (void)scrawlViewPaintEnd:(CYScrawlView *)scrawView{
	
}

#pragma mark - CYCaptureDelegate
//开始采集回掉
- (void)cyCaptureWillBeginCapture{
	
	if (![self.view viewWithTag:9999]) {
		UIImageView *previewEditView =[[UIImageView alloc]init];
		previewEditView.layer.borderWidth = 1.0f;
		previewEditView.layer.borderColor = [UIColor redColor].CGColor;
		previewEditView.contentMode = UIViewContentModeScaleAspectFill;
		previewEditView.frame = self.view.bounds;
		previewEditView.backgroundColor = [UIColor clearColor];
		previewEditView.tag = 9999;
		previewEditView.hidden = YES;
		
		NSLog(@"插入预览视图");
 		[self.view insertSubview:previewEditView belowSubview:self.snapScrawlView];
 		
		[previewEditView release];
	}else{
		[self.view viewWithTag:9999].hidden = YES;
	}
}

//采集完毕数据回掉
- (void)cyCaptureDidEndCapture:(NSDictionary *)captureResultDic{
	dispatch_async(dispatch_get_main_queue(), ^(){
		UIImage *image = [captureResultDic objectForKey:kCYImageAVCaptureResult];
		
		UIImageView *previewEditView =(UIImageView *) [self.view viewWithTag:9999];
		NSLog(@"pre tag %d image size %@",previewEditView.tag,NSStringFromCGSize(image.size));
		
		previewEditView.image = image;
		previewEditView.hidden = NO;
	});
}
@end
