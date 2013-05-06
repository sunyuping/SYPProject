//
//  GitDemoViewController.m
//  SYPProject
//
//  Created by sunyuping on 12-10-29.
//
//

#import "GitDemoViewController.h"
#import "AGImagePickerController.h"

#import "ANGifEncoder.h"
#import "ANCutColorTable.h"
#import "ANGifNetscapeAppExtension.h"
#import "ANImageBitmapRep.h"
#import "UIImagePixelSource.h"

@interface GitDemoViewController ()

@end

@implementation GitDemoViewController
@synthesize images=_images;
@synthesize tableView=_tableView;


-(void)dealloc{
    [self.images removeAllObjects];
    self.images = nil;
    self.tableView = nil;
    
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _images = [[NSMutableArray alloc] initWithCapacity:4];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,320, 460) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return self;
}
-(void)loadView{
    [super loadView];
    
    self.navigationItem.title = @"制作gif";
    UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addImages)];
    self.navigationItem.rightBarButtonItem =add;
    [add release];
    [self.view addSubview:self.tableView];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}
-(void)addImages{
    
    AGImagePickerController *imagePickerController = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {
        NSLog(@"Fail. Error: %@", error);
        
        if (error == nil) {
            [self.images removeAllObjects];
            NSLog(@"User has cancelled.");
            [self dismissModalViewControllerAnimated:YES];
        } else {
            
            // We need to wait for the view controller to appear first.
            double delayInSeconds = 0.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self dismissModalViewControllerAnimated:YES];
            });
        }
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        
    } andSuccessBlock:^(NSArray *info) {
        [self.images setArray:info];
        [self.tableView reloadData];
        NSLog(@"Info: %@", info);
        [self dismissModalViewControllerAnimated:YES];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }];
    [self presentModalViewController:imagePickerController animated:YES];
    [imagePickerController release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.images count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell * imageCell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
	if (!imageCell) {
		imageCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
#if !__has_feature(objc_arc)
		[imageCell autorelease];
#endif
	}
    ALAsset *tmp = (ALAsset*)[self.images objectAtIndex:indexPath.row];

	imageCell.imageView.image =  [UIImage imageWithCGImage:[tmp.defaultRepresentation fullScreenImage]];//[[self.images objectAtIndex:indexPath.row] image]
	imageCell.imageView.contentMode = UIViewContentModeScaleAspectFit;
	imageCell.textLabel.text = [NSString stringWithFormat:@"image%d",indexPath.row];
	return imageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 70;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[self.images removeObjectAtIndex:indexPath.row];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)swapValueAtIndex:(NSInteger)source withValueAtIndex:(NSInteger)destination arr:(NSMutableArray*)arrary {
	NSObject * object1 = [arrary objectAtIndex:source];
	NSObject * object2 = [arrary objectAtIndex:destination];
#if !__has_feature(objc_arc)
	[object1 retain];
	[object2 retain];
#endif
	
	[arrary replaceObjectAtIndex:source withObject:object2];
	[arrary replaceObjectAtIndex:destination withObject:object1];
	
#if !__has_feature(objc_arc)
	[object1 release];
	[object2 release];
#endif
}

- (void)tableView:(UITableView *)aTableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
	[self swapValueAtIndex:[sourceIndexPath row] withValueAtIndex:[destinationIndexPath row] arr:self.images];
	[self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}
- (ANGifImageFrame *)imageFrameWithImage:(UIImage *)anImage fitting:(CGSize)imageSize {
	UIImage * scaledImage = anImage;
	if (!CGSizeEqualToSize(anImage.size, imageSize)) {
		scaledImage = [anImage imageFittingFrame:imageSize];
	}
    
	UIImagePixelSource * pixelSource = [[UIImagePixelSource alloc] initWithImage:scaledImage];
	ANCutColorTable * colorTable = [[ANCutColorTable alloc] initWithTransparentFirst:YES pixelSource:pixelSource];
	ANGifImageFrame * frame = [[ANGifImageFrame alloc] initWithPixelSource:pixelSource colorTable:colorTable delayTime:1];
#if !__has_feature(objc_arc)
	[colorTable release];
	[pixelSource release];
	[frame autorelease];
#endif
	return frame;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"syp===xuanzhong--%d",indexPath.row);
    
    
    UIImage * firstImage = nil;
    if ([self.images count] > 0) {
        firstImage = [UIImage imageWithCGImage:((ALAsset*)[self.images objectAtIndex:0]).thumbnail];
    }
    NSString * fileOutput = [NSString stringWithFormat:@"%@/%ld", NSTemporaryDirectory(), time(NULL)];
    CGSize canvasSize = (firstImage ? firstImage.size : CGSizeZero);
    ANGifEncoder * encoder = [[ANGifEncoder alloc] initWithOutputFile:fileOutput size:canvasSize globalColorTable:nil];
    ANGifNetscapeAppExtension * extension = [[ANGifNetscapeAppExtension alloc] init];
    [encoder addApplicationExtension:extension];
#if !__has_feature(objc_arc)
    [extension release];
#endif
//    float numberOfFrames = (float)[self.images count];
    for (int i = 0; i < [self.images count]; i++) {
        //float progress = 0.1 + ((0.9 / (float)numberOfFrames) * (float)i);
        NSLog(@"syp=%@",[NSString stringWithFormat:@"Resizing Frame (%d/%d)", i + 1, (int)[self.images count]]);
//        [self setProgressPercent:[NSNumber numberWithFloat:progress]];
//        [self setProgressLabel:[NSString stringWithFormat:@"Resizing Frame (%d/%d)", i + 1, (int)[images count]]];
        UIImage * image = [UIImage imageWithCGImage:((ALAsset*)[self.images objectAtIndex:i]).thumbnail];
        ANGifImageFrame * theFrame = [self imageFrameWithImage:image fitting:canvasSize];
        [encoder addImageFrame:theFrame];
    }
    [encoder closeFile];
    NSData * attachmentData = [NSData dataWithContentsOfFile:fileOutput];
    NSLog(@"Path: %@", fileOutput);
    MFMailComposeViewController * compose = [[MFMailComposeViewController alloc] init];
    [compose setSubject:@"Gif Image"];
    [compose setMessageBody:@"生成gif测试." isHTML:NO];
    [compose addAttachmentData:attachmentData mimeType:@"image/gif" fileName:@"image.gif"];
    [compose setMailComposeDelegate:self];
    [self performSelector:@selector(showViewController:) withObject:compose afterDelay:1];
}
- (void)showViewController:(UIViewController *)controller {
	[self presentModalViewController:controller animated:YES];
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [self dismissModalViewControllerAnimated:YES];
}
@end
