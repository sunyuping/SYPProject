//
//  NSDate+NSDateExt.h
//  xiaonei
//
//  Created by ipod on 09-6-18.
//  Copyright 2009 opi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(NSDateExt)
- (NSInteger) compareWithToday;
- (BOOL) compareWithToday2;
- (BOOL)compareWithThisYear;
- (NSString *) stringForSectionTitle;
- (NSString *) stringForSectionTitle2; //用于RenReniPad最近来访时间格式
- (NSString *) stringForSectionTitle3; //iphone
- (NSString *) stringForSectionTitle4;//目前sixin和ipad的时间分割策略，今天只显示HH:mm,不显示“今天”
- (NSString *) stringForDateline; //将时间变为 yyyy－mm－dd的格式
- (NSString *) stringForTimeline; //将时间变为 mm-dd HH:mm  
- (NSString *) stringForTimeline2;//将时间变为 HH:mm
- (NSString *) stringForTimeRelative;//计算原时间与现在时间的相对差，以字符串形式返回
- (NSString *) stringForYyyymmddhhmmss;
- (NSString *) stringForIntervalSince1970; // 计算自1970年以来的秒数并返回字符串

@end
