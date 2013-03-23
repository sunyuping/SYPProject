//
//  RRCameraViewController.h
//  SYPProject
//
//  Created by 玉平 孙 on 12-3-9.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRCameraViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>{
    UIView *_hideview;
    UIButton *_bottom;
}

@end
