//
//  NSDate+NSDateExt.m
//  xiaonei
//
//  Created by ipod on 09-6-18.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSDate+NSDateExt.h"
#import "NSString+NSStringEx.h"


@implementation NSDate(NSDateExt)

- (NSString*) stringForSectionTitle4 {//目前sixin和ipad的时间分割策略，今天只显示HH:mm,不显示“今天”
	
	NSString *title;
    
	NSInteger intervalDay = [self compareWithToday];
	if (0 == intervalDay) {
		title = [NSString stringWithFormat:@"%@",[self stringForTimeline2]];
	} else if (-1 == intervalDay) {
		title = [NSString stringWithFormat:@"昨天 %@",[self stringForTimeline2]];
	} else if (-2 == intervalDay) {
        title = [NSString stringWithFormat:@"前天 %@",[self stringForTimeline2]];
	} else {
        
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //[formatter setDateFormat:@"MM-dd HH:mm"];
		[formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
		title = [formatter stringFromDate:self];
		[formatter release];
	}
	
	return title;
}

- (NSString*) stringForSectionTitle3 {
	
	NSString *title;
    
	NSInteger intervalDay = [self compareWithToday];
	if (0 == intervalDay) {
		title = [NSString stringWithFormat:@"今天 %@",[self stringForTimeline2]];
	} else if (-1 == intervalDay) {
		title = [NSString stringWithFormat:@"昨天 %@",[self stringForTimeline2]];
    } else if (-2 == intervalDay) {
        title = [NSString stringWithFormat:@"前天 %@",[self stringForTimeline2]];
	} else {
        
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //if ([self compareWithThisYear]) {
        [formatter setDateFormat:@"MM-dd HH:mm"];
        //}
		
		title = [formatter stringFromDate:self];
		[formatter release];
	}
	
	return title;
}

- (NSString*) stringForSectionTitle2 {
	
	NSString *title;
    
	NSInteger intervalDay = [self compareWithToday];
	if (0 == intervalDay) {
		title = [NSString stringWithFormat:@"今天 %@",[self stringForTimeline2]];
	} else if (-1 == intervalDay) {
		title = [NSString stringWithFormat:@"昨天 %@",[self stringForTimeline2]];
	} else if (-2 == intervalDay) {
		title = [NSString stringWithFormat:@"前天 %@",[self stringForTimeline2]];
	} else {
        
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if ([self compareWithThisYear]) {
            [formatter setDateFormat:@"MM-dd HH:mm"];
        }else{
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        }
		
		title = [formatter stringFromDate:self];
		[formatter release];
	}
	
	return title;
}

- (BOOL) compareWithToday2{
    NSDate *today = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	NSString *todayStr = [formatter stringFromDate:today];
	today = [formatter dateFromString:todayStr];
	
	NSInteger interval = (NSInteger) [self timeIntervalSinceDate:today];
	
	NSInteger intervalDate = 0;
	if (interval <= 0) {
		intervalDate = interval / (24 * 60 * 60) - 1; 
	} else {
		intervalDate = interval / (24 * 60 * 60);
	}
	
	[formatter release];
    if (intervalDate ==0) {
        return YES; 
    }else{
        return NO;
    }
}

- (NSString*) stringForSectionTitle {
	
	NSString *title;
    
	NSInteger intervalDay = [self compareWithToday];
	if (0 == intervalDay) {
		title = @"今天";
	} else if (-1 == intervalDay) {
		title = @"昨天";
	} else if (-2 == intervalDay) {
		title = @"前天";
	} else {
        
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateFormat:@"yyyy-MM-dd"];
		title = [formatter stringFromDate:self];
		[formatter release];
	}
	
	return title;
}

- (BOOL)compareWithThisYear
{
    NSDate *thisYear = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy"];
	
	NSString *thisYearString = [formatter stringFromDate:thisYear];
	NSString *dateYearString = [formatter stringFromDate:self];
    BOOL isThisYear = [thisYearString isEqualToString:dateYearString];	
	[formatter release];
	return isThisYear;
    
}

- (NSInteger) compareWithToday {
	
	
	NSDate *today = [NSDate date];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	
	NSString *todayStr = [formatter stringFromDate:today];
	today = [formatter dateFromString:todayStr];
	
	NSInteger interval = (NSInteger) [self timeIntervalSinceDate:today];
	
	NSInteger intervalDate = 0;
	if (interval <= 0) {
		intervalDate = interval / (24 * 60 * 60) - 1; 
	} else {
		intervalDate = interval / (24 * 60 * 60);
	}
	
	[formatter release];
	return intervalDate;
}

- (NSString*) stringForDateline {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	NSString* str = [formatter stringFromDate:self];
	[formatter release];
	return str;
}

- (NSString*) stringForTimeline {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MM-dd HH:mm"];
	NSString *timeStr = [formatter stringFromDate:self];
	
	[formatter release];
	
	return timeStr;
}

- (NSString*) stringForTimeline2{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"HH:mm"];
	NSString *timeStr = [formatter stringFromDate:self];
	
	[formatter release];
	
	return timeStr;
}

/**
 * 计算原时间与现在时间的相对差，以字符串形式返回
 */
- (NSString*) stringForTimeRelative {
   	NSString *title = nil;
	
	int intervalSecond = -(int)[self timeIntervalSinceNow];
	int t = 0;
	if ((t = intervalSecond/(60*60*24)) != 0) {
		if (t > 2) {
			title = [self stringForTimeline];
		}else {
			title = [NSString stringWithFormat:@"%d天前",t];
		}
	} else if ((t = intervalSecond/(60*60)) != 0) {
		title = [NSString stringWithFormat:@"%d小时前",t];
	} else if ((t = intervalSecond/60) != 0) {
		title = [NSString stringWithFormat:@"%d分钟前",t];
	} else {
		//title = @"刚刚更新";
        title = @"刚刚发送";
	}
	
	return title;
}


- (NSString*) stringForYyyymmddhhmmss{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyyMMddHHmmss"];
	NSString *timeStr = [formatter stringFromDate:self];
	
	[formatter release];
	
	return timeStr;
}

// 计算自1970年以来的秒数并返回字符串
- (NSString *) stringForIntervalSince1970 {
	NSNumber *seconds = [NSNumber numberWithDouble:[self timeIntervalSince1970]];
	
	return [seconds stringValue];
}

@end
