//
//  Test_downloadViewController.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-4-13.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "Test_downloadViewController.h"

@interface Test_downloadViewController ()

@end

@implementation Test_downloadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    downLoadlable = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 20)];
    [self.view addSubview:downLoadlable];
    downLoadlable.text=@"下载百分比";
    UIButton *startbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    startbtn.frame = CGRectMake(0, 100, 50, 30);
    [startbtn setTitle:@"开始下载" forState:UIControlStateNormal];
    [startbtn addTarget:self action:@selector(startdownload:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:startbtn];
    _download = [[RNFileDownLode alloc] init];
    _download.delegate = self;
    _download.url = [NSURL URLWithString:@"http://www.cocoachina.com/bbs/job.php?action=download&aid=33895"];
    _download.fileName = @"idpickerview";
}
-(void)startdownload:(UIButton*)btn{
    [_download start];
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
//下载失败
- (void)downloadFaild:(RNFileDownLode *)aDownload didFailWithError:(NSError *)error{
    NSLog(@"下载失败");
}
//下载结束
- (void)downloadFinished:(RNFileDownLode *)aDownload{
    NSLog(@"下载完成");
}
//更新下载的进度
- (void)downloadProgressChange:(RNFileDownLode *)aDownload progress:(double)newProgress{
    downLoadlable.text=[NSString stringWithFormat:@"下载百分比=%f",newProgress];
}
@end
