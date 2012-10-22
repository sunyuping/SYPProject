//
//  SHSOAuthSharer.h
//  ShareDemo
//
//  Created by tmy on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHSCommon.h"
#import "OAuthInfo.h"

@protocol SHSOAuthSharerProtocol;

@protocol SHSOAuthDelegate <NSObject>

@optional
- (void)OAuthSharerDidBeginVerification:(id<SHSOAuthSharerProtocol>)oauthSharer;
- (void)OAuthSharerDidFinishVerification:(id<SHSOAuthSharerProtocol>)oauthSharer;
- (void)OAuthSharerDidCancelVerification:(id<SHSOAuthSharerProtocol>)oauthSharer;
- (void)OAuthSharerDidFailInVerification:(id<SHSOAuthSharerProtocol>)oauthSharer;
- (void)OAuthSharerDidBeginShare:(id<SHSOAuthSharerProtocol>)oauthSharer;
- (void)OAuthSharerDidFinishShare:(id<SHSOAuthSharerProtocol>)oauthSharer;
- (void)OAuthSharerDidFailShare:(id<SHSOAuthSharerProtocol>)oauthSharer;
@end

@protocol SHSOAuthSharerProtocol <NSObject>
@property (nonatomic, retain) NSString *key;
@property (nonatomic,retain) NSString *name;
@property (nonatomic) OAuthType oauthType;
@property (nonatomic) ShareType pendingShare;
@property (nonatomic,retain) NSString *sharedUrl;
@property (nonatomic,retain) NSString *sharedText;
@property (nonatomic,retain) UIImage *sharedImage;
@property (nonatomic,assign) id<SHSOAuthDelegate> delegate;
@property (nonatomic,assign) UIViewController *rootViewController;

- (void)beginOAuthVerification;
- (void)SaveToken;
- (BOOL)isVerified;
- (void)shareText:(NSString *)text;
- (void)shareText:(NSString *)text andImage:(UIImage *)image;
- (NSString *)getURL:(NSString *)url andSite:(NSString *)site;

@optional
- (bsPlatform)getPlatformName;
@end
