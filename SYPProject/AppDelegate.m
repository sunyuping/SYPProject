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

//#import "SYPTestAvCameraViewController.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import "UncaughtExceptionHandler.h"
#import "DemoViewController.h"

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

#import "RRAssistiveTouch.h"


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
    //注册微信
    [WXApi registerApp:@"wx0f2670f1b023cc77"];
    //获取当前运营商信息。需要4。0以上
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSLog(@"carrier:%@", [carrier description]);
    //运营商切换通知
    info.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier *carrier) { 
        NSLog ( @"carrier:%@" , [carrier description]);
    };
    [self detectCall];
    [self setupAudio];
    
    
    RRAssistiveTouch *touch = [[RRAssistiveTouch alloc] initWithFrame:CGRectMake(40, 40, 55, 55)];
    touch.hidden = NO;
//    CTCallCenter *center = [[CTCallCenter alloc] init];
//    center.callEventHandler = ^(CTCall *call) {
//        NSLog ( @"call:%@" , [call description]);
//    };
//
    
    //runloop test  ！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
    
    
//    dispatch_source_t source, timer;
//    
//    source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
//    dispatch_source_set_event_handler(source, ^{
//        
//        
//        printf("hello\n");
//    });
//    dispatch_resume(source);
//    
//    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC, 0);
//    dispatch_source_set_event_handler(timer, ^{
//        dispatch_source_merge_data(source, 1);
//    });
//    dispatch_resume(timer);
    
//    dispatch_main();
    //runloop test  ！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
    
   NSString *phoneNumber =  [[NSUserDefaults standardUserDefaults] objectForKey:@"SBFormattedPhoneNumber"];
    NSLog(@"syp===phoneNumber=%@",phoneNumber);
    
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
    
    DemoViewController *demoView = [[DemoViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:demoView];
    self.window.rootViewController = nc;
    [nc release];
    [demoView release];
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
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
   // return [[RMConnectCenter sharedCenter] handleOpenURL:url];
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
  // return [[RMConnectCenter sharedCenter] handleOpenURL:url];
    [WXApi handleOpenURL:url delegate:self];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setKeepAliveTimeout:600 handler:^{
         NSLog(@"syp===后台运行");
        
        
    }];
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
//微信的实现和微信终端交互的具体请求与回应


- (void) onShowMediaMessage:(WXMediaMessage *) msg
{
    //显示微信传过来的内容
    WXAppExtendObject *obj = msg.mediaObject;
    
    NSString *strTitle = [NSString stringWithFormat:@"消息来自微信"];
    NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}
- (void) RespImageContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@"icon"]];
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
    ext.imageData = [NSData dataWithContentsOfFile:filePath] ;
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[[GetMessageFromWXResp alloc] init] autorelease];
    resp.message = message;
    resp.bText = NO;
    
    [WXApi sendResp:resp];
}
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        [self RespImageContent];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        [self onShowMediaMessage:temp.message];
    }
    
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
        NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}


-(void)detectCall
{
    CTCallCenter *callCenter = [[CTCallCenter alloc] init];
    callCenter.callEventHandler=^(CTCall* call)
    {
        if (call.callState == CTCallStateDisconnected)
        {
            NSLog(@"Call has been disconnected");
            
        }
        else if (call.callState == CTCallStateConnected)
        {
            NSLog(@"Call has just been connected");
        }
        
        else if(call.callState == CTCallStateIncoming)
        {
            NSLog(@"Call is incoming");
            
        }
        
        else if (call.callState ==CTCallStateDialing)
        {
            NSLog(@"call is dialing");
        }
        else
        {
            NSLog(@"Nothing is done");
        }
    };
}
- (void)setupAudio {
    [AudioManager sharedInstance].audioPlayer = [AudioManager defaultAudioPlayer];
    [AudioManager sharedInstance].audioRecorder = [AudioManager defaultAudioRecorder];
    [AudioManager sharedInstance].proximityMonitoringEnabled = TRUE;
    [AudioManager sharedInstance].replayWhenProximityChanged = TRUE;
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"message" ofType:@"wav"];
    [[AudioManager sharedInstance] createSystemSoundWithTag:SoundEffectType_PushMessage soundFile:soundPath];
    
    soundPath = [[NSBundle mainBundle] pathForResource:@"receive_sound" ofType:@"wav"];
    [[AudioManager sharedInstance] createSystemSoundWithTag:SoundEffectType_CurrentMessage soundFile:soundPath];
    
    soundPath = [[NSBundle mainBundle] pathForResource:@"send_sound" ofType:@"wav"];
    [[AudioManager sharedInstance] createSystemSoundWithTag:SoundEffectType_SendMessage soundFile:soundPath];
    
    soundPath = [[NSBundle mainBundle] pathForResource:@"refresh_press" ofType:@"wav"];
    [[AudioManager sharedInstance] createSystemSoundWithTag:SoundEffectType_RefreshPress soundFile:soundPath];
    
    soundPath = [[NSBundle mainBundle] pathForResource:@"refresh_release" ofType:@"wav"];
    [[AudioManager sharedInstance] createSystemSoundWithTag:SoundEffectType_RefreshRelease soundFile:soundPath];
    
    soundPath = [[NSBundle mainBundle] pathForResource:@"refresh_finish" ofType:@"wav"];
    [[AudioManager sharedInstance] createSystemSoundWithTag:SoundEffectType_RefreshFinish soundFile:soundPath];
    
    soundPath = [[NSBundle mainBundle] pathForResource:@"refresh" ofType:@"wav"];
    [[AudioManager sharedInstance] createSystemSoundWithTag:SoundEffectType_RefreshCompleted soundFile:soundPath];
    //铃音
    soundPath = [[NSBundle mainBundle] pathForResource:@"newmessage" ofType:@"wav"];
    [[AudioManager sharedInstance] createSystemSoundWithTag:SoundEffectType_RefreshFinish soundFile:soundPath];
}

@end
