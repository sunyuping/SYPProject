//
//  EGOTableFootView.h
//  TableSearch
//
//  Created by tymx on 11-7-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


typedef enum{
	EGOOPullRefreshPullings = 0,
	EGOOPullRefreshNormals,
	EGOOPullRefreshLoadings,	
} EGOPullRefreshStates;


@protocol EGORefreshTableFootDelegate;
@interface EGOTableFootView :UIView {
	EGOPullRefreshStates _state;
	id _delegate;
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
	NSInteger	_svOffset;
}

@property(nonatomic,assign) id <EGORefreshTableFootDelegate> delegate;

- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;


@end


@protocol EGORefreshTableFootDelegate
- (void)egoRefreshTableFootDidTriggerRefresh:(EGOTableFootView*)view;
- (BOOL)egoRefreshTableFootDataSourceIsLoading:(EGOTableFootView*)view;
@optional
- (NSDate*)egoRefreshTableFootDataSourceLastUpdated:(EGOTableFootView*)view;
@end
