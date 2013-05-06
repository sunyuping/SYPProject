//
//  UIFont+PKFont.m
//  SYPFrameWork
//
//  Created by sunyuping on 12-12-27.
//  Copyright (c) 2012年 sunyuping. All rights reserved.
//

#import "UIFont+PKFont.h"
#import "PKResManager.h"
@implementation UIFont (PKFont)

+ (UIFont *)fontForKey:(id)key
{
    NSArray *keyArray = [key componentsSeparatedByString:@"-"];
    NSAssert1(keyArray.count == 2, @"module key name error!!! [font]==> %@", key);
    
    NSString *moduleKey = [keyArray objectAtIndex:0];
    NSString *memberKey = [keyArray objectAtIndex:1];
    
    NSDictionary *moduleDict = [[PKResManager getInstance].resOtherCache objectForKey:moduleKey];
    NSDictionary *memberDict = [moduleDict objectForKey:memberKey];
    
    NSString *fontName = [memberDict objectForKey:@"name"];
    NSNumber *fontSize = [memberDict objectForKey:@"size"];
    UIFont *font = [UIFont fontWithName:fontName
                                   size:fontSize.floatValue];
    
    return font;
}

@end
