//
//  ShareViewController.h
//  ShareDemo
//
//  Created by tmy on 11-11-23.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSCore.h"
#import "LoadingView.h"


@interface SHSShareViewController : UIViewController<SHSOAuthDelegate,UIActionSheetDelegate>
{
    NSMutableArray *_menuItems;
    NSMutableArray *_moreServices;
    NSMutableArray *_moreActions;
    LoadingView *_loadView;
    UIViewController *_rootViewController;
}
@property (nonatomic) ShareType shareType;
@property (nonatomic,assign) UIViewController *rootViewController;
@property (nonatomic,retain) NSString *sharedtitle;
@property (nonatomic,retain) NSString *sharedText;
@property (nonatomic,retain) NSString *sharedURL;
@property (nonatomic,retain) UIImage *sharedImage;   //分享本地图片，只对通过oauth认证绑定好的服务可用
@property (nonatomic,retain) NSString *sharedImageURL; //分享网络图片，针对跳转分享的bshare使用

- (id)initWithRootViewController:(UIViewController *)rootViewController;
- (void)logout;
- (void)showShareView;                       //针对iphone的调用接口
- (void)showShareViewFromRect:(CGRect)rect;  //针对ipad的调用接口
- (NSString *)getTrackUrl:(NSString *)source trackCB:(BOOL)trackCB site:(NSString *)site;
@end
