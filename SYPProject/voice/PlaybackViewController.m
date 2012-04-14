//
//  PlaybackViewController.m
//  VoiceRecorder
//
//  Created by jinhu zhang on 10-10-27.
//  Copyright 2010 no. All rights reserved.
//
#import<AVFoundation/AVFoundation.h>
#import "PlaybackViewController.h"
@implementation PlaybackViewController
@synthesize delegate,table,toolbar,progressSlider,volumeSlider,timeLabel,playButton;
-(void)viewDidLoad{
	files=[[NSMutableArray alloc]init];
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString *dir =[paths objectAtIndex:0 ];
	NSFileManager *filemanager=[NSFileManager defaultManager];
	NSArray *filelist = [filemanager directoryContentsAtPath:dir];
	for(NSString *file in filelist){//遍历数组（目录中的每个文件）
		if([[file pathExtension]isEqualToString:@"caf"]){
			[files addObject:[dir stringByAppendingPathComponent:file]];
		}
	}
	[table reloadData];
}

-(IBAction)sliderMoved:sender{
	if(player!=nil){
		player.currentTime=progressSlider.value;
	}
}
-(IBAction)togglePlay:sender{
	if(player.playing){
		[self stopSound];
	}else if(player!=nil){
		[self playSound];
	}

}
-(IBAction)updateVolume:sender{
	player.volume=volumeSlider.value;
}
-(void)timerFired:(NSTimer *)t{
	if(player.playing){
	
		double time = player.currentTime;
		[progressSlider setValue:time animated:NO];
		timeLabel.title = [NSString stringWithFormat:@"%i%.02i",(int)time/60,(int)time%60];
	}else{
		[self stopSound];
		[progressSlider setValue:0 animated:YES];
	}
}
-(IBAction)record:sender{
	[delegate playbackViewControllerDidFinish:self];
	
}
-(void)playSound{
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	[player play];
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
	UIBarButtonItem *pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(togglePlay:)];
	NSMutableArray *items = [toolbar.items mutableCopy];
	[items removeObjectAtIndex:0];
	[items insertObject:pauseButton atIndex:0];
	[pauseButton release];
	[toolbar setItems:items animated:NO];
}
-(void)stopSound{
	[timer invalidate];
	timer = nil;
	[player pause];
	[[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategorySoloAmbient error:nil];
	NSMutableArray *items =[toolbar.items mutableCopy];
	[items removeObjectAtIndex:0];
	[items insertObject:playButton atIndex:0];
	[toolbar setItems:items animated:NO];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return files.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

static NSString *ID=@"Cell";
	UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
	if(cell==nil)
		cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID]autorelease];
	NSString *text=[[files objectAtIndex:indexPath.row] lastPathComponent];
	cell.textLabel.text=[text stringByDeletingPathExtension];
	UIImage *mailImage=[UIImage imageNamed:@"envelope.png"];
	UIButton *mailButton=[[UIButton alloc]initWithFrame:CGRectMake(0,0,32,32)];
	[mailButton setImage:mailImage forState:UIControlStateNormal];
	mailButton.tag=indexPath.row;
	[mailButton addTarget:self action:@selector(mailButtonTouched:)forControlEvents:UIControlEventTouchUpInside];
	cell.accessoryView=mailButton;
	return cell;

}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
	if(editingStyle==UITableViewCellEditingStyleDelete){
		NSFileManager *fileManager=[NSFileManager defaultManager];
		NSString *path=[files objectAtIndex:indexPath.row];
		if([[player.url path]isEqualToString:path]){
			[self stopSound];
			[player release];
			player=nil;
		}
		[fileManager removeItemAtPath:path error:nil];
		[files removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
		
	}
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *file=[files objectAtIndex:indexPath.row];
	NSURL *url = [NSURL URLWithString:file];
	[player release];
	player=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
	player.volume = volumeSlider.value;
	progressSlider.maximumValue=player.duration;
	[self playSound];
	playButton.enabled=YES;
	
}
-(void)mailButtonTouched:sender{
	NSString *file=[file objectAtIndex:[sender tag]];
	NSData *data=[NSData dataWithContentsOfFile:file];
	MFMailComposeViewController *controller=[[MFMailComposeViewController alloc]init];
	[controller addAttachmentData:data mimeType:@"audio/mp4" fileName:[file lastPathComponent]];
	controller.mailComposeDelegate=self;
	[self presentModalViewController:controller animated:YES];
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	[self dismissModalViewControllerAnimated:YES];
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc {
    [player release];
	[files release];
	[super dealloc];
}


@end
