//
//  UILabelAddition.m
//  XYCore
//
//  Created by sunyuping on 13-4-22.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "UILabelAddition.h"
#import "UIViewAdditions.h"

@implementation UILabel (UILabelAddition)

-(CGSize)autoWidthWithMax:(float)maxWidth{
    NSString *content = self.text;
    if (content.length == 0) {
        self.width = 0;
        return CGSizeZero;
    }
    CGSize size = CGSizeMake(maxWidth,CGFLOAT_MAX);
    CGSize labelsize = [content sizeWithFont:self.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    self.width = labelsize.width;
    return labelsize;
}
-(void)setAutoWidth:(NSString*)text maxWidth:(float)maxWidth{
    self.text = text;
    [self autoWidthWithMax:maxWidth];    
}
@end
