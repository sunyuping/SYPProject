//
//  RichTextKitViewController.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-4-10.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import "RichTextKitViewController.h"
#import <CoreText/CoreText.h>
@interface RichTextKitViewController ()

@end
// 阿狸表情转义符内容及顺序
static NSString *aliEmotions = @"(阿狸-hi),(阿狸-幸福),(阿狸-挨揍),(阿狸-拜拜),(阿狸-汗),(阿狸-洒泪),(阿狸-晕乎乎),(阿狸-吃饭),(阿狸-呼噜),(阿狸-亲元宝),(阿狸-拖走),(阿狸-爱情),(阿狸-来亲个),(阿狸-献花),(阿狸-礼物),(阿狸-压力)";

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
    
    NSMutableArray *md5name =[NSMutableArray arrayWithCapacity:20];
    
    NSArray *defaultEmotionsArray = [aliEmotions componentsSeparatedByString:@","];
    for (NSString *escapeCode in defaultEmotionsArray) {
        [md5name addObject:[escapeCode md5]];
        
    }
    NSArray *defaultEmotionsArray11 = [jjEmotions componentsSeparatedByString:@","];
    for (NSString *escapeCode11 in defaultEmotionsArray11) {
        [md5name addObject:[escapeCode11 md5]];
    }
    
    NSLog(@"syp=%@",md5name);
    
    [_textview release];
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
