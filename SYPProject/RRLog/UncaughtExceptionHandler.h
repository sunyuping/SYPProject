//
//  UncaughtExceptionHandler.h
//  SYPProject
//
//  Created by sunyuping on 12-10-9.
//用于崩溃弹窗提示用户。。
//

#import <UIKit/UIKit.h>

@interface UncaughtExceptionHandler : NSObject{
	BOOL dismissed;
}

@end
void HandleException(NSException *exception);
void SignalHandler(int signal);


void InstallUncaughtExceptionHandler(void);
