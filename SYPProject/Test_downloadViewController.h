//
//  Test_downloadViewController.h
//  SYPProject
//
//  Created by 玉平 孙 on 12-4-13.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNFileDownLode.h"
@interface Test_downloadViewController : UIViewController<RNFileDownloadDelegate>{
    UILabel *downLoadlable;
    RNFileDownLode *_download;
    
}

@end
