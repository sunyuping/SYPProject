//
//  DemoViewController.m
//  SYPProject
//
//  Created by sunyuping on 12-10-15.
//
//

#import "DemoViewController.h"

#import "RichTextKitViewController.h"
#import "RRCameraViewController.h"
#import "ThirdCertViewController.h"
#import "PuzzleViewController.h"
#import "GitDemoViewController.h"
@interface DemoViewController ()

@end

@implementation DemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id) init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) return nil;
    
	self.title = NSLocalizedString(@"Demos", @"Demos");
    
	return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addSection:^(JMStaticContentTableViewSection *section, NSUInteger sectionIndex) {
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"RichTextKit", @"RichTextKit");
			//cell.imageView.image = [UIImage imageNamed:@"Sounds"];
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            RichTextKitViewController *richTextKit = [[RichTextKitViewController alloc]init];
            [self.navigationController pushViewController:richTextKit animated:YES];
            [richTextKit release];
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"CameraView", @"CameraView");
			//cell.imageView.image = [UIImage imageNamed:@"Brightness"];
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            //测试拍照
            RRCameraViewController *cameraView = [[RRCameraViewController alloc] init];
            [self.navigationController pushViewController:cameraView animated:YES];
            [cameraView release];
		}];
        
		[section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"thirdcert", @"thirdcert");
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            ThirdCertViewController *thirdcert = [[ThirdCertViewController alloc] init];
            [self.navigationController pushViewController:thirdcert animated:YES];
            [thirdcert release];
		}];
        
//        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
//			cell.textLabel.text = NSLocalizedString(@"拼图", @"拼图");
//		} whenSelected:^(NSIndexPath *indexPath) {
//			//TODO
//            PuzzleViewController *puzzle = [[PuzzleViewController alloc] init];
//            [self.navigationController pushViewController:puzzle animated:YES];
//            [puzzle release];
//		}];
//        
//        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
//			cell.textLabel.text = NSLocalizedString(@"制作gif", @"制作gif");
//		} whenSelected:^(NSIndexPath *indexPath) {
//			//TODO
//            GitDemoViewController *puzzle = [[GitDemoViewController alloc] init];
//            [self.navigationController pushViewController:puzzle animated:YES];
//            [puzzle release];
//		}];
	}];

    
    //测试科大讯飞
    // TestKeDaViewController *mytestviewcontrol = [[TestKeDaViewController alloc] init];
    //
    //MyTestViewController *mytestviewcontrol = [[MyTestViewController alloc] init];
    //测试mk网络
    //Test_MKNetworkKit *mytestviewcontrol = [[Test_MKNetworkKit alloc] init];
    
    
    // FreemojiController *mytestviewcontrol = [[FreemojiController alloc]init];
    
  //  
    
    //Test_downloadViewController *mytestviewcontrol = [[Test_downloadViewController alloc]init];
    
    //  SYPTestAvCameraViewController *mytestviewcontrol = [[SYPTestAvCameraViewController alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
