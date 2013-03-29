//
//  JSONPropertyWindowController.h
//  AutomaticCoder
//
//  Created by sunyuping on 13-3-1.
//  Copyright (c) 2013年 sunyuping. All rights reserved.//

#import <Cocoa/Cocoa.h>

@interface JSONPropertyWindowController : NSWindowController
{
    NSString *path;
}
@property (weak) IBOutlet NSTableView *table;
@property(nonatomic,strong)  NSArrayController *arrayController;

- (IBAction)closeWindow:(id)sender;



@end
