//
//  PictureScrollView.m
//  SYPProject
//
//  Created by sunyuping on 12-10-23.
//
//

#import "PictureScrollView.h"

@implementation PictureScrollView
@synthesize showImageView = _showImageView;
@synthesize moveDelete;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //_showImageView.image = [UIImage imageNamed:@"new.png"];
        _showImageView.userInteractionEnabled = YES;
        _showImageView.multipleTouchEnabled = YES;
       // self.layer.shadowColor = [UIColor blackColor].CGColor;
       // self.layer.shadowOffset = CGSizeMake(-1,-1);
        _showImageView.layer.shouldRasterize = YES;
       // _showImageView.layer.shadowOpacity = 1;
//        _showImageView.layer.borderColor = [UIColor whiteColor].CGColor;
//        _showImageView.layer.borderWidth = 1.0;
        [self addSubview:_showImageView];
        self.backgroundColor = [UIColor whiteColor];
        self.multipleTouchEnabled = YES;
        
        
        //6、长按手势
        UILongPressGestureRecognizer *longpressGesutre=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongpressGesture:)];
        //长按时间为1秒
        longpressGesutre.minimumPressDuration=1;
        //允许15秒中运动
        longpressGesutre.allowableMovement=15;
        //所需触摸1次
        longpressGesutre.numberOfTouchesRequired=1;
        [self addGestureRecognizer:longpressGesutre];
        [longpressGesutre release];
    }
    return self;
}
-(void)handleLongpressGesture:(UIGestureRecognizer*)sender{
    NSLog(@"syp===handleLongpressGesture==%@",sender);
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 2.0;
        if (self.moveDelete && [self.moveDelete respondsToSelector:@selector(pictureMoveShouldBegin:)]) {
            [self.moveDelete pictureMoveChange:self];
        }
    }else if (sender.state == UIGestureRecognizerStateChanged){
        if (self.moveDelete && [self.moveDelete respondsToSelector:@selector(pictureMoveChange:)]) {
            [self.moveDelete pictureMoveChange:self];
        }
    }else{
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.0;
        if (self.moveDelete && [self.moveDelete respondsToSelector:@selector(pictureMoveEnd:)]) {
            [self.moveDelete pictureMoveEnd:self];
        }
    }
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self layoutImageview];
}
-(void)setImage:(UIImage*)image{
    _showImageView.image = image;
    [self layoutImageview];
}
-(void)layoutImageview{
    if (self.showImageView.image) {
        CGSize imageSize = [self.showImageView.image size];
        float image_w = 0;
        float image_h = 0;
        if (self.bounds.size.width>=self.bounds.size.height) {
            image_w = self.bounds.size.width;
            image_h = imageSize.height*(image_w/imageSize.width);
        }else{
            image_h = self.bounds.size.height;
            image_w = imageSize.width*(image_h/imageSize.height);
        }
        _showImageView.frame = CGRectMake(0, 0, image_w, image_h);
        [self setContentSize:_showImageView.bounds.size];
    }
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
