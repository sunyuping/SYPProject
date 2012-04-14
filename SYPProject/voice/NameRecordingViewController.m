//
//  NameRecordingViewController.m
//  VoiceRecorder
//
//  Created by jinhu zhang on 10-10-27.
//  Copyright 2010 no. All rights reserved.
//

#import "NameRecordingViewController.h"


@implementation NameRecordingViewController
@synthesize delegate,textField;//为他们生成get set方法
//视图载入调用本方法
-(void)viewDidLoad{
	[super viewDidLoad];//调用父类viewdidload方法
	[textField becomeFirstResponder];
	
}
//当触摸键盘上的done时调用本方法
-(IBAction)finishedNaming:sender{
//通知代理用户选择了一个名称
	[delegate nameRecordingViewController:self didGetName:textField.text];
}
//每次用户在文本框中编辑文字是调用本方法
-(BOOL)textField:(UITextField *)field shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	NSString *newString = [field.text stringByReplacingCharactersInRange:range withString:string];
	//创建一个判定用来匹配有效字符
	NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES '.*[^-_a-zA-Z0-9].*'"];
	BOOL matches = [regex evaluateWithObject:newString];
	if(matches){
		field.textColor = [UIColor redColor];
		
	}else{
		field.textColor = [UIColor blackColor];
	}
	return YES;
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

//触摸按钮done时调用本方法
-(BOOL)textFieldShouldReturn:(UITextField *)field{
//创建一个判定用来匹配有效字符
	NSPredicate *regex = [NSPredicate predicateWithFormat:@"SELF MATCHES '.*[^-_a-zA-Z0-9].*'"];
	 return (![regex evaluateWithObject:field.text]);
}


@end
