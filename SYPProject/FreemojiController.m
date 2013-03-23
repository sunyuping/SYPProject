//
//  FreemojiController.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-4-9.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "FreemojiController.h"

@implementation FreemojiController 
- (void) didSwitch: (UISwitch *) sv 
{ 
    // Read in prefs 
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:PREFS_FILE]; 
    if (!dict) 
    { 
        [sv setOn:(![sv isOn])]; 
        [(UITextView *)[self.view viewWithTag:FEEDBACK_TAG] setText:@"ERROR! Could not read (or write to) the Apple Preferences property list for some reason.\n\nThis error means that you were sandboxed away from the proper settings or the settings could not be found or read from. Sorry!"]; 
        return; 
    } 
    
    // Toggle the setting from on to off or vice versa 
    BOOL isSet = [[dict objectForKey:EMOJI_KEY] boolValue]; 
    printf("%s key...\n", isSet ? "Removing" : "Setting"); 
    if (isSet) 
        [dict removeObjectForKey:EMOJI_KEY]; 
    else 
        [dict setObject:[NSNumber numberWithBool:YES] forKey:EMOJI_KEY]; 
    [dict writeToFile:PREFS_FILE atomically:NO]; 
    [sv setOn:!isSet]; 
} 

- (void)loadView 
{ 
    UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]; 
    self.view = contentView; 
    contentView.backgroundColor = [UIColor whiteColor]; 
    
    // Add a switch 
    UISwitch *sv = [[UISwitch alloc] initWithFrame:CGRectZero]; 
    sv.center = CGPointMake(160.0f, 180.0f); 
    [sv addTarget:self action:@selector(didSwitch:) forControlEvents:UIControlEventValueChanged]; 
    [contentView addSubview:sv]; 
    [sv release]; 
    
    // Initialize switch value from the current setting 
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:PREFS_FILE]; 
    [sv setOn:[[dict objectForKey:EMOJI_KEY] boolValue]]; 
    
    // Add primary label 
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 120.0f)]; 
    label.center = CGPointMake(160.0f, 80.0f); 
    label.numberOfLines = 2; 
    label.text = @"EMOJI\nSUPPORT"; 
    label.textAlignment = UITextAlignmentCenter; 
    label.backgroundColor = [UIColor clearColor]; 
    label.font = [UIFont boldSystemFontOfSize:48.0f]; 
    [contentView addSubview:label]; 
    [label release]; 
    
    // Add how-to text 
    UITextView *tv = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 200.0f)]; 
    tv.center = CGPointMake(160.0f, 350.0f); 
    tv.backgroundColor = [UIColor lightGrayColor]; 
    tv.editable = NO; 
    tv.font = [UIFont italicSystemFontOfSize:16.0f]; 
    tv.text = @"After enabling Emoji support, go to Settings > General > Keyboard > International Keyboards > Japanese and switch Emoji support to ON.\n\nDisabling Emoji support in this application returns your system to its normal settings."; 
    tv.tag = FEEDBACK_TAG; 
    [contentView addSubview:tv]; 
    [tv release]; 
    
    [contentView release]; 
} 
@end 
