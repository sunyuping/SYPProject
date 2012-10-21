//
//  SHSRedirectSharer.h
//  ShareDemo
//
//  Created by mini2 on 2/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHSCommon.h"

@interface SHSRedirectSharer : NSObject
{
    NSString *_name;
    NSString *_title;
}

@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *name;

//通过bshare接口实现浏览器跳转分享，其中text,URL为必填，否则bshare会返回错误信息
- (NSString *)getShareUrlWithTitle:(NSString *)title withText:(NSString *)text withURL:(NSString *)URL withImageURL:(NSString *)imageURL;

-(NSString *)getURL:(NSString *)url ;
@end
