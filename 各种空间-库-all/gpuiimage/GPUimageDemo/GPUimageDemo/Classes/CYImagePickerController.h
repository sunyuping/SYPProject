//
//  CYImagePickerController.h
//  CYFilter
//
//  Created by yi chen on 12-7-20.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYScrawlView.h"


/* 
	～～～～～～～～～～该文件已经被弃用～～～～～～～～～～～
	～～～～～～～～～～改用RSImagePickerController～～～～
 */

/**
 *	 info dictionary keys
 */
extern NSString * const kCYImagePickerImage ;
extern NSString * const kCYImagePickerGIF ;
extern NSString * const kCYImagePickerVideo ;
extern NSString * const kCYImagePickerDismissTimeSeconds ;

/**
 * state code
 */
typedef enum{
	CYImagePickerStateCapture = 1,	//	capturing image state
	CYImagePickerStateEditing,	//	editing image state
	CYImagePickerStateGIF,		//  caputre gif image,not implement now
	CYImagePickerStateVideo,	//  video state,not implement now 
}CYImagePickerState;

@class SBJsonParser;
@class GPUImageView;
@class CYScrawlView;
@protocol CYImagePickerControllerDelegate;
@protocol CYScrawlViewDelegate;


@interface CYImagePickerController : UIViewController

<CYScrawlViewDelegate,UIPickerViewDelegate,
UIPickerViewDataSource,UINavigationControllerDelegate,
UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate>

{
	
	id<CYImagePickerControllerDelegate>		_delegate;	 //	代理
	CYImagePickerState						_pickerState;//	状态码
	UIImage									*_editImage; // 待编辑的照片
}
@property(nonatomic,assign)id<CYImagePickerControllerDelegate>delegate;
@property(nonatomic,assign) CYImagePickerState pickerState;		//	状态码
@property(nonatomic,retain)UIImage *editImage;
@property(nonatomic,retain)GPUImageView *filterBackView;
@property(nonatomic,retain)CYScrawlView *snapScrawlView;

// init
- (id)initWithState:(CYImagePickerState)state editImage:(UIImage *)editImage;

//准备开始采集
- (void)prepareToCapture;
@end


@protocol CYImagePickerControllerDelegate <NSObject>

@optional
// The picker does not dismiss itself; the client dismisses it in these callbacks.
// The delegate will receive one or the other, but not both, depending whether the user
// confirms or cancels.
- (void)cyImagePickerController:(CYImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;

- (void)cyImagePickerControllerDidCancel:(CYImagePickerController *)picker;

@end

