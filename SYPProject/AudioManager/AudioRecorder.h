//
//  AudioRecorder.h
//  AudioManager
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioEncoder.h"


/*!
 @class
 @abstract  录音机基类, 不能实例化, 接口设计参考了AVAudioRecorder
            去除了pause/resume功能
            允许注册编码器
            支持有限的录音参数,比系统的要少,部分参数固定死了
 */
@interface AudioRecorder : NSObject
{
    void    *_impl;
}

/*!
 @property
 @abstract  编码器集合
 */
@property(nonatomic, readonly)NSArray *encoders;


/*!
 @property
 @abstract  当前是否正在录音
 */
@property(readonly, getter=isRecording) BOOL recording; 


/*!
 @property
 @abstract  当前或者最近保存的录音文件路径
 */
@property(readonly) NSURL *url;

/*!
 @property
 @abstract  当前录音的时间长度，仅当正在录音时有效
 */
@property(readonly) NSTimeInterval currentTime;

/*!
 @property
 @abstract  录音设置
 */
@property(readonly) NSDictionary *settings;


/*!
 @method
 @abstract 注册编码器
 @discussion 在录音之前，确保对应格式的解码器已经被注册，否则不能正常录音
             可根据需要选择性的注册,没必要注册太多
 @param encoder  某种格式的解码器
 */
- (void)registeEncoder:(AudioEncoder *)encoder;


/*!
 @method
 @abstract 开始录音
 @discussion 录音的输出格式根据文件名的后缀而定，根据后缀查找相应的编码器，如果未找到相应的编码器，则操作失败
 @param url 音频文件保存路径, 绝对路径(包含后缀名)
 @param settings 录音参数设置，当前支持以下参数字段
                 duration   NSTimeInterval      录音时长，当录音时间达到该参数值后，自动停止录音,默认为0
                 rate       NSNumber            采样率, 默认为8000
                 channels   NSNumber            通道数目, 1或2, 默认为1
 @result  TRUE:开始录音  FALSE:操作失败
 */
- (BOOL)recordWithURL:(NSURL *)url settings:(NSDictionary *)settings error:(NSError **)outError;

/*!
 @method
 @abstract 停止录音，并且关闭录音文件
 @discussion 
 */
- (void)stop; 

/*!
 @method
 @abstract 停止录音，并且将录音文件删除
 @discussion 
 */
- (void)stopAndDelete; 

- (float)averagePower;
- (float)peakPower;
@end
