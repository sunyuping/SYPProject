//
//  NSDateAddtional.h
//  XYCore
//
//  Created by sunyuping on 13-1-29.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(NSDateAddtional)


- (NSInteger) compareWithToday;
- (BOOL) compareWithToday2;
- (BOOL)compareWithThisYear;
- (NSString *) stringForSectionTitle;
- (NSString *) stringForSectionTitle2; //
- (NSString *) stringForSectionTitle3; ////消息列表中时间的显示规则
- (NSString *) stringForSectionTitle4;//消息详列表中使用的时间显示规则
- (NSString *) stringForDateline; //将时间变为 yyyy－mm－dd的格式
- (NSString *) stringForTimeline; //将时间变为 mm-dd HH:mm
- (NSString *) stringForTimeline2;//将时间变为 HH:mm
- (NSString *) stringForTimeRelative;//计算原时间与现在时间的相对差，以字符串形式返回
- (NSString *) stringForYyyymmddhhmmss;
- (NSString *) stringForIntervalSince1970; // 计算自1970年以来的秒数并返回字符串

@end