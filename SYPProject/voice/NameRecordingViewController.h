//
//  NameRecordingViewController.h
//  VoiceRecorder
//
//  Created by jinhu zhang on 10-10-27.
//  Copyright 2010 no. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NameRecordingDelegate;//声明
//开始进入接口
@interface NameRecordingViewController : UIViewController <UITextFieldDelegate>{
	id<NameRecordingDelegate>delegate;//声明类代理
	IBOutlet UITextField *textField;//输入名称的文本框
	
}
@property (nonatomic,assign) id <NameRecordingDelegate> delegate;//声明为属性
@property (nonatomic,retain) UITextField *textField;
-(IBAction)finishedNaming:sender;//输入名称完毕
@end
//开始协议
@protocol NameRecordingDelegate
//通知代理用户选择了名称
-(void)nameRecordingViewController:(NameRecordingViewController *)controller didGetName:(NSString *)fileName;

@end

