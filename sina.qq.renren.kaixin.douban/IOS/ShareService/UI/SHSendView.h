//
//  WBSendView.h
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
//  OTHER DEALINGS IN THE SOFTWARE.
//
//  Copyright 2011 Sina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SHSCore.h"
#import "LoadingView.h"

@class SHSendView;

@protocol WBSendViewDelegate <NSObject> 


@optional

- (void)sendViewWillAppear:(SHSendView *)view;
- (void)sendViewDidAppear:(SHSendView *)view;
- (void)sendViewWillDisappear:(SHSendView *)view;
- (void)sendViewDidDisappear:(SHSendView *)view;

- (void)sendViewDidFinishSending:(SHSendView *)view;
- (void)sendView:(SHSendView *)view didFailWithError:(NSError *)error;

- (void)sendViewNotAuthorized:(SHSendView *)view;
- (void)sendViewAuthorizeExpired:(SHSendView *)view;

@end


@interface SHSendView : UIControl <UITextViewDelegate,SHSOAuthDelegate> 
{
    
    UITextView  *contentTextView;
    UIImageView *contentImageView;
    
    UIButton    *sendButton;
    UIButton    *closeButton;
    UIButton    *clearTextButton;
    UIButton    *clearImageButton;
    
    UIButton    *kaixinButton;
    UIButton    *renrenButton;
    UIButton    *sinaButton;
    UIButton    *sohuButton;
    UIButton    *tencentButton;
    
    UILabel     *titleLabel;
    UILabel     *wordCountLabel;
    
    UIControl      *panelView;
    UIImageView *panelImageView;
    
    NSString    *contentText;
    UIImage     *contentImage;
    
    UIInterfaceOrientation previousOrientation;
    
    BOOL        isKeyboardShowing;
    
    id<WBSendViewDelegate> delegate;
    
    UIViewController *_rootViewController;
    NSMutableDictionary *sharerDict;
    NSMutableDictionary *platformDict;
    NSMutableArray *keysOfEnabledSharer;
//        NSMutableArray *sharerArray;
    LoadingView *_loadView;
    
}

@property (nonatomic, retain) NSString *contentText;
@property (nonatomic, retain) UIImage *contentImage;
@property (nonatomic, assign) id<WBSendViewDelegate> delegate;
@property (nonatomic,assign) UIViewController *rootViewController;

- (id)initWithText:(NSString *)text image:(UIImage *)image andRootViewController:(UIViewController *)root;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;

@end
