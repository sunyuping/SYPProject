//
//  AudioManager.h
//  AudioManager
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioRecorder.h"
#import "AudioPlayer.h"

@protocol AudioManagerDelegate;
@interface AudioManager : NSObject<AudioPlayerDelegate>
{
    //系统声音资源字典
    // key:NSString,声音文件路径
    // value:NSNumber,系统分配的id
    NSMutableDictionary         *_systemSoundFileDictionary;

    //系统声音资源字典
    // key:NSString,声音文件路径
    // value:NSNumber,系统分配的id    
    NSMutableDictionary         *_systemSoundTagDictionary;
    
    //播放队列
//    NSMutableArray              *_audioPlayList;

    AudioRecorder               *_audioRecorder;    
    AudioPlayer                 *_audioPlayer;
    
    NSMutableArray              *_delegates;
    
    NSInteger                   _recordState;
    
    NSLock                      *_audioLock;
    
    BOOL                        _applicationActive;
    BOOL                        _interrupteOthers;  //是否中断其他音频
    
}

@property(nonatomic, assign)BOOL            proximityMonitoringEnabled;
@property(nonatomic, assign)BOOL            replayWhenProximityChanged;
@property(nonatomic, assign)BOOL            stopPlayWhenRecording;
@property(nonatomic, readonly)BOOL          playing;
@property(nonatomic, readonly)BOOL          recording;
@property(nonatomic, assign)BOOL            enableSystemSound;
@property(nonatomic, assign)BOOL            enableShake;
@property(nonatomic, retain)AudioPlayer     *audioPlayer;
@property(nonatomic, retain)AudioRecorder   *audioRecorder;


+ (AudioPlayer *)defaultAudioPlayer;
+ (AudioRecorder *)defaultAudioRecorder;

+ (AudioManager *)sharedInstance;

#pragma mark-   音频播放
- (void)stopPlay;

- (BOOL)playWithAudioFile:(NSString *)audioFilePath userInfo:(id)userInfo;


/*!
 @method
 @abstract 恢复系统音乐的播放
 @discussion 
 @result  
 */
- (void)resumeSystemMusic;

/*!
 @method
 @abstract 将音频文件从播放列表中移出
 @discussion 
 @param filePath 音频文件的绝对路径
 @result  
 */
//- (void)removeFromPlayListByFilePath:(NSString *)filePath;


#pragma mark-   录音
- (void)startRecord:(NSString*)outAudioFilePath;
- (void)stopRecord;

#pragma mark-   power
- (float)averagePower;
- (float)peakPower;

#pragma mark-   系统音
- (void)playSystemSoundWithSoundId:(UInt32)soundId;
- (void)playSystemSoundWithSoundId:(UInt32)soundId  mixShake:(BOOL)mixShake;
- (void)playSystemSoundWithTag:(UInt32)tag;
- (void)playSystemSoundWithTag:(UInt32)tag mixShake:(BOOL)mixShake;
- (void)playSystemSoundWithFile:(NSString *)soundFilePath;
- (UInt32)createSystemSoundWithTag:(NSInteger)tag  soundFile:(NSString *)soundFilePath;
- (UInt32)createSystemSoundWithFile:(NSString *)soundFilePath;

#pragma mark-   代理协议
- (void)addDelegate:(id<AudioManagerDelegate>)delegate;
- (void)removeDelegate:(id<AudioManagerDelegate>)delegate;;
- (void)removeAllDelegates;
@end

@protocol AudioManagerDelegate <NSObject>

@optional
//开始播放
- (void)audioManager:(AudioManager *)manager audioStartPlayWithInfo:(NSDictionary *)audioInfo;

//播放出错
- (void)audioManager:(AudioManager *)manager playAudioFailedWithInfo:(NSDictionary *)audioInfo;


//播放音频完成, stopPlay操作也会发送该通知  
- (void)audioManager:(AudioManager *)manager playAudioFinishedWithInfo:(NSDictionary *)audioInfo;

//重新播放音频
- (void)audioManager:(AudioManager *)manager replayAudioWithInfo:(NSDictionary *)audioInfo;

//录音操作出错
- (void)audioManager:(AudioManager *)manager recordAudioFailedWithError:(NSError *)error;

//中断
- (void)audioManagerBeginInterruption:(AudioManager *)manager;
- (void)audioManagerEndInterruption:(AudioManager *)manager;

@end







