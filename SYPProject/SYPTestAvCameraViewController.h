//
//  SYPTestAvCameraViewController.h
//  SYPProject
//
//  Created by 玉平 孙 on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XBFilteredCameraView.h"
#import "CameraTargetView.h"

@interface SYPTestAvCameraViewController : UIViewController

@property (nonatomic, retain)  XBFilteredCameraView *cameraView;
@property (nonatomic, retain)  CameraTargetView *cameraTargetView;

- (void)takeAPictureButtonTouchUpInside:(id)sender;
- (void)changeFilterButtonTouchUpInside:(id)sender;
- (void)cameraButtonTouchUpInside:(id)sender;

@end
