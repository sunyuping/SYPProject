//
//  YPWeiXin.h
//  SYPProject
//
//  Created by sunyuping on 12-10-19.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

#define KWeiXinAppKey @"wx0f2670f1b023cc77"

@interface YPWeiXin : NSObject<WXApiDelegate>

+(void)registerApp:(NSString*)AppId;
+(BOOL)handleOpenURL:(NSURL*)url;

@end
