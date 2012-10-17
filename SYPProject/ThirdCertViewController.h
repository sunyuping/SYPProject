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
#define kSinaAppRedirectURI     @"oauth://SYPDemo.com"

#ifndef kSinaAppKey
#error
#endif

#ifndef kSinaAppSecret
#error
#endif

#ifndef kSinaAppRedirectURI
#error
#endif


@interface ThirdCertViewController : JMStaticContentTableViewController<SinaWeiboDelegate, SinaWeiboRequestDelegate>{
    SinaWeibo *sinaweibo;
}
@property (readonly, nonatomic) SinaWeibo *sinaweibo;


@end
