//
//  VoiceRecorderViewController.m
//  VoiceRecorder
//
//  Created by jinhu zhang on 10-10-25.
//  Copyright no 2010. All rights reserved.
//

#import "VoiceRecorderViewController.h"

@implementation VoiceRecorderViewController

@synthesize visualizer,recordButton;//为它们生成get set方法
//开始配置视图

-(void)viewDidLoad{
	[super viewDidLoad];//调用父类中的方法
	//激活当前音频会话
	[[AVAudioSession sharedInstance] setActive:YES error:nil];
	
}//viewdidload方法结束
-(IBAction)record:sender{
	if(recorder.recording){
	//假如正在录音
		[timer invalidate];//timer停止则不再产生事件
		timer = nil;//将timer设置成nil
		[recorder stop];//停止录音
		//设置当前音频会话类别
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
		//载入录音的图片
		UIImage *recordImage =[UIImage imageNamed:@"record.png"]; 
		//将图片设置在录音按钮上
		[recordButton setImage:recordImage forState:UIControlStateNormal];
		
		//创建一个新的namerecordingviewcontroller
		NameRecordingViewController *controller =[[NameRecordingViewController alloc] init];
		controller.delegate = self;//设置controller的代理为self
		//显示namerecordingviewcontroller
		[self presentModalViewController:controller animated:YES];
	}else{
	//设置音频对话的类别为录音
		[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
		//寻找文件夹目录位置
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
		//得到第一个目录
		NSString *dir = [paths objectAtIndex:0];
		
		//使用当前的系统时间为这个文件创建一个名称
		NSString *filename=[NSString stringWithFormat:@"%f.caf",[[NSDate date]timeIntervalSince1970]];
		//使用目录和文件名创建一个路径
		NSString *path = [dir stringByAppendingPathComponent:filename];
		//为录音设置创建一个新的nsmutabledictionary
		NSMutableDictionary *settings = [[NSMutableDictionary alloc]init];
		//录音使用的苹果无损格式
		[settings setValue:[NSNumber numberWithInt:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
		//设置采样率为44100hz
		[settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
		//设置录音的通道数目
		[settings setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
		//设置位深
		[settings setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
		//设置格式是否为大字节序编码
		[settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
		//设置音频格式是否位浮点型
		[settings setValue:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
		[visualizer clear];
		[recorder release];
		//使用url和setting初始化
		//recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:path settings:settings error:nil];
		recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL fileURLWithPath:path] settings:settings error:nil];
		[recorder prepareToRecord];//准备
		recorder.meteringEnabled=YES;//允许测量
		[recorder record];//开始录音
		//启动一个timer
		timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
		
	 	//创建停止录音的图像
		UIImage *stopImage = [UIImage imageNamed:@"stop.png"];
		//将recordbutton上的图片更改为停止的图片
		[recordButton setImage:stopImage forState:UIControlStateNormal];
		
	}
}
//当用户为录音选择了一个名称完毕后调用本方法
		-(void)nameRecordingViewController:(NameRecordingViewController *) controller didGetName:(NSString *)fileName{
		//在选择的名称上附加扩展名
			fileName = [fileName stringByAppendingPathExtension:@"caf"];
			//得到上次文件可路径
			NSString *path = [recorder.url path];
			//得到上次文件被保存进的目录
			NSString *dir = [path stringByDeletingLastPathComponent];
			//将新的文件名附加到路径上
			NSString *newPath = [dir stringByAppendingPathComponent:fileName];
			//得到默认的文件管理器
			NSFileManager *fileManager = [NSFileManager defaultManager];
			//将旧的文件重名名为用户选取的新的名称
			[fileManager moveItemAtPath:path toPath:newPath error:nil];
			//隐藏namerecordingviewcontroller
			[self dismissModalViewControllerAnimated:YES];
		}
		//将程序切换到PlaybackView
		-(IBAction)flip:sender{
		//创建一个新的PlaybackViewController
			PlaybackViewController *playback=[[PlaybackViewController alloc] init];
			//切换样式设置为渐变
			playback.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			playback.delegate = self;
			[self presentModalViewController:playback animated:YES];
			[playback release];
		}
		//playbackviewcontrolle的代理方法
		-(void)playbackViewControllerDidFinish: (PlaybackViewController *)controller{
		//返回到voicerecorderview
			[self dismissModalViewControllerAnimated:YES];
		}
		//每隔0.05妙调用一次由timer生成的事件处理函数
		-(void)timerFired:(NSTimer *)timer
			{
				[recorder updateMeters];//对录音进行采样得到新的数据
				//设置visualizer的平均能量等级
				[visualizer setPower:[recorder averagePowerForChannel:0]];
				[visualizer setNeedsDisplay];//重绘
			}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {
   
			[visualizer release];
			[recorder release];
			[recordButton release];
			 [super dealloc];
}

@end
