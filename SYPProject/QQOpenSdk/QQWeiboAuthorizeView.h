//
//  QQWeiboAuthorizeView.h
//  SYPProject
//
//  Created by sunyuping on 12-10-18.
//
//

#import <UIKit/UIKit.h>
#import "OpenSdkOauth.h"
/*
 * 获取oauth1.0票据的key
 */
#define oauth1TokenKey @"AccessToken"
#define oauth1SecretKey @"AccessTokenSecret"

/*
 * 获取oauth2.0票据的key
 */
#define oauth2TokenKey @"access_token="
#define oauth2OpenidKey @"openid="
#define oauth2OpenkeyKey @"openkey="
#define oauth2ExpireInKey @"expires_in="


@protocol QQWeiboAuthorizeViewDelegate;

@interface QQWeiboAuthorizeView : UIView<UIWebViewDelegate>{
    UIWebView *webView;
    UIButton *closeButton;
    UIView *modalBackgroundView;
    UIActivityIndicatorView *indicatorView;
    UIInterfaceOrientation previousOrientation;
    
    id<QQWeiboAuthorizeViewDelegate> delegate;
    
    NSString *appRedirectURI;
    NSDictionary *authParams;
}
@property (nonatomic, assign) id<QQWeiboAuthorizeViewDelegate> delegate;
@property (nonatomic, assign) OpenSdkOauth *OpenSdkOauth;
- (id)initWithAuthParams:(NSDictionary *)params
                delegate:(id<QQWeiboAuthorizeViewDelegate>)delegate;

- (void)show;
- (void)hide;

@end

@protocol QQWeiboAuthorizeViewDelegate <NSObject>

/*
 * 登录成功后调用，获取OpenSdkOauth各成员变量的值
 */
- (void) oauthDidSuccess:(NSString *)accessToken accessSecret:(NSString *)accessSecret openid:(NSString *)openid openkey:(NSString *)openkey expireIn:(NSString *)expireIn;

/*
 * 授权失败调用，可能由于网络原因或参数值设置原因等
 */
- (void) oauthDidFail:(uint16_t)oauthType success:(BOOL)success netNotWork:(BOOL)netNotWork;

/*
 * webView方式，拒绝授权时调用
 */
- (void) refuseOauth:(NSURL *)url;
@end