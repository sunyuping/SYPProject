//
//  NSStringAddition.h
//  XYCore
//
//  Created by sunyuping on 13-1-23.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Query)

- (NSNumber*) stringToNumber;

/**
 * 将字符串以URL编码.但'=', '&'字符除外.
 *
 * @param stringEncoding 编码类型
 * @return 编码后的字符串
 */
- (NSString*) urlEncode:(NSStringEncoding)stringEncoding;
/*
 * 解码
 */
- (NSString*) urlDecode:(NSStringEncoding)stringEncoding;
/**
 * 将字符串以URL编码.
 *
 * @param stringEncoding 编码类型
 * @return 编码后的字符串
 */
- (NSString*) urlEncode2:(NSStringEncoding)stringEncoding;

- (NSString *)stringByReplaceString:(NSString *)rs withCharacter:(char)c;

/**
 * 将字符串MD5加密.
 *
 * @return 加密后的字符串.
 */
- (NSString*) md5;


+ (NSString*)componentsJoinedByDictionary:(NSDictionary *)dic
								seperator:(NSString *)seperator;


/**
 * 通过查询信息字典生成查询字符串, 可配置字符串经过URL Encode.
 *
 * @return URL Encode后的字符串.
 */
+ (NSString *)queryStringFromQueryDictionary:(NSDictionary *)query withURLEncode:(BOOL)doURLEncode;

/**
 * 生成查询标识符,目前用于唯一标识一个缓存地址.
 *
 * @return 查询标识符字符串.
 */
- (NSString*) queryIdentifier;

// Trim whitespace
- (NSString *)trim;
- (NSString *) stringTrimAsNewsfeed;
//- (NSString *) getParameter:(NSString *)parameterName;

/**
 * 对发送的一些字符做转义处理.
 */
- (NSString*)escapeForPost;

//- (NSString*) des3:(NSString*)key encrypt:(BOOL)isEncrypt;


/**
 * 对来自rest接口的状态进行过滤
 */
- (NSString*)stringByFilterForStatusFromRest;

/**
 * 去掉字符中间的空格,只保留一个.
 */
- (NSString*)stringByTrimmingWhitespace;


- (NSString*)fillUniqueId:(NSInteger)uniqueId;


-(NSInteger)CountWord;
/**
 *
 由于NSString自带length方法中文英文长度都为1，加入此方法，中文为2，英文为1
 */
-  (int)getCharLength;

//为了方便图片的显示增加借口
-(NSString*)getUrlBySize:(NSInteger)size;


//
+ (NSString *) preParseER:(NSString*)string;


@end
