//
//  AppDelegate.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTestViewController.h"
#import "Test_MKNetworkKit.h"
//#import "TestKeDaViewController.h"
#import "RRCameraViewController.h"

#import "FreemojiController.h"
#import "RichTextKitViewController.h"

#import "Test_downloadViewController.h"

#import "SYPTestAvCameraViewController.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import "UncaughtExceptionHandler.h"
@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}
- (void)installUncaughtExceptionHandler

{
    
	InstallUncaughtExceptionHandler();
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //获取当前运营商信息。需要4。0以上
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSLog(@"carrier:%@", [carrier description]);
    //运营商切换通知
    info.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier *carrier) { 
        NSLog ( @"carrier:%@" , [carrier description]);
    };

//    CTCallCenter *center = [[CTCallCenter alloc] init];
//    center.callEventHandler = ^(CTCall *call) {
//        NSLog ( @"call:%@" , [call description]);
//    };
//    
    
    //注册单件类
    RRSingleton *mysingle = [RRSingleton defaultSingleton];
    //注册崩溃事件监听，
    RRException *myex = [RRException defaultException];
    myex.delegate = self;
    //注册崩溃事件监听2.。。
    [self installUncaughtExceptionHandler];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //测试科大讯飞
   // TestKeDaViewController *mytestviewcontrol = [[TestKeDaViewController alloc] init];
    //
    //MyTestViewController *mytestviewcontrol = [[MyTestViewController alloc] init];
    //测试mk网络
    //Test_MKNetworkKit *mytestviewcontrol = [[Test_MKNetworkKit alloc] init];
    //测试拍照
    //RRCameraViewController *mytestviewcontrol = [[RRCameraViewController alloc] init];
    
   // FreemojiController *mytestviewcontrol = [[FreemojiController alloc]init];
    
    RichTextKitViewController *mytestviewcontrol = [[RichTextKitViewController alloc]init];
    
    //Test_downloadViewController *mytestviewcontrol = [[Test_downloadViewController alloc]init];
    
  //  SYPTestAvCameraViewController *mytestviewcontrol = [[SYPTestAvCameraViewController alloc]init];
    
    self.window.rootViewController = mytestviewcontrol;
    [mytestviewcontrol release];
    [self.window makeKeyAndVisible];
    return YES;
}
-(BOOL)ExceptionHandle:(NSException*)e{
//    - (NSString *)name;
//    - (NSString *)reason;
//    - (NSDictionary *)userInfo;
//    
//    - (NSArray *)callStackReturnAddresses NS_AVAILABLE(10_5, 2_0);
//    - (NSArray *)callStackSymbols 
//    
    NSLog(@"syp===error===%@",e.userInfo);
    NSLog(@"syp====exception===name=%@,reason=%@",e.name,e.reason);
    for (int i=0; i<[e.callStackReturnAddresses count]; i++) {
          NSLog(@"syp====callStackReturnAddresses==%d,info=%@",i,[e.callStackReturnAddresses objectAtIndex:i]);
    }
    for (int i=0; i<[e.callStackSymbols count]; i++) {
        NSLog(@"syp====callStackSymbols==%d,info=%@",i,[e.callStackSymbols objectAtIndex:i]);
    }    
    return NO;
}
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
//   // return [[RMConnectCenter sharedCenter] handleOpenURL:url];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
//    return [[RMConnectCenter sharedCenter] handleOpenURL:url];
//}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
