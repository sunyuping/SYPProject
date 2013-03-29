//
//  AppDelegate.h
//  AutomaticCoder
//
//  Created by sunyuping on 13-3-1.
//  Copyright (c) 2013年 sunyuping. All rights reserved.//

#import <Cocoa/Cocoa.h>
#import "JSONWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    JSONWindowController *json;

}


@property (assign) IBOutlet NSWindow *window;


- (IBAction)json:(id)sender;
- (IBAction)donate:(id)sender;


@end
