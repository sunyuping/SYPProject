#import <Foundation/Foundation.h>

@class RMError;
@protocol RMRequestContextDelegate <NSObject>

@optional

/**
 *zh
 * 当RequestContext异步发送请求开始时触发此回调。
 *
 *en
 * this callback is triggered when RequestContext send asynchronous request
 */ 
- (void)contextDidStartLoad:(id) context;

/**
 *zh
 * 当RequestContext异步请求结束，成功返回数据时触发此回调，并调用context的response查看回调
 *
 *en
 * this callback is triggered when the asynchronous request sent by RequestContext ended and return the data successfully, you can call context's response to check it out
 */ 
- (void)contextDidFinishLoad:(id) context;

/**
 *zh
 * 当RequestContext异步请求失败时触发此回调，error的错误可能有网络错误，服务错误。
 *
 *en
 *  this callback is triggered when the asynchronous request is failed, the value of error message could be network error or service error
 */ 
- (void)context:(id) context didFailLoadWithError:(RMError*)error;

/**
 *zh
 * 当RequestContext异步请求取消时，context主动调用了cancel方法会触发此回调
 *
 *en
 * this callback is triggered when the asynchronous request is canceled which means context call the cancle method.
 */
- (void)contextDidCancelLoad:(id)context;

@end

//#import "RMCommonContext.h"
//
//@interface RMCommonContext (Context_Delegate)
//
//- (void)cancel;
//
//@end

