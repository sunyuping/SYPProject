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

@interface RichTextKitViewController ()

@end
// 阿狸表情转义符内容及顺序
static NSString *aliEmotions = @"[al01],[al06],[al08],[al09],[al10],[al11],[al15],[al16],[al17],[al18],[al19],[al20],[al21],[al22],[al24],[al28],[al29],[al31],[al33],[al34],[al35],[al36],[al38],[al39],[al40],[al41],[al42],[al43],[al44],[al45],[al46],[al47],[al48],[al49],[al50],[al51]";

// 囧囧熊表情转义符内容及顺序
static NSString *jjEmotions = @"[jj01],[jj02],[jj03],[jj04],[jj05],[jj06],[jj07],[jj08],[jj09],[jj10],[jj11],[jj12],[jj13],[jj14],[jj15],[jj16],[jj17],[jj18],[jj19]";




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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIScreen *screen = [UIScreen mainScreen];
    RTKView *_textview = [[RTKView alloc] initWithFrame:[screen applicationFrame] delegate:self];
    
//    RTKDocument *docView = [[RTKDocument alloc] initWithFrame:CGRectInset([screen applicationFrame], 5.0f, 0.0f) delegate:self];
//    [docView setParentScrollView:self]; // TODO: move to a delegate.
//    [self addSubview:docView];
    
//    _dragEditingActive = NO;
    
    [self.view addSubview:_textview];
    
    NSString *shaoping = @"CIAC005740";
    NSString *md5shao = [shaoping md5];
    NSLog(@"syp===md5shao=%@",md5shao);
    
    NSMutableArray *md5name =[NSMutableArray arrayWithCapacity:20];
    
    NSArray *defaultEmotionsArray = [aliEmotions componentsSeparatedByString:@","];
    for (NSString *escapeCode in defaultEmotionsArray) {
        [md5name addObject:[escapeCode md5]];
        
    }
    NSArray *defaultEmotionsArray11 = [jjEmotions componentsSeparatedByString:@","];
    for (NSString *escapeCode11 in defaultEmotionsArray11) {
        [md5name addObject:[escapeCode11 md5]];
    }
    
   // NSLog(@"syp=%@",md5name);
    
    [_textview release];
    
    UIButton *test = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    test.frame = CGRectMake(10, 100, 100, 100);
    [self.view addSubview:test];
    [test addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchDown];
    
    
    Reachability *tmp = [Reachability reachabilityWithHostname:@"www.renren.com"];
    
    NetworkStatus a = [tmp  currentDetailReachabilityStatus];
    NetworkStatus b = [tmp currentReachabilityStatus];
}
-(void)test:(UIButton*)btn{
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
