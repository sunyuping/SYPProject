//
//  YPWeiXin.m
//  SYPProject
//
//  Created by sunyuping on 12-10-19.
//
//

#import "YPWeiXin.h"

static YPWeiXin *weixin;

@implementation YPWeiXin

+(YPWeiXin*)getWeiXin{
    if (weixin == nil) {
        weixin = [[YPWeiXin alloc] init];
        //注册微信
    }
    return weixin;
}
+(void)registerApp:(NSString*)AppId{
    [WXApi registerApp:KWeiXinAppKey];
}
+(BOOL)handleOpenURL:(NSURL*)url{
   return [WXApi handleOpenURL:url delegate:[YPWeiXin getWeiXin]];
}
/*! @brief 收到一个来自微信的请求，处理完后调用sendResp
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
-(void) onReq:(BaseReq*)req{
    
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
-(void) onResp:(BaseResp*)resp{
    
}

@end
