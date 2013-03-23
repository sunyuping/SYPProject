    //
    //  WBSendView.m
    //  SinaWeiBoSDK
    //  Based on OAuth 2.0
    //
    //  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    //  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
    //  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    //  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
    //  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    //  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    //  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    //  OTHER DEALINGS IN THE SOFTWARE. 1   qaq #!!A!AA!
    //
    //  Copyright 2011 Sina. All rights reserved.
    //

#import "SHSendView.h"

static BOOL WBIsDeviceIPad()
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 30200
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
		return YES;
        }
#endif
	return NO;
}

@interface SHSendView (Private)

- (void)onCloseButtonTouched:(id)sender;
- (void)onSendButtonTouched:(id)sender;
- (void)onClearTextButtonTouched:(id)sender;
- (void)onClearImageButtonTouched:(id)sender;

- (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation;
- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation;
- (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation;

- (void)addObservers;
- (void)removeObservers;

- (UIInterfaceOrientation)currentOrientation;

- (void)bounceOutAnimationStopped;
- (void)bounceInAnimationStopped;
- (void)bounceNormalAnimationStopped;
- (void)allAnimationsStopped;

- (int)textLength:(NSString *)text;
- (void)calculateTextLength;

- (void)hideAndCleanUp;

@end

@implementation SHSendView
@synthesize contentText;
@synthesize contentImage;
@synthesize delegate;
@synthesize rootViewController;

#pragma mark - WBSendView Life Circle

- (id)initWithText:(NSString *)text image:(UIImage *)image andRootViewController:(UIViewController *)root
{
    self.rootViewController = root;
    keysOfEnabledSharer = [[NSMutableArray alloc]init];
    [self loadConfig];
    CGRect screenRect = [UIScreen mainScreen].applicationFrame;
    CGFloat width = screenRect.size.width;
    CGFloat height = screenRect.size.height;
    CGFloat middleX = (width - 288)/2;
    CGFloat middleY = (height - 335)/2;
    if (self = [super initWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)])
        {
        
            // background settings
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventTouchDown];
        
        NSLog(@"sendView.count=%d",self.retainCount);
            // add the panel view
        panelView = [[UIControl alloc] initWithFrame:CGRectMake(middleX, middleY, 288, 335)];
        panelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 288, 335)];
        [panelImageView setImage:[[UIImage imageNamed:@"bg.png"] stretchableImageWithLeftCapWidth:18 topCapHeight:18]];
        [panelView addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventTouchDown];
        
        [panelView addSubview:panelImageView];
        [self addSubview:panelView];
        
            // add the buttons & labels
		closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[closeButton setShowsTouchWhenHighlighted:YES];
		[closeButton setFrame:CGRectMake(15, 13, 48, 30)];
		[closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[closeButton setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
		[closeButton setTitle:NSLocalizedString(@"关闭", nil) forState:UIControlStateNormal];
		[closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
		[closeButton addTarget:self action:@selector(onCloseButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		[panelView addSubview:closeButton];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 12, 140, 30)];
        [titleLabel setText:NSLocalizedString(@"分享到", nil)];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        [titleLabel setTextAlignment:UITextAlignmentCenter];
        [titleLabel setCenter:CGPointMake(144, 27)];
        [titleLabel setShadowOffset:CGSizeMake(0, 1)];
		[titleLabel setShadowColor:[UIColor whiteColor]];
        [titleLabel setFont:[UIFont systemFontOfSize:19]];
		[panelView addSubview:titleLabel];
        
        sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[sendButton setShowsTouchWhenHighlighted:YES];
		[sendButton setFrame:CGRectMake(288 - 15 - 48, 13, 48, 30)];
		[sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		[sendButton setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
		[sendButton setTitle: NSLocalizedString(@"发送", nil) forState:UIControlStateNormal];
		[sendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
		[sendButton addTarget:self action:@selector(onSendButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		[panelView addSubview:sendButton];
        
        contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(13, 60, 288 - 26, 90)];
		[contentTextView setEditable:YES];
		[contentTextView setDelegate:self];
        [contentTextView setText:text];
		[contentTextView setBackgroundColor:[UIColor clearColor]];
		[contentTextView setFont:[UIFont systemFontOfSize:16]];
        
        
        
 		[panelView addSubview:contentTextView];
        
        [self initPlatformButton:panelView lastElement:CGPointMake(contentTextView.frame.origin.x,contentTextView.frame.origin.y + contentTextView.frame.size.height)];        
        
        wordCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 190, 30, 30)];
		[wordCountLabel setBackgroundColor:[UIColor clearColor]];
		[wordCountLabel setTextColor:[UIColor darkGrayColor]];
		[wordCountLabel setFont:[UIFont systemFontOfSize:16]];
		[wordCountLabel setTextAlignment:UITextAlignmentCenter];
		[panelView addSubview:wordCountLabel];
        
        clearTextButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[clearTextButton setShowsTouchWhenHighlighted:YES];
		[clearTextButton setFrame:CGRectMake(240, 191, 30, 30)];
		[clearTextButton setContentMode:UIViewContentModeCenter];
 		[clearTextButton setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
		[clearTextButton addTarget:self action:@selector(onClearTextButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
		[panelView addSubview:clearTextButton];
        
            // calculate the text length
        [self calculateTextLength];
        
        self.contentText = contentTextView.text;
        
            // image(if attachted)
        if (image)
            {
			CGSize imageSize = image.size;	
            CGFloat width = imageSize.width;
			CGFloat height = imageSize.height;
			CGRect tframe = CGRectMake(0, 0, 0, 0);
			if (width > height) {
				tframe.size.width = 120;
				tframe.size.height = height * (120 / width);
			}
			else {
				tframe.size.height = 80;
				tframe.size.width = width * (80 / height);
			}
			
			contentImageView = [[UIImageView alloc] initWithFrame:tframe];
			[contentImageView setImage:image];
			[contentImageView setCenter:CGPointMake(144, 260)];
			
			CALayer *layer = [contentImageView layer];
			[layer setBorderColor:[[UIColor whiteColor] CGColor]];
			[layer setBorderWidth:5.0f];
			
			[contentImageView.layer setShadowColor:[UIColor blackColor].CGColor];
            [contentImageView.layer setShadowOffset:CGSizeMake(0, 0)];
            [contentImageView.layer setShadowOpacity:0.5]; 
            [contentImageView.layer setShadowRadius:3.0];
			
			
			[panelView addSubview:contentImageView];
 			
			clearImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[clearImageButton setShowsTouchWhenHighlighted:YES];
			[clearImageButton setFrame:CGRectMake(0, 0, 30, 30)];
			[clearImageButton setContentMode:UIViewContentModeCenter];
			[clearImageButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
			[clearImageButton addTarget:self action:@selector(onClearImageButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
			[clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                    contentImageView.center.y - contentImageView.frame.size.height / 2)];
            [panelView addSubview:clearImageButton];
            
            
            self.contentImage = image;
            }
        
        }
    return self;
}


- (void)dealloc
{
    [keysOfEnabledSharer removeAllObjects];
    [keysOfEnabledSharer release],keysOfEnabledSharer = nil;
    [panelView release], panelView = nil;
    [panelImageView release], panelImageView = nil;
    [titleLabel release], titleLabel = nil;
    [contentTextView release], contentTextView = nil;
    [wordCountLabel release], wordCountLabel = nil;
    [contentImageView release], contentImageView = nil;
        //    if (sharerArray) {
        //        [sharerArray release],sharerArray = nil;
        //    }
    if (sharerDict) {
        [sharerDict removeAllObjects];
        [sharerDict release],sharerDict = nil;
    }
    if (platformDict) {
        [platformDict removeAllObjects];
        [platformDict release];
        platformDict = nil;
    }
    [_loadView release],_loadView = nil;
    self.rootViewController = nil;
    [contentText release], contentText = nil;
    [contentImage release], contentImage = nil;
    delegate = nil;
    
    [super dealloc];
}

#pragma mark - WBSendView Private Methods

#pragma mark Actions

- (void)onCloseButtonTouched:(id)sender
{
    [self hide:YES];
}

- (void)onSendButtonTouched:(id)sender
{
    if ([contentTextView.text isEqualToString:@""])
        {
		UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                             message:NSLocalizedString(@"请输入要发布的内容", nil)
                                                            delegate:nil
                                                   cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
		[alertView show];
		[alertView release];
		return;
        }
    
        //TODO
    [self startToShare];
    
}

- (void)startToShare {
    @try{
        for (NSString *pName in keysOfEnabledSharer) {
            id sharer = [sharerDict objectForKey:pName];
            if (contentImage ) {
                
                
                if ([sharer respondsToSelector:@selector(shareText:andImage:)]) {
                    [sharer shareText:contentTextView.text andImage:contentImage];
                }}
            else {
                    if ([sharer respondsToSelector:@selector(shareText:)]) {
                        [sharer shareText:contentTextView.text];
                    }
            }
        }
    }
        @catch (NSException *exception) {
            NSLog(@"%@",[exception description]);
            [self loadViewDelayClose];
        }
    }
    
    - (void)onClearTextButtonTouched:(id)sender
    {
    [contentTextView setText:@""];
	[self calculateTextLength];
    }
    
    - (void)onClearImageButtonTouched:(id)sender
    {
    [contentImageView setHidden:YES];
    [clearImageButton setHidden:YES];
	[contentImage release], contentImage = nil;
    }
    
#pragma mark Orientations
    
    - (UIInterfaceOrientation)currentOrientation
    {
    return [UIApplication sharedApplication].statusBarOrientation;
    }
    
    - (void)sizeToFitOrientation:(UIInterfaceOrientation)orientation
    {
    [self setTransform:CGAffineTransformIdentity];
    
    CGRect screenFrame = [UIScreen mainScreen].applicationFrame;
    CGPoint screenCenter = CGPointMake(screenFrame.origin.x +
                                       ceil(screenFrame.size.width / 2),
                                       screenFrame.origin.y
                                       +
                                       ceil(screenFrame.size.height / 2));
    
    if (UIInterfaceOrientationIsLandscape(orientation))
        {
        [self setFrame:CGRectMake(0, 0
                                  , screenFrame.size.height, screenFrame.size.width)];
        [self setCenter:screenCenter];
        [self setCenter:screenCenter];
        CGRect selfRect = [self frame];
        CGPoint selfCenter = CGPointMake(ceil(selfRect.size.width/2), ceil(selfRect.size.height/2));
        [panelView setFrame:CGRectMake(0, 0, 480 - 32, 280)];
        [panelView setCenter:selfCenter];
        [contentTextView setFrame:CGRectMake(13, 60, 480 - 32 - 26, 50)];
        NSEnumerator *keyEnum = [platformDict keyEnumerator];
        NSString *key = nil;UIButton *platformButton = nil;
        while (key = [keyEnum nextObject]) {
            platformButton = [platformDict objectForKey:key];
            [platformButton setFrame:CGRectMake(platformButton.frame.origin.x, contentTextView.frame.origin.y + contentTextView.frame.size.height, platformButton.frame.size.width, platformButton.frame.size.height)];
        }
        [contentImageView setCenter:CGPointMake(448 / 2, 155 + 60)];
        [clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                contentImageView.center.y - contentImageView.frame.size.height / 2)];
        
        [wordCountLabel setFrame:CGRectMake(224 + 90, 100 + 60, 30, 30)];
        [clearTextButton setFrame:CGRectMake(224 + 120, 101 + 60, 30, 30)];
        [panelImageView setFrame:CGRectMake(0, 0, 480 - 32, 280)];
        [panelImageView setImage:[UIImage imageNamed:@"bg_land.png"]];
        [sendButton setFrame:CGRectMake(480- 32 - 15 - 48, 13, 48, 30)];
        [titleLabel setCenter:CGPointMake(448 / 2, 27)];
        
        if (isKeyboardShowing && WBIsDeviceIPad() == NO)
            {
            [contentTextView setFrame:CGRectMake(13, 50, 480 - 32 - 26, 60)];
            
            [contentImageView setCenter:CGPointMake(448 / 2, 145)];
            [clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                    contentImageView.center.y - contentImageView.frame.size.height / 2)];
            
            [wordCountLabel setFrame:CGRectMake(224 + 90, 100, 30, 30)];
            [clearTextButton setFrame:CGRectMake(224 + 120, 101, 30, 30)];
            }
        
        }
    else
        {
        
        [self setFrame:CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.height)];
        [self setCenter:screenCenter];
        CGRect selfRect = [self frame];
        CGPoint selfCenter = CGPointMake(ceil(selfRect.size.width/2), ceil(selfRect.size.height/2));
        [panelView setFrame:CGRectMake(0,0, 288, 335)];
        [panelView setCenter:selfCenter];
        
        if(isKeyboardShowing && WBIsDeviceIPad() == NO)
            {
            [panelView setCenter:CGPointMake(selfCenter.x, selfCenter.y - 71)];
            }
        
        [contentTextView setFrame:CGRectMake(13, 60, 288 - 26, 90)];
        NSEnumerator *keyEnum = [platformDict keyEnumerator];
        NSString *key = nil;UIButton *platformButton = nil;
        while (key = [keyEnum nextObject]) {
            platformButton = [platformDict objectForKey:key];
            [platformButton setFrame:CGRectMake(platformButton.frame.origin.x, contentTextView.frame.origin.y + contentTextView.frame.size.height, platformButton.frame.size.width, platformButton.frame.size.height)];
        }
        [contentImageView setCenter:CGPointMake(144, 260)];
        [clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                contentImageView.center.y - contentImageView.frame.size.height / 2)];
        
        [wordCountLabel setFrame:CGRectMake(210, 190, 30, 30)];
        [clearTextButton setFrame:CGRectMake(240, 191, 30, 30)];
        [panelImageView setFrame:CGRectMake(0, 0, 288, 335)];
        [panelImageView setImage:[UIImage imageNamed:@"bg.png"]];
        
        [sendButton setFrame:CGRectMake(288 - 15 - 48, 13, 48, 30)];
        [titleLabel setCenter:CGPointMake(144, 27)];
        
        }
    
    
    
    [self setTransform:[self transformForOrientation:orientation]];
    
    previousOrientation = orientation;
    }
    
    - (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation
    {  
        if (orientation == UIInterfaceOrientationLandscapeLeft)
            {
            return CGAffineTransformMakeRotation(-M_PI / 2);
            }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
            {
            return CGAffineTransformMakeRotation(M_PI / 2);
            }
        else if (orientation == UIInterfaceOrientationPortraitUpsideDown)
            {
            return CGAffineTransformMakeRotation(-M_PI);
            }
        else
            {
            return CGAffineTransformIdentity;
            }
    }
    
    - (BOOL)shouldRotateToOrientation:(UIInterfaceOrientation)orientation 
    {
	if (orientation == previousOrientation)
        {
		return NO;
        }
    else
        {
		return orientation == UIInterfaceOrientationLandscapeLeft
		|| orientation == UIInterfaceOrientationLandscapeRight
		|| orientation == UIInterfaceOrientationPortrait
		|| orientation == UIInterfaceOrientationPortraitUpsideDown;
        }
    return YES;
    }
    
#pragma mark Obeservers
    
    - (void)addObservers
    {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(deviceOrientationDidChange:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:) name:@"UIKeyboardWillShowNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:) name:@"UIKeyboardWillHideNotification" object:nil];
    }
    
    - (void)removeObservers
    {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIKeyboardWillShowNotification" object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIKeyboardWillHideNotification" object:nil];
    }
    
#pragma mark Text Length
    
    - (int)textLength:(NSString *)text
    {
    float number = 0.0;
    for (int index = 0; index < [text length]; index++)
        {
        NSString *character = [text substringWithRange:NSMakeRange(index, 1)];
        
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
            {
            number++;
            }
        else
            {
            number = number + 0.5;
            }
        }
    return ceil(number);
    }
    
    - (void)calculateTextLength
    {
    if (contentTextView.text.length > 0) 
        { 
            [sendButton setEnabled:YES];
            [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
	else 
        {
		[sendButton setEnabled:NO];
		[sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
	
	int wordcount = [self textLength:contentTextView.text];
	NSInteger count  = 140 - wordcount;
	if (count < 0)
        {
		[wordCountLabel setTextColor:[UIColor redColor]];
		[sendButton setEnabled:NO];
		[sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
	else
        {
		[wordCountLabel setTextColor:[UIColor darkGrayColor]];
		[sendButton setEnabled:YES];
		[sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
	
	[wordCountLabel setText:[NSString stringWithFormat:@"%i",count]];
    }
    
#pragma mark Animations
    
    - (void)bounceOutAnimationStopped
    {
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
    [panelView setAlpha:0.8];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
	[UIView commitAnimations];
    }
    
    - (void)bounceInAnimationStopped
    {
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceNormalAnimationStopped)];
    [panelView setAlpha:1.0];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
	[UIView commitAnimations];
    }
    
    - (void)bounceNormalAnimationStopped
    {
    [self allAnimationsStopped];
    }
    
    - (void)allAnimationsStopped
    {
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
    if ([delegate respondsToSelector:@selector(sendViewDidAppear:)])
        {
        [delegate sendViewDidAppear:self];
        }
    }
    
#pragma mark Dismiss
    
    - (void)hideAndCleanUp
    {
    [self removeObservers];
	[self removeFromSuperview];	
    
    if ([delegate respondsToSelector:@selector(sendViewDidDisappear:)])
        {
        [delegate sendViewDidDisappear:self];
        }
    }
    
#pragma mark - WBSendView Public Methods
    
    - (void) justShow {
        self.alpha = 100;
    }
    
    - (void)show:(BOOL)animated
    {
    [self sizeToFitOrientation:[self currentOrientation]];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
	if (!window)
        {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
  	[window addSubview:self];
    
    if ([delegate respondsToSelector:@selector(sendViewWillAppear:)])
        {
        [delegate sendViewWillAppear:self];
        }
    
    if (animated)
        {
        [panelView setAlpha:0];
        CGAffineTransform transform = CGAffineTransformIdentity;
        [panelView setTransform:CGAffineTransformScale(transform, 0.3, 0.3)];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f]];
        [panelView setAlpha:0.5];
        [panelView setTransform:CGAffineTransformScale(transform, 1.1, 1.1)];
        [UIView commitAnimations];
        }
    else
        {
        [self allAnimationsStopped];
        }
    [self addObservers];
    
    }
    
    - (void)justHide {
        self.alpha = 0;
    }
    
    - (void)hide:(BOOL)animated
    {
    if ([delegate respondsToSelector:@selector(sendViewWillDisappear:)])
        {
        [delegate sendViewWillDisappear:self];
        }
    
	if (animated)
        {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(hideAndCleanUp)];
		self.alpha = 0;
		[UIView commitAnimations];
        } else {
            [self hideAndCleanUp];
        }
    }
    
#pragma mark - UIDeviceOrientationDidChangeNotification Methods
    
    - (void)deviceOrientationDidChange:(id)object
    {
	UIInterfaceOrientation orientation = [self currentOrientation];
	if ([self shouldRotateToOrientation:orientation])
        {
        NSTimeInterval duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[self sizeToFitOrientation:orientation];
		[UIView commitAnimations];
        }
    }
    
#pragma mark - UIKeyboardNotification Methods
    
    - (void)keyboardWillShow:(NSNotification*)notification
    {
    if (isKeyboardShowing)
        {
        return;
        }
	
	isKeyboardShowing = YES;
	
	if (WBIsDeviceIPad())
        {
            // iPad is not supported in this version
		return;
        }
	
	if (UIInterfaceOrientationIsLandscape([self currentOrientation]))
        {
        
 		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
        [contentTextView setFrame:CGRectInset(contentTextView.frame, 0, -10)];
        
        NSEnumerator *keyEnum = [platformDict keyEnumerator];
        NSString *key = nil;UIButton *platformButton = nil;
        while (key = [keyEnum nextObject]) {
            platformButton = [platformDict objectForKey:key];
            [platformButton setFrame:CGRectMake(platformButton.frame.origin.x, contentTextView.frame.origin.y + contentTextView.frame.size.height, platformButton.frame.size.width, platformButton.frame.size.height)];
        }
 		
            //[contentTextView setFrame:CGRectMake(13, 50, 480 - 32 - 26, 60)];
        [contentImageView setCenter:CGPointMake(448 / 2, 145)];
        [clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                contentImageView.center.y - contentImageView.frame.size.height / 2)];
        
		[wordCountLabel setFrame:CGRectMake(224 + 90, 100, 30, 30)];
		[clearTextButton setFrame:CGRectMake(224 + 120, 101, 30, 30)];
        
 		[UIView commitAnimations];
        }
	else
        {
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		
		[panelView setFrame:CGRectInset(panelView.frame, 0, -71)];
		
 		[UIView commitAnimations];
        }
    }
    
    - (void)keyboardWillHide:(NSNotification*)notification
    {
	isKeyboardShowing = NO;
	
	if (WBIsDeviceIPad())
        {
		return;
        }
    
	if (UIInterfaceOrientationIsLandscape([self currentOrientation]))
        {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
        [contentTextView setFrame:CGRectInset(contentTextView.frame, 0, 10)];
        NSEnumerator *keyEnum = [platformDict keyEnumerator];
        NSString *key = nil;UIButton *platformButton = nil;
        while (key = [keyEnum nextObject]) {
            platformButton = [platformDict objectForKey:key];
            [platformButton setFrame:CGRectMake(platformButton.frame.origin.x, contentTextView.frame.origin.y + contentTextView.frame.size.height, platformButton.frame.size.width, platformButton.frame.size.height)];
        }
        [contentImageView setCenter:CGPointMake(448 / 2, 145 + 60)];
        [clearImageButton setCenter:CGPointMake(contentImageView.center.x + contentImageView.frame.size.width / 2,
                                                contentImageView.center.y - contentImageView.frame.size.height / 2)];
        
		[wordCountLabel setFrame:CGRectMake(224 + 90, 100 + 60, 30, 30)];
		[clearTextButton setFrame:CGRectMake(224 + 120, 101 + 60, 30, 30)];
		
 		[UIView commitAnimations];
        }
	else {
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		
		[panelView setFrame:CGRectInset(panelView.frame, 0, 71)];
		
		[UIView commitAnimations];
	}
    
    }
    
#pragma mark - UITextViewDelegate Methods
    
    - (void)textViewDidChange:(UITextView *)textView
    {
	[self calculateTextLength];
    }
    
    - (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
    {	
        return YES;
    }
    
    
#pragma mark - background methods
    
    -(void)backgroundTap:(id)sender{
        [contentTextView resignFirstResponder];
    }
    
#pragma mark - platform click event
    -(void)platformClicked:(id)sender {
        NSInteger tagId = [sender tag];
        id sharer = [sharerDict objectForKey:[NSString stringWithPlatform:tagId]];
        if (![sharer isVerified]) {
            if ([sharer respondsToSelector:@selector(beginOAuthVerification)]) {
                [sharer beginOAuthVerification];
            }
        } else {
            NSString *pName = [NSString stringWithPlatform:[sharer getPlatformName]];
            UIButton *button = [platformDict objectForKey:pName];
            
            if (!button) {
                return;
            }
            if ([keysOfEnabledSharer containsObject:pName]) {
                [keysOfEnabledSharer removeObject:pName];
                [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bs_p_u_%@",pName]] forState:UIControlStateNormal];
            } else {
                [keysOfEnabledSharer addObject:pName];
                [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bs_p_%@",pName]] forState:UIControlStateNormal];
            }
        }
    }
    
#pragma mark - init from config
    - (void)loadConfig
    {
    
    NSDictionary *config=[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ServiceConfig" ofType:@"plist"]];
    NSArray *services=[config objectForKey:@"OAuthServices"];
    
        //init sharerArray;
        //    if (sharerArray) {
        //        [sharerArray release];
        //        sharerArray = nil;
        //    }
        //    sharerArray = [[NSMutableArray alloc] init];
    
    if (sharerDict) {
        [sharerDict release];
        sharerDict = nil;
    }
    sharerDict = [[NSMutableDictionary alloc]init];
    
    for(int i=0; i<[services count];i++)
        {
        NSDictionary *dict=[services objectAtIndex:i];
        id<SHSOAuthSharerProtocol> sharer=nil;
        
        OAuthType type=[[dict objectForKey:@"oauthType"] intValue]; 
        BOOL isMore=[[dict objectForKey:@"isMore"] boolValue];
            // if isMore then break current loop;
        if (isMore) {
            break;
        }
        switch (type) {
            case OAuthTypeOAuth1WithHeader:
            case OAuthTypeOAuth1WithQueryString:
            {
            SHSOAuth1Sharer * serviceSharer=[[[NSClassFromString([dict objectForKey:@"name"]) alloc] init] autorelease];
            serviceSharer.key=[dict objectForKey:@"key"];
            serviceSharer.name=[dict objectForKey:@"title"];
            serviceSharer.requestTokenURL=[dict objectForKey:@"requestTokenURL"];
            serviceSharer.autherizeURL=[dict objectForKey:@"authorizeURL"];
            serviceSharer.accessTokenURL=[dict objectForKey:@"accessTokenURL"];
            serviceSharer.callbackURL=[dict objectForKey:@"callbackURL"];
            serviceSharer.rootViewController=self.rootViewController;
            serviceSharer.delegate=self;
            serviceSharer.signatureProvider=[[[OAHMAC_SHA1SignatureProvider alloc] init] autorelease];
            serviceSharer.oauthType=type;
            sharer=serviceSharer;
            }
                break;
            case OAuthTypeOAuth2:
            {
            SHSOAuth2Sharer * serviceSharer=[[[NSClassFromString([dict objectForKey:@"name"]) alloc] init] autorelease];
            serviceSharer.key=[dict objectForKey:@"key"];
            serviceSharer.name=[dict objectForKey:@"title"];
            serviceSharer.autherizeURL=[dict objectForKey:@"authorizeURL"];
            serviceSharer.callbackURL=[dict objectForKey:@"callbackURL"];
            serviceSharer.rootViewController=self.rootViewController;
            serviceSharer.delegate=self;
            serviceSharer.oauthType=type;
            sharer=serviceSharer;
            }
                break;
            default:
                break;
        }
        if (sharer) {
                //            [sharerArray addObject:sharer];
            [sharerDict setValue:sharer forKey:[NSString stringWithPlatform:[sharer getPlatformName]]];
        }
        }//loop end
    }
    
    - (void) initPlatformButton:(UIView *)parent lastElement:(CGPoint) lastEle {
        if (platformDict) {
            [platformDict release],platformDict=nil;
        }
        platformDict = [[NSMutableDictionary alloc]init];
        id<SHSOAuthSharerProtocol> sharer = nil;
        int line = 0;
        CGFloat y = lastEle.y + 10;CGFloat x = 13;
            //    CGFloat space = (parent.frame.size.width - 13*2- 30*[sharerArray count]) / ([sharerArray count]-1);
            //    NSInteger count = [sharerDict count];
            //    CGFloat space = (parent.frame.size.width - 13*2- 30*count) / (count - 1);
            //    if (space < 0 ) {
        CGFloat  space = 10;
            //    }
        UIButton *button = nil;
        NSEnumerator *sharerKeys = [sharerDict keyEnumerator];
        id key;
        while (key = [sharerKeys nextObject]) {
                //    for (sharer in sharerArray) {
            sharer=[sharerDict objectForKey:key];
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            if ((x + 30) >= parent.frame.size.width) {
                x = 13;line++;
            }
            [button setShowsTouchWhenHighlighted:YES];
            [button setFrame:CGRectMake(x, y + line * 10, 31, 31)];
            [button setTag:[sharer getPlatformName]];
            x = x + 30 + space;
            NSString *pngName = nil;
            if ([sharer isVerified]) {
                pngName =  [NSString stringWithFormat:@"bs_p_%@.png",[NSString stringWithPlatform:[sharer getPlatformName]]];
                [keysOfEnabledSharer addObject:[NSString stringWithPlatform:[sharer getPlatformName]]];
            } else {
                pngName = [NSString stringWithFormat:@"bs_p_u_%@.png",[NSString stringWithPlatform:[sharer getPlatformName]]];
            }
            
            [button setBackgroundImage:[UIImage imageNamed:pngName] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(platformClicked:) forControlEvents:UIControlEventTouchUpInside];
            [platformDict setValue:button forKey:[NSString stringWithPlatform:[sharer getPlatformName]]];
            [parent addSubview:button];
        }
    }
    
#pragma mark - SHOauthDelegate
    
    -(void)OAuthSharerDidBeginVerification:(id<SHSOAuthSharerProtocol>)oauthSharer {
        [self justHide];
        if(!_loadView)
            _loadView=[[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 130, 100) LoadingViewStyle:LoadingViewStyleStandard];
        _loadView.titleLabel.font=[UIFont boldSystemFontOfSize:13];
        _loadView.title=@"加载中";
        
        _loadView.alpha=0;
        _loadView.transform=CGAffineTransformMakeScale(1.7f, 1.7f);
        UIView *rootView = self.rootViewController.view;
        [_loadView showInView:rootView];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        _loadView.alpha=1;
        _loadView.transform=CGAffineTransformMakeScale(1, 1);
        [UIView commitAnimations];
    }
    
    -(void)OAuthSharerDidCancelVerification:(id<SHSOAuthSharerProtocol>)oauthSharer {
        [self loadViewDidDismissed];
        [self justShow];
    }
    
    -(void)OAuthSharerDidFinishVerification:(id<SHSOAuthSharerProtocol>)oauthSharer {
        [self loadViewDidDismissed];
        [self justShow];
        NSString *pname = [NSString stringWithPlatform:[oauthSharer getPlatformName]];
        UIButton *button = [platformDict objectForKey:pname];
        [keysOfEnabledSharer addObject:pname];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bs_p_%@.png",pname]] forState:UIControlStateNormal];
    }
    
    -(void)OAuthSharerDidFailInVerification:(id<SHSOAuthSharerProtocol>)oauthSharer {
        [self loadViewDidDismissed];
        if(!_loadView)
            _loadView=[[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 130, 100) LoadingViewStyle:LoadingViewStyleTilte];
        _loadView.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        _loadView.title=@"用户授权失败";
        
        _loadView.alpha=0;
        _loadView.transform=CGAffineTransformMakeScale(1.7f, 1.7f);
        [_loadView showInView:_rootViewController.view];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        _loadView.alpha=1;
        _loadView.transform=CGAffineTransformMakeScale(1, 1);
        [UIView commitAnimations];
        [self performSelector:@selector(loadViewDelayClose) withObject:nil afterDelay:1];
        [self performSelector:@selector(justShow) withObject:nil afterDelay:1];
    }
    
    -(void)OAuthSharerDidBeginShare:(id<SHSOAuthSharerProtocol>)oauthSharer {
        if(!_loadView)
            _loadView=[[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 130, 100) LoadingViewStyle:LoadingViewStyleTilte];
        _loadView.titleLabel.font=[UIFont boldSystemFontOfSize:15];
        _loadView.title=@"分享中";
        
        _loadView.alpha=0;
        _loadView.transform=CGAffineTransformMakeScale(1.7f, 1.7f);
        [_loadView showInView: self];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        _loadView.alpha=1;
        _loadView.transform=CGAffineTransformMakeScale(1, 1);
        [UIView commitAnimations];
    }
    
    - (void)OAuthSharerDidFinishShare:(id<SHSOAuthSharerProtocol>)oauthSharer
    {
    _loadView.title=@"分享成功!";
    [self performSelector:@selector(loadViewDelayClose) withObject:nil afterDelay:1];
    }
    
    - (void)OAuthSharerDidFailShare:(id<SHSOAuthSharerProtocol>)oauthSharer
    {
    _loadView.title=@"分享失败!";
    [self performSelector:@selector(loadViewDelayClose) withObject:nil afterDelay:1];
    }
    
#pragma mark - loading view
    
    - (void)loadViewDelayClose
    {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(loadViewDidDismissed)];
    _loadView.alpha=0;
    _loadView.transform=CGAffineTransformMakeScale(1.7f, 1.7f);
    [UIView commitAnimations];
    }
    
    - (void)loadViewDidDismissed
    {
    [_loadView dismiss];
    [_loadView release];
    _loadView=nil;
    }
    
    @end
