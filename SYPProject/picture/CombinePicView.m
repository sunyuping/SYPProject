//
//  CombinePicView.m
//  SYPProject
//
//  Created by sunyuping on 12-10-23.
//
//

#import "CombinePicView.h"

@implementation CombinePicView
@synthesize backGroundImage=_backGroundImage;

-(void)dealloc{
    self.backGroundImage = nil;
    [super dealloc];
}
-(id)init{
    self = [super init];
    if (self) {
        _backGroundImage = [[UIImageView alloc] init];
        [self addSubview:_backGroundImage];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.clipsToBounds = YES;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _backGroundImage = [[UIImageView alloc] init];
        self.backGroundImage.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:_backGroundImage];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.clipsToBounds = YES;
    }
    return self;
}
-(void)layoutSubviews{
    self.backGroundImage.frame = self.bounds;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
