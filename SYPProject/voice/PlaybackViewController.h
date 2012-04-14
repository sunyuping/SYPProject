//
//  PlaybackViewController.h
//  VoiceRecorder
//
//  Created by jinhu zhang on 10-10-27.
//  Copyright 2010 no. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<MessageUI/MessageUI.h>
@protocol PlaybackViewControllerDelegate;
@interface PlaybackViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>{
	id<PlaybackViewControllerDelegate>delegate;
	IBOutlet UITableView *table;
	IBOutlet UIToolbar *toolbar;
	IBOutlet UISlider *progressSlider;
	IBOutlet UIBarButtonItem *timeLabel;
	IBOutlet UISlider *volumeSlider;
	IBOutlet UIBarButtonItem *playButton;
	AVAudioPlayer *player;
	NSMutableArray *files;
	NSTimer *timer;
	
}
@property(nonatomic,assign)id<PlaybackViewControllerDelegate>delegate;
@property(nonatomic,retain)UITableView *table;
@property(nonatomic,retain)UIToolbar *toolbar;
@property(nonatomic,retain)UISlider *progressSlider;
@property(nonatomic,retain)UISlider *volumeSlider;
@property(nonatomic,retain)UIBarButtonItem *timeLabel;
@property(nonatomic,retain)UIBarButtonItem *playButton;
-(IBAction)sliderMoved:sender;
-(IBAction)togglePlay:sender;
-(IBAction)updateVolume:sender;
-(IBAction)record:sender;
-(void)timerFired:(NSTimer *)t;
-(void)playSound;
-(void)stopSound;
@end
@protocol PlaybackViewControllerDelegate
-(void)playbackViewControllerDidFinish:(PlaybackViewController *)controller;

@end

