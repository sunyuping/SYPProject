//
//  VoiceRecorderViewController.h
//  VoiceRecorder
//
//  Created by jinhu zhang on 10-10-25.
//  Copyright no 2010. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "Visualizer.h"
#import "PlaybackViewController.h"
#import "NameRecordingViewController.h"
//开始声明接口voicerecorderviewconreoller


@interface VoiceRecorderViewController : UIViewController <PlaybackViewControllerDelegate,NameRecordingDelegate>{
	IBOutlet Visualizer *visualizer;//保存观测仪
	IBOutlet UIButton *recordButton;//触摸启动及停止
	AVAudioRecorder *recorder;//记录声音输入
	NSTimer *timer;//每0.05秒更新一次观测仪
}//实例变量声明结束
//将visualizer  recordButton声明为属性
@property (nonatomic, retain) Visualizer *visualizer;
@property (nonatomic, retain) UIButton *recordButton;
-(IBAction)record:sender;//切换声音
-(IBAction)flip:sender;//切换到flipside

@end//接口结束

