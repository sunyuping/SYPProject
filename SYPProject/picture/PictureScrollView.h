//
//  PictureScrollView.h
//  SYPProject
//
//  Created by sunyuping on 12-10-23.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol PictureMoveDelegate;

@interface PictureScrollView : UIScrollView

@property (nonatomic ,assign) id<PictureMoveDelegate> moveDelete;
@property (nonatomic, retain, readonly) UIImageView *showImageView;
-(void)setImage:(UIImage*)image;


@end

@protocol PictureMoveDelegate <NSObject>
@optional
- (void)pictureMoveShouldBegin:(PictureScrollView *)pictureView;
- (void)pictureMoveChange:(PictureScrollView *)pictureView;
- (void)pictureMoveEnd:(PictureScrollView *)pictureView;

@end
