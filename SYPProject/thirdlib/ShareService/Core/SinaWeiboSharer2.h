
#import <Foundation/Foundation.h>
#import "SHSOAuth2Sharer.h"
#import "WB2Request.h"
#import "WB2SDKGlobal.h"

@interface SinaWeiboSharer2 : SHSOAuth2Sharer<WBRequestDelegate> {
    WBRequest *_request;
}

@property (retain,nonatomic) WBRequest *request;

@end
