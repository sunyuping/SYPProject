//
//  TestKeDaViewController.h
//  SYPProject
//
//  Created by 玉平 孙 on 12-2-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iFlyISR/IFlyRecognizeControl.h"
#import "iFlyTTS/IFlySynthesizerControl.h"
typedef enum _IsrType
{
	IsrText = 0,		// 转写
	IsrKeyword,			// 关键字识别
	IsrUploadKeyword	// 关键字上传
}IsrType;



@interface TestKeDaViewController : UIViewController<IFlySynthesizerControlDelegate,IFlyRecognizeControlDelegate>{
    IFlySynthesizerControl *_iFlySynthesizerControl;
    IFlyRecognizeControl *_iFlyRecognizeControl;
    UITextView *testtextview;
    // 中间变量
	IsrType _type;
    NSString					*_keywordID;
}

@end
