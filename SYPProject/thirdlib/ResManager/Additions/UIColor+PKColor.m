//
//  UIColor+PKColor.m
//  SYPFrameWork
//
//  Created by sunyuping on 12-12-27.
//  Copyright (c) 2012年 sunyuping. All rights reserved.
//

#import "UIColor+PKColor.h"
#import "PKResManagerKit.h"

@implementation UIColor (PKColor)

+ (UIColor *)colorForKey:(id)key
{
    return [UIColor colorForKey:key style:PKColorTypeNormal];
}

+ (UIColor *)shadowColorForKey:(id)key
{
    return [UIColor colorForKey:key style:PKColorTypeShadow];
}

+ (UIColor *)colorForKey:(id)key style:(PKColorType)type
{
    NSArray *keyArray = [key componentsSeparatedByString:@"-"];
    NSAssert1(keyArray.count == 2, @"module key name error!!! [color] ==> %@", key);
    
    NSString *moduleKey = [keyArray objectAtIndex:0];
    NSString *memberKey = [keyArray objectAtIndex:1];
    
    NSDictionary *moduleDict = [[PKResManager getInstance].resOtherCache objectForKey:moduleKey];
    // 容错处理读取默认配置
    if (moduleDict.count <= 0)
    {
        moduleDict = [[PKResManager getInstance].defaultResOtherCache objectForKey:moduleKey];
    }
    NSAssert1(moduleDict.count > 0, @"module not exist !!! [color] ==> %@", key);
    NSDictionary *memberDict = [moduleDict objectForKey:memberKey];
    // 容错处理读取默认配置
    if (memberDict.count <= 0) {
        moduleDict = [[PKResManager getInstance].defaultResOtherCache objectForKey:moduleKey];
        memberDict = [moduleDict objectForKey:memberKey];
    }
    NSAssert1(memberDict.count > 0, @"color not exist !!! [color] ==> %@", key);
    
    NSString *colorStr = [memberDict objectForKey:kColor];
    
    BOOL shadow = NO;
    if (type & PKColorTypeShadow) {
        shadow = YES;
        colorStr = [memberDict objectForKey:kShadowColor];
    }
    if (type & PKColorTypeHightLight) {
        colorStr = [memberDict objectForKey:kColorHL];
        if (shadow) {
            colorStr = [memberDict objectForKey:kShadowColorHL];
        }
    }
    
    NSNumber *redValue;
    NSNumber *greenValue;
    NSNumber *blueValue;
    NSNumber *alphaValue;
    NSArray *colorArray = [colorStr componentsSeparatedByString:@","];
    if (colorArray != nil && colorArray.count == 3) {
        redValue = [NSNumber numberWithFloat:[[colorArray objectAtIndex:0] floatValue]];
        greenValue = [NSNumber numberWithFloat:[[colorArray objectAtIndex:1] floatValue]];
        blueValue = [NSNumber numberWithFloat:[[colorArray objectAtIndex:2] floatValue]];
        alphaValue = [NSNumber numberWithFloat:1.0f];
    } else if (colorArray != nil && colorArray.count == 4) {
        redValue = [NSNumber numberWithFloat:[[colorArray objectAtIndex:0] floatValue]];
        greenValue = [NSNumber numberWithFloat:[[colorArray objectAtIndex:1] floatValue]];
        blueValue = [NSNumber numberWithFloat:[[colorArray objectAtIndex:2] floatValue]];
        alphaValue = [NSNumber numberWithFloat:[[colorArray objectAtIndex:3] floatValue]];
    } else {
        return nil;
    }
    
    if ([alphaValue floatValue]<=0.0f) {
        return [UIColor clearColor];
    }
    return [UIColor colorWithRed:(CGFloat)([redValue floatValue]/255.0f)
                           green:(CGFloat)([greenValue floatValue]/255.0f)
                            blue:(CGFloat)([blueValue floatValue]/255.0f)
                           alpha:(CGFloat)([alphaValue floatValue])];
}

@end
