//
//  RMCommonContextPrivate.h
//  RMSDK
//
//  Created by 王 永胜 on 12-2-13.
//  Copyright (c) 2012年 人人网. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RMRequestContextDelegate;

@interface RMCommonContext : NSObject {
    NSData *_responseData;
    id _objectParsedFromJsonString;
}
@property(nonatomic ,assign) id<RMRequestContextDelegate>delegate;

/**
 * 返回一个RMCommonContext对象，delegate要是实现协议RMRequestContextDelegate
 */
+ (id)contextWithDelegate:(id<RMRequestContextDelegate>)delegate;
@end
