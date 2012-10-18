//
//  ThirdCertViewController.h
//  SYPProject
//
//  Created by sunyuping on 12-10-16.
//
//

#import <UIKit/UIKit.h>
#import "JMStaticContentTableViewController.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

#define kSinaAppKey             @"633273606"
#define kSinaAppSecret          @"f0e1f37d225c927af87cdbf7c595fe28"
#define kSinaAppRedirectURI     @"http://SYPDemo.com://"

#ifndef kSinaAppKey
#error
#endif

#ifndef kSinaAppSecret
#error
#endif

#ifndef kSinaAppRedirectURI
#error
#endif

#define kQQAppKey             @"801254824"
#define kQQAppSecret          @"a8215b871ee74d5f6e3265a94f75a2e9"
#define kQQAppRedirectURI     @"http://SYPDemo.com://"

//腾讯微博
#import "OpenSdkOauth.h"
#import "QQWeiboAuthorizeView.h"

@interface ThirdCertViewController : JMStaticContentTableViewController<SinaWeiboDelegate, SinaWeiboRequestDelegate,QQWeiboAuthorizeViewDelegate>{
    SinaWeibo *sinaweibo;
    OpenSdkOauth         *_OpenOauth;
}
@property (readonly, nonatomic) SinaWeibo *sinaweibo;
@property (readonly, nonatomic) OpenSdkOauth *OpenOauth;


@end
