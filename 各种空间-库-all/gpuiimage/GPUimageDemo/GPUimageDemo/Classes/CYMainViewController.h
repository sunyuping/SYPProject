//
//  CYMainViewController.h
//  CYFilter
//
//  Created by yi chen on 12-7-13.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYImagePickerController.h"
@interface CYMainViewController : UIViewController    <CYImagePickerControllerDelegate,UIImagePickerControllerDelegate>
{
	@private
	//开始按钮
	UIButton *_startButton;
	
}

@property(nonatomic,retain)UIButton *startButton;
@end
