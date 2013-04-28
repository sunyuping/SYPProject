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
#import "TestTableViewController.h"
#import "MyTestViewController.h"
#import "TestSocketViewController.h"


#import "StyleListTableViewController.h"

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
            [iConsole log:@"unrecognised command, try 'log' instead"];
            [iConsole info:@"unrecognised command, try 'info' instead"];
            [iConsole warn:@"unrecognised command, try 'warn' instead"];
            [iConsole error:@"unrecognised command, try 'error' instead"];
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
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"uitableview", @"uitableview");
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            TestTableViewController *table = [[TestTableViewController alloc] init];
            [self.navigationController pushViewController:table animated:YES];
            [table release];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"拼图", @"拼图");
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            PuzzleViewController *puzzle = [[PuzzleViewController alloc] init];
            [self.navigationController pushViewController:puzzle animated:YES];
            [puzzle release];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"制作gif", @"制作gif");
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            GitDemoViewController *puzzle = [[GitDemoViewController alloc] init];
            [self.navigationController pushViewController:puzzle animated:YES];
            [puzzle release];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"测试视频", @"测试视频");
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            MyTestViewController *camera = [[MyTestViewController alloc] init];
            [self.navigationController pushViewController:camera animated:YES];
            [camera release];
		}];
        
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"自定义列表样式", @"自定义列表样式");
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
//            [iConsole show];
            
            StyleListTableViewController *tableview = [[StyleListTableViewController alloc] init];
            [self.navigationController pushViewController:tableview animated:YES];
            [tableview release];
		}];
        [section addCell:^(JMStaticContentTableViewCell *staticContentCell, UITableViewCell *cell, NSIndexPath *indexPath) {
			cell.textLabel.text = NSLocalizedString(@"socket", @"socket");
		} whenSelected:^(NSIndexPath *indexPath) {
			//TODO
            TestSocketViewController *socketCon = [[TestSocketViewController alloc] init];
            [self.navigationController pushViewController:socketCon animated:YES];
            [socketCon release];
		}];
        
	}];

    
    [iConsole sharedConsole].delegate = self;
	
	int touches = (TARGET_IPHONE_SIMULATOR ? [iConsole sharedConsole].simulatorTouchesToShow: [iConsole sharedConsole].deviceTouchesToShow);
	if (touches > 0 && touches < 11)
	{
//		self.swipeLabel.text = [NSString stringWithFormat:
//								@"\nSwipe up with %i finger%@ to show the console",
//								touches, (touches != 1)? @"s": @""];
	}
	else if (TARGET_IPHONE_SIMULATOR ? [iConsole sharedConsole].simulatorShakeToShow: [iConsole sharedConsole].deviceShakeToShow)
	{
//		self.swipeLabel.text = @"\nShake device to show the console";
	}

    
    
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
- (void)handleConsoleCommand:(NSString *)command{
    
    
    
}
@end
