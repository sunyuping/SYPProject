//
//  NSDictionary+RNAdditions.h
//  RRSpring
//
//  Created by sheng siglea on 4/5/12.
//  Copyright (c) 2012 RenRen.com. All rights reserved.
//



@interface NSDictionary (RNAdditions)

/*
 返回指定key的字符串值
 没有指定key的值，返回默认值
 */
-(NSString *)stringForKey:(NSString *)key withDefault:(NSString *)defVal;
/*
 返回指定key的float值
 没有指定key的值，返回默认值
 */
-(CGFloat)floatForKey:(NSString *)key withDefault:(CGFloat)defVal;
/*
 返回指定key的timeInterval值
 没有指定key的值，返回默认值
 */
-(NSTimeInterval)timeIntervalForKey:(NSString *)key withDefault:(NSTimeInterval)defVal;
/*
 返回指定key的int值
 没有指定key的值，返回默认值
 */
-(NSInteger)intForKey:(NSString *)key withDefault:(NSInteger)defVal;

-(long long)longLongForKey:(NSString *)key withDefault:(long long)defVal;
- (NSString*)queryString;

@end
