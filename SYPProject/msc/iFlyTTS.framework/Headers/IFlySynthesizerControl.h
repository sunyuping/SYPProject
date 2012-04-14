//
//  IFlySynthesizerControl.h
//
//  Description: 语言合成控件
//
//  Created by 陈阳 on 11-2-23.
//  Copyright 2011 iFLYTEK. All rights reserved.
//
//	Important History:
//	index	version		date		author		notes
//	0		1.0.0		2011/2/23	yangchen	创建文件

#import <UIKit/UIKit.h>

#define SpeechError int

@class IFlySynthesizerControl;
@class IFlySynthesizerControlImp;

@protocol IFlySynthesizerControlDelegate

/*
	 @function	onSynthesizerEnd
	 @abstract	合成结束回调
	 @discussion	
	 @param	
*/
- (void)onSynthesizerEnd:(IFlySynthesizerControl *)iFlySynthesizerControl theError:(SpeechError) error;

@end

@interface IFlySynthesizerControl : UIView 
{
	// 实现部分
	IFlySynthesizerControlImp			*_iFlySynthesizerControlImp;
	
	// 接口
	id<IFlySynthesizerControlDelegate>	_delegate;
}

@property(assign)id<IFlySynthesizerControlDelegate> delegate;

/*
	@function	initWithFrame
	@abstract	初始化
	@discussion	
	@param		initParam:appID－使用令牌，需要到科大讯飞云网站上申请
*/
- (id)initWithFrame:(CGRect)frame theInitParam:(NSString *)initParam;

/*
	@function	setText
	@abstract	设置合成文本
	@discussion	
	@param		text -	待合成的文本 params － 本次合成的参数，无特殊需要为nil
*/
- (void)setText:(NSString *)text theParams:(NSString *)params;

/*
	 @function	setSampleRate
	 @abstract	设置合成音频采样率
	 @discussion	
	 @param		仅支持8k、16k，设置错误或不设置会默认用16k	
*/
- (void)setSampleRate:(int)rate;

/*
	 @function	setShowUI
	 @abstract	设置是否显示合成界面
	 @discussion	
	 @param		param - YES 显示 - NO 不显示 默认显示
*/
- (void)setShowUI:(BOOL)param; 

/*
	 @function	setBackgroundSound
	 @abstract	设置背景音
	 @discussion	
	 @param		param - 默认为null，表示无背景音乐
*/
- (void)setBackgroundSound:(NSString *)param; 

/*
	 @function	setVoiceName
	 @abstract	设置发音人
	 @discussion	
	 @param		name - 可设置为:"xiaoyan","xiaoyu",默认为"xiaoyan"
*/
- (void)setVoiceName:(NSString *)name;

/*
	 @function	setSpeed
	 @abstract	设置语速
	 @discussion	
	 @param		param 范围:0-100,默认50
*/
- (void)setSpeed:(unsigned int)speed;

/*
	 @function	setVolume
	 @abstract	设置音量
	 @discussion	
	 @param		param 范围:0-100,默认50
*/
- (void)setVolume:(unsigned int)volume; 

/*
	 @function	start
	 @abstract	开始合成
	 @discussion	
*/
- (BOOL)start;

/*
	@function	cancel
	@abstract	取消合成
	@discussion	
	@param	
*/
- (void)cancel;


/*
	 @function	pause
	 @abstract	暂停播放
	 @discussion	
	 @param	
*/
- (void)pause;

/*
	 @function	resume
	 @abstract	恢复播放
	 @discussion	
	 @param	
*/
- (void)resume;

/*
	 @function	getUpflow
	 @abstract	查询流量
	 @discussion	
	 @param		返回字节数
*/
- (int)getUpflow;

/*
	 @function	getUpflow
	 @abstract	查询流量
	 @discussion	
	 @param		返回字节数
*/
- (int)getDownflow;

/*
	 @function	getErrorDescription
	 @abstract	根据错误码获取错误描述
	 @discussion	
	 @param		返回错误描述
*/
- (NSString *)getErrorDescription:(SpeechError)errorCode;

@end
