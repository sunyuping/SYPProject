//
//  LoadingView.m
//  LOLCasts
//
//  Created by Jason on 30/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "LoadingView.h"

@interface LoadingView (privateMethod)

- (UIActivityIndicatorView *) initIndicatorWithStyle:(UIActivityIndicatorViewStyle)style;

- (UILabel *) initTitle:(NSString *)title;

@end


@implementation LoadingView (privateMethod)

- (UIActivityIndicatorView *) initIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
{
    UIActivityIndicatorView * activityIndicator=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    [activityIndicator startAnimating];
    return activityIndicator;
}

- (UILabel *) initTitle:(NSString *)title
{
    UILabel * loadingTitle=[[UILabel alloc] init];
    [loadingTitle setText:title];
    CGSize size=[loadingTitle sizeThatFits:self.bounds.size];
    loadingTitle.frame=CGRectMake(0, 0, size.width, size.height);
    loadingTitle.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

    [loadingTitle setBackgroundColor:[UIColor clearColor]];
    [loadingTitle setTextColor:[UIColor whiteColor]];
    [loadingTitle setFont:[UIFont systemFontOfSize:14]];
    loadingTitle.textAlignment=UITextAlignmentCenter;
    return loadingTitle ;
}

@end


@implementation LoadingView

@synthesize activityIndicator=_activityIndicatior;
@synthesize titleLabel=_loadingTitle;
@synthesize backgroundView;

- (NSString *)title
{
    if(_loadingTitle)
        return _loadingTitle.text;
    else
        return nil;
}

- (void)setTitle:(NSString *)title
{
    if(_loadingTitle)
    {
        _loadingTitle.text=title;
        CGSize size=[_loadingTitle sizeThatFits:self.bounds.size];
        _loadingTitle.frame=CGRectMake(0, 0, size.width, size.height);
        
        if(_loadingViewStyle!=LoadingViewStyleCircleProgress)
          _loadingTitle.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        else
          _loadingTitle.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height-_loadingTitle.bounds.size.height-3);
        
        if(_loadingViewStyle==LoadingViewStyleNoBackground)
           _activityIndicatior.center=CGPointMake(_loadingTitle.center.x-_loadingTitle.bounds.size.width/2-20, _loadingTitle.center.y);
        else if(_loadingViewStyle==LoadingViewStyleStandard)
          _loadingTitle.center=CGPointMake( _activityIndicatior.center.x,self.bounds.size.height-7-_loadingTitle.bounds.size.height/2);
    }
}

- (id)initWithFrame:(CGRect)frame LoadingViewStyle:(LoadingViewStyle)style
{
    if((self=[super initWithFrame:frame]))
    {
        self.backgroundColor=[UIColor clearColor];
        _loadingViewStyle=style;
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.backgroundView=bgView;
        [self addSubview:bgView];
        if(style!=LoadingViewStyleNoBackground && style!=LoadingViewStyleNoResult &&style!=LoadingViewStyleAcivityIndicator)
        {
            bgView.layer.opacity=0.8f;
            bgView.backgroundColor=[UIColor blackColor];
            bgView.layer.masksToBounds=YES;
            bgView.layer.cornerRadius=8;
        }
        else {
            bgView.backgroundColor=[UIColor clearColor];
        }
        [bgView release];
        
        CGRect frame;
        
        switch (style) {
            case LoadingViewStyleStandard:
                _activityIndicatior= [[self initIndicatorWithStyle:UIActivityIndicatorViewStyleWhiteLarge] retain];
                frame=_activityIndicatior.frame;
                frame.origin.x=(self.bounds.size.width-_activityIndicatior.bounds.size.width)/2;
                frame.origin.y=(self.bounds.size.height-_activityIndicatior.bounds.size.height)/2;
                _activityIndicatior.frame=frame;
                [self addSubview:_activityIndicatior];  
                
                _loadingTitle=[[self initTitle:@""] retain];
                _loadingTitle.center=CGPointMake( _activityIndicatior.center.x,self.bounds.size.height-7-_loadingTitle.bounds.size.height/2);
                [self addSubview:_loadingTitle];
                break;
            case LoadingViewStyleTilte:
                _loadingTitle=[[self initTitle:@""] retain];
                [self addSubview:_loadingTitle];
                break;
            case LoadingViewStyleAcivityIndicator:
                _activityIndicatior= [[self initIndicatorWithStyle:UIActivityIndicatorViewStyleWhiteLarge] retain];
                _activityIndicatior.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
                [self addSubview:_activityIndicatior];  
                break;       
            case LoadingViewStyleNoBackground:                 
                _loadingTitle=[[self initTitle:@""] retain];
                [self addSubview:_loadingTitle];
                
                _activityIndicatior= [[self initIndicatorWithStyle:UIActivityIndicatorViewStyleWhite] retain];
                _activityIndicatior.center=CGPointMake(_loadingTitle.center.x-_loadingTitle.bounds.size.width/2-20, _loadingTitle.center.y);
                [self addSubview:_activityIndicatior]; 
                break;
            case LoadingViewStyleNoResult:
                _loadingTitle=[[self initTitle:@""] retain];
                [self addSubview:_loadingTitle];
                break;
               default:
                break;
        }
    }
    return self;
}



- (void)dealloc
{
    [_activityIndicatior release];
    [_loadingTitle release];
    self.backgroundView=nil;
    [super dealloc];
}


- (void)showInView:(UIView *)view
{
    self.center=CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
    [view addSubview:self];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

@end
