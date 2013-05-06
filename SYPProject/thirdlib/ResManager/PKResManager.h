//
//  PKResManager.h
//  SYPFrameWork
//
//  Created by sunyuping on 12-12-27.
//  Copyright (c) 2012年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
	PKErrorCodeSuccess						= 0, // 自定义,表示成功.
	PKErrorCodeUnknow                       = 1, // 未知错误
	PKErrorCodeUnavailable	        		= 2, // 不可用，需要下载
    PKErrorCodeBundleName                   = 3, // bundleName问题
} PKErrorCode;


typedef void (^ResStyleProgressBlock) (double progress);
typedef void (^ResStyleCompleteBlock) (BOOL finished, NSError *error);

typedef enum {
    ResStyleType_System,
    ResStyleType_Custom,
    ResStyleType_Unknow
}ResStyleType;


@protocol PKResChangeStyleDelegate <NSObject>
@optional
- (void)changeStyle:(id)sender;
@end

@interface PKResManager : NSObject

/*!
 * 当前主题 style bundle
 */
@property (nonatomic, readonly) NSBundle *styleBundle;
/*!
 * 默认主题下 plist 资源
 */
@property (nonatomic, readonly) NSMutableDictionary *defaultResOtherCache;
/*!
 * 图片缓存
 */
@property (nonatomic, retain) NSMutableDictionary *resImageCache;
/*!
 * plist 资源缓存
 */
@property (nonatomic, retain) NSMutableDictionary *resOtherCache;

/*!
 * All style Dict Array
 */
@property (nonatomic, readonly) NSMutableArray *allStyleArray;
/*!
 * Current style name
 */
@property (nonatomic, readonly) NSString *styleName;
/*!
 * Current style type
 */
@property (nonatomic, readonly) ResStyleType styleType;
/*!
 * is loading?
 */
@property (nonatomic, readonly) BOOL isLoading;

// Add style Object
- (void)addChangeStyleObject:(id)object;
// Object dealloc invoke this method!!!
- (void)removeChangeStyleObject:(id)object;
/*!
 * Switch to style by name
 * @discuss You should not swith to a new style until completed
 */
- (void)swithToStyle:(NSString *)name; // not safety
- (void)swithToStyle:(NSString *)name onComplete:(ResStyleCompleteBlock)block; 
/*!
 * containsStyle
 */
- (BOOL)containsStyle:(NSString *)name;
/*!
 * get change progress
 */
- (void)changeStyleOnProgress:(ResStyleProgressBlock)progressBlock;

/*!
 * save in custom file path
 */
- (BOOL)saveStyle:(NSString *)styleId name:(NSString *)name version:(NSNumber *)version withBundle:(NSBundle *)bundle;
/*!
 * delete style
 */
- (BOOL)deleteStyle:(NSString *)name;

/*!
 * clear image cache
 */
- (void)clearImageCache;
/*!
 * reset
 */
- (void)resetStyle;
/*!
 * 通过名字获取资源bundle
 */
- (NSBundle *)bundleByStyleName:(NSString *)name;
/*!
 * 预览图
 */
- (UIImage *)previewImage;
- (UIImage *)previewImageByStyleName:(NSString *)name;
/*!
 * 资源地址
 */
- (NSString *)resShortPathForKey:(id)key;

// 历史遗留问题
- (CGSize)shadowOffSetForKey:(id)key;

/*!
 * 单例
 */
+ (PKResManager*)getInstance;

@end
