//
//  YPAlertView.h
//  SYPProject
//
//  Created by sunyuping on 12-10-16.
//
//

#import <Foundation/Foundation.h>

typedef void (^YPAlertViewDoneBlock)(void);
typedef void (^YPAlertViewCancelBlock)(void);

@protocol YPAlertViewDelegate;

@interface YPAlertView : NSObject {
@protected
    UIView *_view;
    NSMutableArray *_blocks;
    CGFloat _height;
    
    id<YPAlertViewDelegate> _delegate;
    BOOL _hasCancelButton;
}



+ (YPAlertView *)alertViewWith:(NSString *)title
                       message:(NSString *)message
                      delegate:(id<YPAlertViewDelegate>)delegate
                  cancelButton:(BOOL)isHasCancelBtn;

+ (YPAlertView *)alertViewWith:(NSString *)title
                       message:(NSString *)message
                     doneBlock:(YPAlertViewDoneBlock)doneBlock
                   cancelBlock:(YPAlertViewCancelBlock)cancelBlock;

+ (YPAlertView *)alertViewWith:(NSString *)title
                       message:(NSString *)message
                      delegate:(id<YPAlertViewDelegate>)delegate
               doneButtonTitle:(NSString*)doneTitle
             cancelButtonTitle:(NSString*)cancelTitle;

+ (YPAlertView *)alertViewWith:(NSString *)title
                       message:(NSString *)message
               doneButtonTitle:(NSString*)doneTitle
                     doneBlock:(YPAlertViewDoneBlock)doneBlock
             cancelButtonTitle:(NSString*)cancelTitle
                   cancelBlock:(YPAlertViewCancelBlock)cancelBlock;


// 此函数生成的alertview 在不添加任何按钮的时候 会延迟2秒消失。
+ (YPAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message;

- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block;

- (void)show;
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

@property (nonatomic, readonly) UIView *view;
@property (nonatomic) NSUInteger tag;

@end

@protocol YPAlertViewDelegate <NSObject>
@optional

- (void)commonAlertViewCancel:(YPAlertView *)alertView;

- (void)commonAlertViewDone:(YPAlertView *)alertView;

@end
