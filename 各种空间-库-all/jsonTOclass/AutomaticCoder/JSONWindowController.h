//
//  JSONWindowController.h
//  AutomaticCoder
//
//  Created by sunyuping on 13-3-1.
//  Copyright (c) 2013年 sunyuping. All rights reserved.//

#import <Cocoa/Cocoa.h>
#import "JSONKit.h"
#import "JSONPropertyWindowController.h"

typedef enum
{
    kString = 0,
    kNumber = 1,
    kArray  = 2,
    kDictionary = 3,
    kBool   = 4,
}JsonValueType;


@interface JSONWindowController : NSWindowController
{
    NSString *path;
    NSArrayController *array;
    NSArrayController *arrayController;
    JSONPropertyWindowController *propertyWindowController;
}
@property (unsafe_unretained) IBOutlet NSTextView *jsonContent;
@property (weak) IBOutlet NSTextField *jsonName;
@property (weak) IBOutlet NSTextField *preName;
@property (weak) IBOutlet NSTextField *jsonURL;

- (IBAction)useTestURL:(id)sender;
- (IBAction)getJSONWithURL:(id)sender;
- (IBAction)generateClass:(id)sender;
- (IBAction)checkProperty:(id)sender;




-(BOOL)isDataArray:(NSArray *)array;
-(JsonValueType)type:(id)obj;
-(NSString *)typeName:(JsonValueType)type;

@end
