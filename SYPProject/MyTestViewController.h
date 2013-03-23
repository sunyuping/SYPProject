//
//  MyTestViewController.h
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RRUIImageView.h"
@interface MyTestViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>{
    UILabel *tmplable;
    AVCaptureSession *session;
    NSData *mData;
    BOOL isgetpic;
    RRUIImageView *testAvView;
    AVCaptureVideoPreviewLayer* preLayer;
    AVCaptureStillImageOutput *newStillImageOutput;
    AVCaptureConnection * iStillImageConnection;
}

@end
