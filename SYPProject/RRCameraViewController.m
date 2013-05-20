//
//  RRCameraViewController.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-3-9.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "RRCameraViewController.h"

@implementation RRCameraViewController
-(void)dealloc{
    [super dealloc];
    [_hideview release];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    // Implement loadView to create a view hierarchy programmatically, without using a nib.
}
-(void)testjson{
    NSString *tmp = @"{\"lists\":[{\"TitleID\":1,\"photo\":\"photo/1.jpg\"},{\"TitleID\":2,\"photo\":\"photo/2.jpg\"},{\"TitleID\":3,\"photo\":\"photo/3.jpg\"},{\"TitleID\":4,\"photo\":\"photo/4.jpg\"},{\"TitleID\":5,\"photo\":\"photo/5.jpg\"},{\"TitleID\":6,\"photo\":\"photo/6.jpg\"},{\"TitleID\":7,\"photo\":\"\"}]}";
    NSLog(@"syp====%@",tmp);
    NSData *aa = [tmp dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:aa options:NSJSONReadingMutableContainers error:nil ];
    NSLog(@"syp===dic=%@",dic);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    int screen_w = self.view.bounds.size.width;
    int screen_h = self.view.bounds.size.height;
    _hideview = [[UIView alloc] initWithFrame:CGRectMake(0, 100, screen_w, screen_h-200)];
    [_hideview setBackgroundColor:[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:0.6]];
    UIButton *opencam = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    opencam.frame = CGRectMake(10, 100, 200, 50);
    [opencam addTarget:self action:@selector(opencamera) forControlEvents:UIControlEventTouchDown];
    [opencam setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [opencam setTitle:@"打开摄像头" forState:UIControlStateNormal];
    [self.view addSubview:opencam];
   // [self.view addSubview:_hideview];
}
-(void)opencamera{
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//		UIImagePickerController *cameraPicker=[[UIImagePickerController alloc] init];
//		cameraPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
//		cameraPicker.delegate = self;
//		cameraPicker.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
//		[self.view addSubview:cameraPicker.view];
//		[cameraPicker release];
//        [self.view addSubview:_hideview];
//        
//	}	
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.showsCameraControls = YES;
        [picker.view addSubview:_hideview];
        //picker.cameraOverlayView = viewCamera; 
        [self presentModalViewController:picker animated:YES]; 
    }
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
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
	if (picker.sourceType==UIImagePickerControllerSourceTypeCamera) {
//		UIImage *originalImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        
		//Can i add label here?
//		UIView *cropOverlay=[self findView:picker.view withName:@"PLCropOverlay"];
//		UILabel *label=(UILabel *)[self findView:cropOverlay withName:@"UILabel"];
//		UIImageView *photo=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//		photo.image=originalImage;
//		[photo addSubview:label];	
//		NSLog(@"photo View hierarchy:%@",photo);
//		//I wanna save my strange photo here.
//		UIGraphicsBeginImageContext(photo.bounds.size);     //currentView 当前的view
//		[photo.layer renderInContext:UIGraphicsGetCurrentContext()];
//		UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
//		UIGraphicsEndImageContext();
//		UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
//		[photo release];
		
		UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Photo has been saved."
													  message:nil
													 delegate:self
											cancelButtonTitle:@"OK"
											otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[self dismissModalViewControllerAnimated:YES];
}	

@end
