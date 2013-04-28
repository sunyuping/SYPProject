//
//  AppDelegate.m
//  GPUimageDemo
//
//  Created by sunyuping on 13-4-28.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "AppDelegate.h"
#import "CYMainViewController.h"
#import <UIKit/UIKit.h>
@interface AppDelegate() {
	
}
// 内存监控
@property (nonatomic, retain) UIWindow *memoryMonitorWnd;
@property (nonatomic, retain) NSTimer *memoryMonitorTimer;
@property (nonatomic, retain) UILabel *memoryMonitorLabel;
@property (nonatomic, assign) unsigned int memoryPeak;

@end


@implementation AppDelegate

@synthesize window = _window;
//内存监控
@synthesize memoryMonitorWnd;
@synthesize memoryMonitorTimer;
@synthesize memoryMonitorLabel;
@synthesize memoryPeak;

- (void)dealloc
{
	[_window release];
	
	if (self.memoryMonitorTimer) {
        [self.memoryMonitorTimer invalidate];
    }
    self.memoryMonitorTimer = nil;
    self.memoryMonitorWnd = nil;
    self.memoryMonitorLabel = nil;
    
    [super dealloc];
}


void uncaughtExceptionHandler(NSException *exception) {
    RSLogInfo(@"CRASH: %@", exception);
    RSLogInfo(@"Stack Trace: %@", [exception callStackSymbols]);
    NSString *crashLog = [NSString stringWithFormat:@"%@",[exception callStackSymbols]];
	
	NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path1 = [searchPath objectAtIndex:0];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",path1,@"crashLog"];
    NSError *error;
    if (![crashLog writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
        RSLogError(@"write to file error:%@",error);
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
	
    self.window.backgroundColor = [UIColor whiteColor];
	CYMainViewController *mainViewController = [[CYMainViewController alloc]init];
	CYImagePickerController *pickerController = [[CYImagePickerController alloc]init];
	
    //	UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainViewController];
    //	[mainViewController release];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:mainViewController];
	[pickerController release];
	
    nav.navigationBar.hidden = YES;
    
	self.window.rootViewController = nav;
	[nav release];
	[mainViewController release];
    //	[nav release];
	
    [self.window makeKeyAndVisible];
	
	// 增加内存监视器
#if DEBUG_MEMORY_MONITOR
    self.memoryMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                               target:self
                                                             selector:@selector(refreshMemoryMonitor)
                                                             userInfo:nil
                                                              repeats:YES];
    [self.memoryMonitorTimer fire];
#endif
    
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

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
	
#if DEBUG_MEMORY_MONITOR
	self.memoryMonitorLabel.textColor = [UIColor redColor];
#endif
	
}// try to clean up as much memory as possible. next step is to terminate app



// 内存监测
- (void)refreshMemoryMonitor{
    if (self.memoryMonitorWnd == nil) {
        self.memoryMonitorWnd = [[[UIWindow alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            320,
                                                                            20)] autorelease];
        self.memoryMonitorWnd.windowLevel = UIWindowLevelStatusBar;
        self.memoryMonitorWnd.userInteractionEnabled = NO;
        
        self.memoryMonitorLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0,
																			 0,
																			 100,
																			 20)] autorelease];
        self.memoryMonitorLabel.font = [UIFont systemFontOfSize:12];
        self.memoryMonitorLabel.textColor = [UIColor greenColor];
        self.memoryMonitorLabel.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        
        [self.memoryMonitorWnd addSubview:self.memoryMonitorLabel];
        [self.memoryMonitorWnd makeKeyAndVisible];
    }
    
    //// 设备总空间
    unsigned int usedMemory = [UIDevice usedMemory];
    unsigned int freeMemory = [UIDevice freeMemory];
    if (usedMemory > self.memoryPeak) {
        self.memoryPeak = usedMemory;
    }
    
    NSString *monitor = [NSString stringWithFormat:@"used:%7.1fkb free:%7.1fkb peak:%7.1fkb", usedMemory/1024.0f, freeMemory/1024.0f, self.memoryPeak/1024.0f];
    CGSize size = [monitor sizeWithFont:self.memoryMonitorLabel.font];
    self.memoryMonitorLabel.frame = CGRectMake(0, 0, size.width, 20);
    self.memoryMonitorLabel.text = monitor;
}



@end
