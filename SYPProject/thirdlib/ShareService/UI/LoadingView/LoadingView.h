//
//  LoadingView.h
//  LOLCasts
//
//  Created by Jason on 30/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum 
{
    LoadingViewStyleStandard,
    LoadingViewStyleTilte,
    LoadingViewStyleAcivityIndicator,
    LoadingViewStyleNoBackground,
    LoadingViewStyleNoResult,
    LoadingViewStyleCircleProgress
}LoadingViewStyle;

@interface LoadingView : UIView {
    UIActivityIndicatorView *_activityIndicatior;
    UILabel *_loadingTitle;
    LoadingViewStyle _loadingViewStyle;
}

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic,retain) NSString *title;

- (id)initWithFrame:(CGRect)frame LoadingViewStyle:(LoadingViewStyle)style;

- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
