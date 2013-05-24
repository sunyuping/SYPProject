//
//  RichTextKitViewController.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-4-10.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "RichTextKitViewController.h"
#import <CoreText/CoreText.h>

#import "Reachability.h"
#import "TTStyledText.H"


@interface RichTextKitViewController ()

@end


@implementation RichTextKitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView{
    [super loadView];
}

- (TTStyledTextLabel *) chatMessageLabel {
	if (!_chatMessageLabel) {
		_chatMessageLabel = [[TTStyledTextLabel alloc] init];
		_chatMessageLabel.contentMode = UIViewContentModeRight;
		_chatMessageLabel.font = [UIFont systemFontOfSize:16];
//        _chatMessageLabel.textColor = RGBCOLOR(0, 255, 0);
        _chatMessageLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_chatMessageLabel];
        
        _chatMessageLabel.openUrlBlock = ^(NSString *url){

        };
	}
	return _chatMessageLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    UIScreen *screen = [UIScreen mainScreen];
//    RTKView *_textview = [[RTKView alloc] initWithFrame:[screen applicationFrame] delegate:self];
//    
////    RTKDocument *docView = [[RTKDocument alloc] initWithFrame:CGRectInset([screen applicationFrame], 5.0f, 0.0f) delegate:self];
////    [docView setParentScrollView:self]; // TODO: move to a delegate.
////    [self addSubview:docView];
//    
////    _dragEditingActive = NO;
//    
//    [self.view addSubview:_textview];
//    
//    NSString *shaoping = @"CIAC005740";
//    NSString *md5shao = [shaoping md5];
//    NSLog(@"syp===md5shao=%@",md5shao);
//    
//    NSMutableArray *md5name =[NSMutableArray arrayWithCapacity:20];
//    
//    NSArray *defaultEmotionsArray = [aliEmotions componentsSeparatedByString:@","];
//    for (NSString *escapeCode in defaultEmotionsArray) {
//        [md5name addObject:[escapeCode md5]];
//        
//    }
//    NSArray *defaultEmotionsArray11 = [jjEmotions componentsSeparatedByString:@","];
//    for (NSString *escapeCode11 in defaultEmotionsArray11) {
//        [md5name addObject:[escapeCode11 md5]];
//    }
//    
//   // NSLog(@"syp=%@",md5name);
//    
//    [_textview release];
//    
//    UIButton *test = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    test.frame = CGRectMake(10, 100, 100, 100);
//    [self.view addSubview:test];
//    [test addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchDown];
    

    self.chatMessageLabel.text	= [TTStyledText textFromXHTML:@"妙探三姐妹 乐视下半年重点投资的一部网络剧 我在这里怎么发给我你 ？废事荒时计算机直接睡觉睡觉十九世纪携家带口世界先进的肯定看着看展示的可可可<img width=\"15\" height=\"15\" class=\"emotionImage\" src=\"http://5.gaosu.com/download/pic/000/089/c0fb81580646e8e60319a743b6405470.gif\"/>定居点看到看到科学家的肯定可贷款" lineBreaks:NO URLs:YES];
    
       self.chatMessageLabel.frame = CGRectMake(5,0,300,100);
    [self.chatMessageLabel setNeedsLayout];
	[self.chatMessageLabel sizeToFit];
    
//    Reachability *tmp = [Reachability reachabilityWithHostname:@"www.renren.com"];
//    
//    NetworkStatus a = [tmp  currentDetailReachabilityStatus];
//    NetworkStatus b = [tmp currentReachabilityStatus];
}
-(void)test:(UIButton*)btn{
    

    NSURL*url=[NSURL URLWithString:@"prefs:root=General&path=Network"];
    [[UIApplication sharedApplication] openURL:url];
   
    // [self performSelector:@selector(aaaa)];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (NSMutableAttributedString *)textForEditing{
    CTFontRef font = CTFontCreateWithName( (CFStringRef)@"Courier", 16, NULL);
	CFStringRef keys[] = { kCTFontAttributeName };
	CFTypeRef values[] = { font };
	CFDictionaryRef attr = CFDictionaryCreate(
											  NULL, 
											  (const void **)&keys, 
											  (const void **)&values,
											  sizeof(keys) / sizeof(keys[0]), 
											  &kCFTypeDictionaryKeyCallBacks, 
											  &kCFTypeDictionaryValueCallBacks
											  );
	
	NSMutableAttributedString *string = [[[NSMutableAttributedString alloc] 
                                          initWithString:@"Lorem Ipsum\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Donec vitae turpis urna, aliquam rutrum libero. Quisque justo odio, iaculis non luctus sit amet, bibendum a dolor. Fusce dolor mauris, tempus eget eleifend id, facilisis quis urna. Fusce iaculis congue sem, nec ullamcorper mi rutrum vitae. Proin molestie pellentesque imperdiet. Sed dictum nulla vitae arcu vulputate aliquet. Etiam at rutrum neque. Nam volutpat mollis lacinia. Suspendisse quis tellus massa. Nullam in iaculis metus. Nam dolor turpis, congue luctus fringilla et, congue a urna. Aliquam erat volutpat. Quisque ornare, augue sed mattis vulputate, orci diam varius urna, ut scelerisque lacus urna vitae urna. Cras dictum tempor egestas. Duis eu nibh a diam feugiat dapibus. Sed et libero turpis, in fermentum leo. Etiam vel augue odio, vitae porttitor enim."
                                          attributes:(NSDictionary *)attr] autorelease];
    
	CFRelease(attr);
    
	
	// Create a color and add it as an attribute to the string.
	CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
	CGFloat components[] = { 0.2, 0.6, 0.2, 1.0 };
	CGColorRef titleColour = CGColorCreate(rgbColorSpace, components);
	CGColorSpaceRelease(rgbColorSpace);
	CFAttributedStringSetAttribute(
                                   (CFMutableAttributedStringRef)string, 
                                   CFRangeMake(0, 11), 
                                   kCTForegroundColorAttributeName,
                                   titleColour
                                   );
	
	CFAttributedStringSetAttribute((CFMutableAttributedStringRef)string, CFRangeMake(0, 5), kCTStrokeWidthAttributeName, [NSNumber numberWithFloat:2]);
	CFAttributedStringSetAttribute((CFMutableAttributedStringRef)string, CFRangeMake(0, 5), kCTStrokeColorAttributeName, [UIColor blueColor].CGColor);
    
	NSLog(@"%@", string);
	return string;

}
- (NSDictionary *)defaultStyle{
    return nil;
}



@end
