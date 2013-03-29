//
//  AppDelegate.m
//  AutomaticCoder
//
//  Created by sunyuping on 13-3-1.
//  Copyright (c) 2013年 sunyuping. All rights reserved.//

#import "AppDelegate.h"


@implementation AppDelegate

-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    if(flag == NO)
    {
        [self.window makeKeyAndOrderFront:nil];
    }
    return YES;
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

}
- (NSString *) description
{
    NSString *result = @"";
    result = [result stringByAppendingFormat:@"%@ : %@\n",@"",@""];
    return result;
}

- (IBAction)json:(id)sender {

    json = [[JSONWindowController alloc] initWithWindowNibName:@"JSONWindowController"];
    [[json window] makeKeyAndOrderFront:nil];
}

- (IBAction)donate:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.sunyuping.cn"]];
}
@end
