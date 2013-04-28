//
//  CYMainViewController.m
//  CYFilter
//
//  Created by yi chen on 12-7-13.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYMainViewController.h"
#import "CYImagePickerController.h"
@interface CYMainViewController ()
@property(nonatomic, retain)CYImagePickerController *showCaseFilterViewController;
@end

@implementation CYMainViewController
@synthesize startButton = _startButton;
@synthesize showCaseFilterViewController = _showCaseFilterViewController;
- (void)dealloc{
	self.startButton = nil;
	self.showCaseFilterViewController = nil;
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
	[super loadView];
	[self.view addSubview: self.startButton];
}

/**
 *	测试按钮
 */
- (UIButton *)startButton{
	if (!_startButton) {
		//test code...
		UIButton *startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		startButton.frame = CGRectMake(50, 50, 100, 50);
		[startButton setTitle:@"开始" forState:UIControlStateNormal];
		[startButton setTitle:@"开始" forState:(UIControlStateHighlighted | UIControlStateSelected ) ];
		[startButton addTarget:self action:@selector(onClickStartButton) forControlEvents:UIControlEventTouchUpInside];
		startButton.backgroundColor = [UIColor clearColor];
		_startButton = [startButton retain];
	}
	return _startButton;
}

- (CYImagePickerController *)showCaseFilterViewController{
	if (!_showCaseFilterViewController) {
		_showCaseFilterViewController = [[CYImagePickerController alloc]init];
		_showCaseFilterViewController.delegate = self;
	}
	return _showCaseFilterViewController;
}

/**
 * 测试按钮点击
 */
- (void)onClickStartButton{
//	CYImagePickController *showCaseFilterViewController = [[CYImagePickController alloc]init];
//	[self presentModalViewController:showCaseFilterViewController animated:YES];
////	[self.navigationController pushViewController:showCaseFilterViewController animated:YES];
//	[showCaseFilterViewController release];
	
	
//	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
////		[self.navigationController pushViewController:showCaseFilterViewController animated:YES];
//		[self presentModalViewController:self.showCaseFilterViewController animated:YES];
//		self.showCaseFilterViewController.pickerState = CYImagePickerStateCapture;
//		self.showCaseFilterViewController.delegate = self;
//
//	}else{
//		UIImagePickerController *pick = [[UIImagePickerController alloc]init];
//		pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//		pick.delegate = self;
////		[self.navigationController pushViewController:pick animated:YES];
//		[self.navigationController presentModalViewController:pick animated:YES];
//		[pick release];
//	}
   
//	NSString *path = [[NSBundle mainBundle]pathForResource:@"test" ofType:@"JPG"];
//	UIImage *testImage = [UIImage imageWithContentsOfFile:path];
//
	CYImagePickerController *showCaseFilterViewController = [[CYImagePickerController alloc]init];
#ifdef __IPHONE_6_0
	[self presentViewController:showCaseFilterViewController animated:NO completion:^(){
		
	}];
#elif
	[self presentModalViewController:showCaseFilterViewController animated:NO ];
#endif
	showCaseFilterViewController.delegate = self;
//
//	//	[self.navigationController pushViewController:showCaseFilterViewController animated:YES];
	[showCaseFilterViewController release];
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.startButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)cyImagePickerController:(CYImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	NSLog(@"picture info dic : %@",info	);
		
	[picker dismissViewControllerAnimated:NO completion:^(){
		
	}];
}
- (void)cyImagePickerControllerDidCancel:(CYImagePickerController *)picker{
	
	if (picker.navigationController) {
		[picker.navigationController popViewControllerAnimated:YES];
		return;
	}
	
	[picker dismissViewControllerAnimated:NO completion:^(){
		
	}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	UIImage *photo = [info objectForKey:UIImagePickerControllerOriginalImage];
	if (photo) {
		self.showCaseFilterViewController.pickerState = CYImagePickerStateEditing;
		self.showCaseFilterViewController.editImage = photo;
		self.showCaseFilterViewController.delegate = self;
		[picker pushViewController:self.showCaseFilterViewController animated:YES];
	}
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[picker dismissModalViewControllerAnimated:YES];
}
@end
