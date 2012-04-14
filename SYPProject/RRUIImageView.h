//
//  RRUIImageView.h
//  RRSpring
//
//  Created by 玉平 孙 on 12-3-12.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RRUIImageView : UIControl{
    //异步数据请求
    MKNetworkEngine *_imageEngine;
    //图片控件
    UIImageView *_imageView;  
    //加载图片等待动画控件
    UIActivityIndicatorView *_indicator; 
    //预留字段缓存路径
    NSString* cacheDir;
    //为cover定制的变量
    BOOL _canSetPosition;       //是否需要设置图片显示位置
    float _topPoint;            //图片显示的顶点位置单位是百分比
    float _leftPoint;           //图片显示的左边起点点位置单位是百分比
    BOOL _canMove;              //是否可以移动调整图片
    CGPoint gestureStartPoint;  //手势开始时起点
    CGFloat offsetX,offsetY;    //移动时x,y方向上的偏移量
    CGFloat curr_X,curr_Y;      //现在截取的图片内容的原点坐标
}
@property (nonatomic, retain) UIImageView *imageView; 
@property (nonatomic, retain) UIActivityIndicatorView *indicator; 
@property (nonatomic) BOOL canMove; 
//@property (nonatomic, retain) NSString* cacheDir;
/**
 * 初始化控件.
 */
- (id)initWithFrame:(CGRect)frame;
/**
 * 设置控件的url地址.
 */
- (void)setImageWithUrl:(NSString*)url;
/**
 * strURL：设置控件的url地址.
 */
- (void)LoadImageWithUrl:(NSString *) strURL; 
/**
 * strURL：设置控件的url地址.
 * force：true表示强制更新
 */
- (void)LoadImageWithUrl:(NSString *) strURL:(BOOL) force;  
/**
 * strURL：设置控件的image.
 */
- (void)setImage:(UIImage*)image;
/**
 * 设置图片的显示区域
 *  topPercentage：图片显示的高度起点跟整个高度的百分比
 *  leftPercentage：图片显示的左边界起点跟整个宽度的百分比
 */
-(void)setImageViewShowPosition:(float)topPercentage left:(float)leftPercentage;

-(void)moveToX:(CGFloat)x ToY:(CGFloat)y;
/**暂时放这里以后备用
 * 将两张图片合为一张图片.
 *返回一个uiimage的数据
 */
+ (UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2;
@end
