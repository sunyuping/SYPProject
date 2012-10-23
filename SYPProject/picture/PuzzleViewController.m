//
//  PuzzleViewController.m
//  SYPProject
//
//  Created by sunyuping on 12-10-23.
//
//

#import "PuzzleViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PicetureView.h"
#import "PictureScrollView.h"
@interface PuzzleViewController ()

@end

@implementation PuzzleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _picView = [[CombinePicView alloc] initWithFrame:CGRectMake(35, 20, 250, 330)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view addSubview:_picView];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    float image_w = 140;
    float image_h = 140;
    
    PictureScrollView *imageScroll01 = [[PictureScrollView alloc]initWithFrame:CGRectMake(0, 0, image_w, image_h)];
    [imageScroll01 setImage:[UIImage imageNamed:@"img01"]];
    [_picView addSubview:imageScroll01];
    [imageScroll01 release];
    
    PictureScrollView *imageScroll02 = [[PictureScrollView alloc]initWithFrame:CGRectMake(image_w, 0, image_w, 50)];
    [imageScroll02 setImage:[UIImage imageNamed:@"img02"]];
    [_picView addSubview:imageScroll02];
    [imageScroll02 release];
    
    PictureScrollView *imageScroll03 = [[PictureScrollView alloc]initWithFrame:CGRectMake(image_w, 50, 50, image_h)];
    [imageScroll03 setImage:[UIImage imageNamed:@"img03"]];
    [_picView addSubview:imageScroll03];
    [imageScroll03 release];
//    PicetureView *image01 = [[PicetureView alloc] initWithFrame:CGRectMake(0, 0, image_w, image_h)];
//    [image01.showImageView setImage:[UIImage imageNamed:@"img01"]];
//    [_picView addSubview:image01];
//    [image01 release];
//    
//    PicetureView *image02 = [[PicetureView alloc] initWithFrame:CGRectMake(0, 0, image_w, image_h)];
//    [image02.showImageView setImage:[UIImage imageNamed:@"img02"]];
//    [_picView addSubview:image02];
//    [image02 release];
//    
//    PicetureView *image03 = [[PicetureView alloc] initWithFrame:CGRectMake(0, 0, image_w, image_h)];
//    [image03.showImageView setImage:[UIImage imageNamed:@"img03"]];
//    [_picView addSubview:image03];
//    [image03 release];
//    
//    PicetureView *image04 = [[PicetureView alloc] initWithFrame:CGRectMake(0, 0, image_w, image_h)];
//    [image04.showImageView setImage:[UIImage imageNamed:@"img04"]];
//    [_picView addSubview:image04];
//    [image04 release];
//    
//    PicetureView *image05 = [[PicetureView alloc] initWithFrame:CGRectMake(0, 0, image_w, image_h)];
//    [image05.showImageView setImage:[UIImage imageNamed:@"img05"]];
//    [_picView addSubview:image05];
//    [image05 release];

    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame = CGRectMake(20, 360, 280, 30);
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
}
- (void)saveButtonAction
{
    UIGraphicsBeginImageContext(CGSizeMake(250, 330));
	[_picView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image,nil, nil, nil);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"保存成功" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alertView show];
    [alertView release];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
