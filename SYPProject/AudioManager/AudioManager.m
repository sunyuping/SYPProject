//
//  AudioManager.m
//  AudioManager
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "AudioManager.h"
//#import "OggAudioDecoder.h"
//#import "OggAudioEncoder.h"
#import "AudioQueuePlayer.h"
#import "AudioQueueRecorder.h"
#import "MP3AudioEncoder.h"
#import <UIKit/UIApplication.h>
#import <UIKit/UIDevice.h>

#define RECORD_STATE_NONE        0
#define RECORD_STATE_INITING     1
#define RECORD_STATE_CANCEL      2
#define RECORD_STATE_RUNNING     3

#define RECORD_SAMPLE_RATE       44100

@interface AudioPlayObject : NSObject

@property(nonatomic, copy) NSString *audioFilePath;
@property(nonatomic, retain) NSObject *userInfo;

@end

@implementation AudioPlayObject
@synthesize audioFilePath;
@synthesize userInfo;

- (void)dealloc {
    self.audioFilePath = nil;
    self.userInfo = nil;
    [super dealloc];
}

@end

@interface AudioManager (SystemMusic)

- (void)sysMusicPlay;

@end

@interface AudioManager (Callback)
- (void)applicationDidBecomeActive:(NSNotification *)notification;

- (void)applicationWillResignActive:(NSNotification *)notification;

- (void)proximityStateChanged:(NSNotification *)notification;
@end

@interface AudioManager (AudioSession)

- (void)initAudioSession;

- (void)activeAudioSession;

- (void)activeAudioSessionByPlay;

@end

@interface AudioManager (Notify)
- (void)notifyAudioStartPlay:(AudioPlayObject *)object;

- (void)notifyAudioPlayFailed:(AudioPlayObject *)object error:(NSError *)error;

- (void)notifyAudioPlayFinished:(AudioPlayObject *)object;

- (void)notifyAudioReplay:(AudioPlayObject *)object;

- (void)notifyAudioRecordFailed:(NSError *)error;

- (void)notifyBeginInterruption;

- (void)notifyEndInterruption;
@end

@implementation AudioManager {
    AudioPlayObject *_playObject;
}
@synthesize proximityMonitoringEnabled;
@synthesize replayWhenProximityChanged;
@synthesize stopPlayWhenRecording;
@synthesize enableSystemSound;
@synthesize enableShake;
@synthesize audioRecorder = _audioRecorder;


#pragma mark- Init & Dealloc

static AudioManager *gInstance = nil;

//为了处理iphone 4s中的bug,引入该变量
//BUG 描述:
//      当device处于ProximityState时, 进行锁屏, 再次返回应用后,ProximityState仍然为YES
//      引起造成播放模式以及输出设备设置错误
//解决: 引入该变量, 初始化为NO, 在ProximityChange事件中修改该属性
//      返回应用时,将该属性修改为NO
static BOOL deviceProximityState = NO;

+ (AudioManager *)sharedInstance {
    if (gInstance == nil) {
        gInstance = [[AudioManager alloc] init];
    }

    return gInstance;
}

- (id)init {
    if (self = [super init]) {
        _systemSoundFileDictionary = [[NSMutableDictionary alloc] init];
        _systemSoundTagDictionary = [[NSMutableDictionary alloc] init];
        _delegates = [[NSMutableArray alloc] init];
        _recordState = RECORD_STATE_NONE;
        _audioLock = [[NSLock alloc] init];
        _applicationActive = NO;
        _interrupteOthers = NO;

        self.enableSystemSound = YES;
        self.enableShake = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(applicationWillResignActive:)
//                                                     name:UIApplicationWillResignActiveNotification
//                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(proximityStateChanged:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];

    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //删除系统音乐
    NSArray *soundIdArray = [_systemSoundFileDictionary allValues];
    for (NSNumber *soundId in soundIdArray)
        AudioServicesDisposeSystemSoundID([soundId unsignedIntValue]);
    [_systemSoundFileDictionary release];
    [_systemSoundTagDictionary release];

    //清除播放器&录音机
    if (self.audioPlayer.playing || self.audioPlayer.paused)
        [self.audioPlayer stop];

    if (self.audioRecorder.recording)
        [self.audioRecorder stop];

    self.audioPlayer = nil;
    self.audioRecorder = nil;

    [_playObject release];

    [self removeAllDelegates];
    [_delegates release];

    [_audioLock release];

    [super dealloc];
}

#pragma mark- 属性
- (void)setAudioPlayer:(AudioPlayer *)anAudioPlayer {
    [_audioPlayer release];
    _audioPlayer = [anAudioPlayer retain];
    _audioPlayer.delegate = self;
}

- (BOOL)playing {
    return _audioPlayer.playing || _audioPlayer.paused;
}

- (BOOL)recording {
    return _recordState == RECORD_STATE_INITING || _recordState == RECORD_STATE_RUNNING;
}

#pragma mark- help

- (BOOL)hasHeadset {
    CFStringRef route = nil;
    UInt32 propertySize = sizeof(CFStringRef);
    OSStatus err = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);
    if (kAudioSessionNoError == err &&
            route != nil &&
            (CFStringGetLength(route) > 0)) {
        NSString *routeStr = (NSString *) route;
        NSRange headphoneRange = [routeStr rangeOfString :@"Headphone"];
        NSRange headsetRange = [routeStr rangeOfString :@"Headset"];
        CFRelease(route);
        if (headphoneRange.location != NSNotFound)
            return YES;
        else if (headsetRange.location != NSNotFound)
            return YES;
    }

    return NO;
}

- (void)prepareDeviceForPlay {
    if (![self hasHeadset])
        [UIDevice currentDevice].proximityMonitoringEnabled = self.proximityMonitoringEnabled;
    else
        [UIDevice currentDevice].proximityMonitoringEnabled = NO;

    UInt32 audioRoute = 0;
    if (deviceProximityState && [UIDevice currentDevice].proximityMonitoringEnabled) {
        audioRoute = kAudioSessionOverrideAudioRoute_None;
        UInt32 category = kAudioSessionCategory_PlayAndRecord;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    }
    else {
        audioRoute = [self hasHeadset] ? kAudioSessionOverrideAudioRoute_None : kAudioSessionOverrideAudioRoute_Speaker;
        UInt32 category = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);
    }

    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRoute), &audioRoute);
}

- (void)resetDevice {
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    UInt32 category = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);

    if (_interrupteOthers) {
        _interrupteOthers = NO;
        [self sysMusicPlay];
    }
}


#pragma mark- 录音机&播放器 构造
+ (AudioPlayer *)defaultAudioPlayer {
    AudioPlayer *defaultPlayer = [[[AudioPlayer alloc] init] autorelease];

    //注册解码器
//    OggAudioDecoder *decoder = [[[OggAudioDecoder alloc] init] autorelease];
//    [defaultPlayer registerAudioDecoder:decoder];

    return defaultPlayer;
}

+ (AudioRecorder *)defaultAudioRecorder {
    AudioQueueRecorder *defaultRecorder = [[[AudioQueueRecorder alloc] init] autorelease];

    //注册编码器
//    OggAudioEncoder *oggEncoder = [[[OggAudioEncoder alloc] init] autorelease];
//    [defaultRecorder registeEncoder:oggEncoder];

    MP3AudioEncoder *mp3Encoder = [[[MP3AudioEncoder alloc] initWithSampleRate:RECORD_SAMPLE_RATE] autorelease];
    [defaultRecorder registeEncoder:mp3Encoder];

    return defaultRecorder;
}

- (AudioRecorder *)audioRecorder {
    if (_audioRecorder == nil) {
        _audioRecorder = [[AudioManager defaultAudioRecorder] retain];
    }
    return _audioRecorder;
}

- (AudioPlayer *)audioPlayer {
    if (_audioPlayer == nil) {
        _audioPlayer = [[AudioManager defaultAudioPlayer] retain];
        _audioPlayer.delegate = self;
    }
    return _audioPlayer;
}

#pragma mark- 播放相关
- (void)stopPlay {
    if (self.audioPlayer.playing) {
        NSLog(@"停止播放音频");
        [self.audioPlayer stop];
        [self notifyAudioPlayFinished:_playObject];

        if (_playObject != nil) {
            [_playObject release];
            _playObject = nil;
        }
    }

    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
}


- (BOOL)playWithAudioFile:(NSString *)audioFilePath userInfo:(id)userInfo {
    if (self.recording)
        return NO;

    //正在播放, 直接返回
    if (self.audioPlayer.playing)
        return NO;

    [_playObject release];
    _playObject = [[AudioPlayObject alloc] init];
    _playObject.audioFilePath = audioFilePath;
    _playObject.userInfo = userInfo;


    //配置设备
    [self prepareDeviceForPlay];

    UInt32 otherPlaying = 0;
    UInt32 size = sizeof(otherPlaying);
    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &size, &otherPlaying);
    if (otherPlaying)
        _interrupteOthers = YES;

    NSError *error = nil;
    [self.audioPlayer prepareWithContentsOfURL:[NSURL fileURLWithPath:_playObject.audioFilePath]];
    if ([self.audioPlayer playWithError:&error]) {
        NSLog(@"开始播放");
        [self notifyAudioStartPlay:_playObject];
        return YES;
    }

    //播放失败,重置device
    [self resetDevice];
    return NO;
}


- (void)resumeSystemMusic {
    if (_interrupteOthers) {
        _interrupteOthers = NO;
        [self sysMusicPlay];
    }
}

- (void)startRecordThreadFinished:(NSError *)error {
    //取消了录音
    if (_recordState == RECORD_STATE_CANCEL) {
        _recordState = RECORD_STATE_NONE;
        [self.audioRecorder stop];

        if (_interrupteOthers)
            [self resetDevice];
        else
            [NSThread detachNewThreadSelector:@selector(activeAudioSessionByPlay) toTarget:self withObject:nil];
    }
            //录音操作失败
    else if (error != nil) {
        _recordState = RECORD_STATE_NONE;
        [self notifyAudioRecordFailed:error];

        if (_interrupteOthers)
            [self resetDevice];
    }
            //录音正常运行
    else {
        _recordState = RECORD_STATE_RUNNING;
    }
}

- (void)startRecordThread:(NSString *)outAudioFilePath {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSError *error = nil;
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:RECORD_SAMPLE_RATE]
                                                              forKey:@"rate"];
    [self.audioRecorder recordWithURL:[NSURL fileURLWithPath:outAudioFilePath]
                             settings:recordSetting
                                error:&error];

    [self performSelectorOnMainThread:@selector(startRecordThreadFinished:) withObject:error waitUntilDone:NO];
    [pool release];
}

- (void)startRecord:(NSString *)outAudioFilePath {
    [self stopPlay];


    UInt32 category = kAudioSessionCategory_PlayAndRecord;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);

    if (_recordState == RECORD_STATE_RUNNING) {
        NSLog(@"录音机正在运行,却执行了开始录音操作，逻辑有异常");
    }
    else if (_recordState == RECORD_STATE_CANCEL) {
        NSLog(@"录音机正在初始化, 而且已经执行了取消录音操作，恢复初始化");
        _recordState = RECORD_STATE_INITING;
    }
    else {
        NSLog(@"初始化录音");
        _recordState = RECORD_STATE_INITING;

        UInt32 otherPlaying = 0;
        UInt32 size = sizeof(otherPlaying);
        AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &size, &otherPlaying);

        if (otherPlaying) {
            _interrupteOthers = YES;
            [self performSelector:@selector(startRecordThread:) withObject:outAudioFilePath];
        }
        else {
            dispatch_async(dispatch_get_global_queue(0, 0), ^() {
                [self startRecordThread:outAudioFilePath];
            });
//            [NSThread detachNewThreadSelector:@selector(startRecordThread:) toTarget:self withObject:outAudioFilePath];
        }
    }

}

- (void)stopRecord {
    if (_recordState == RECORD_STATE_INITING) {
        NSLog(@"录音机正在初始化, 将状态改为‘取消',等待初始化完毕后停止");
        _recordState = RECORD_STATE_CANCEL;
    }
    else if (_recordState == RECORD_STATE_RUNNING) {
        NSLog(@"录音机正在运行, 直接停止录音，并且恢复播放列表");
        _recordState = RECORD_STATE_NONE;
        dispatch_sync(dispatch_get_global_queue(0, 0), ^() {
            [self.audioRecorder stop];
        });


        if (_interrupteOthers)
            [self resetDevice];
        else
            dispatch_async(dispatch_get_global_queue(0, 0), ^() {
                [self activeAudioSessionByPlay];
            });
//            [NSThread detachNewThreadSelector:@selector(activeAudioSessionByPlay) toTarget:self withObject:nil];
    }
}

#pragma mark-   power
- (float)averagePower {
    if (_recordState == RECORD_STATE_RUNNING) {
        return [_audioRecorder averagePower];
    }
    else if (self.audioPlayer.playing) {
        return [self.audioPlayer averagePower];
    }
    else
        return 0.0f;

}

- (float)peakPower {
    if (_recordState == RECORD_STATE_RUNNING) {
        return [_audioRecorder peakPower];
    }
    else if (self.audioPlayer.playing) {
        return [self.audioPlayer peakPower];
    }
    else {
        return 0.0f;
    }
}

#pragma mark- 系统声音
- (void)playSystemSoundWithSoundId:(UInt32)soundId {
    if (self.enableSystemSound && _applicationActive)
        AudioServicesPlaySystemSound(soundId);
}

- (void)playSystemSoundWithSoundId:(UInt32)soundId  mixShake:(BOOL)mixShake {
    [self playSystemSoundWithSoundId:soundId];

    if (mixShake && self.enableSystemSound && _applicationActive)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


- (void)playSystemSoundWithTag:(UInt32)tag {
    if ([_systemSoundTagDictionary objectForKey:[NSNumber numberWithInt:tag]] == nil) {
        NSLog(@"播放不存在的标签声音, 标签值：%ld", tag);
        return;
    }

    UInt32 soundId = [[_systemSoundTagDictionary objectForKey:[NSNumber numberWithInt:tag]] unsignedIntValue];
    [self playSystemSoundWithSoundId:soundId];
}

- (void)playSystemSoundWithTag:(UInt32)tag mixShake:(BOOL)mixShake {
    [self playSystemSoundWithTag:tag];

    if (mixShake && self.enableShake && _applicationActive)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)playSystemSoundWithFile:(NSString *)soundFilePath {
    NSLog(@"播放系统音,文件路径:%@", soundFilePath);

    UInt32 soundId = [self createSystemSoundWithFile:soundFilePath];
    [self playSystemSoundWithSoundId:soundId];
}

- (UInt32)createSystemSoundWithTag:(NSInteger)tag  soundFile:(NSString *)soundFilePath {
    UInt32 soundId = [self createSystemSoundWithFile:soundFilePath];
    [_systemSoundTagDictionary setObject:[NSNumber numberWithInt:soundId] forKey:[NSNumber numberWithInt:tag]];
    return soundId;
}

- (UInt32)createSystemSoundWithFile:(NSString *)soundFilePath {
    if ([_systemSoundFileDictionary objectForKey:soundFilePath] != nil)
        return [[_systemSoundFileDictionary objectForKey:soundFilePath] unsignedIntValue];

    NSLog(@"创建系统音，文件路径:%@", soundFilePath);

    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    SystemSoundID soundId = 0;
    OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef) url, &soundId);
    if (err != noErr) {
        NSLog(@"创建系统音失败, 错误码:%ld", err);
        return 0;
    }

    //添加至缓存
    [_systemSoundFileDictionary setObject:[NSNumber numberWithUnsignedInt:soundId]
                                   forKey:soundFilePath];

    NSLog(@"创建系统音成功, id:%ld", soundId);
    return soundId;
}

#pragma mark-   代理协议
- (void)addDelegate:(id <AudioManagerDelegate>)delegate {
    if ([_delegates containsObject:delegate])
        return;

    [_delegates addObject:delegate];
    [delegate release];
}

- (void)removeDelegate:(id <AudioManagerDelegate>)delegate; {
    if (![_delegates containsObject:delegate])
        return;

    if ([delegate retainCount] > 0)
        [delegate retain];

    [_delegates removeObject:delegate];
}

- (void)removeAllDelegates {
    for (id <AudioManagerDelegate> delegateObj in _delegates) {
        if ([delegateObj retainCount] > 0)
            [delegateObj retain];
    }

    [_delegates removeAllObjects];
}

#pragma mark- AudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AudioPlayer *)player {
    NSLog(@"音频播放完毕, 播放下一个");
    [self notifyAudioPlayFinished:_playObject];

    if (_playObject != nil) {
        [_playObject release];
        _playObject = nil;
    }

    [self resetDevice];
}

- (void)audioPlayerDidOccurError:(AudioPlayer *)player error:(NSError *)error {
    [self notifyAudioPlayFailed:_playObject error:error];

    if (_playObject != nil) {
        [_playObject release];
        _playObject = nil;
    }

    [self resetDevice];
}

@end

@implementation AudioManager (SystemMusic)

- (void)sysMusicPlay {
    AudioSessionSetActiveWithFlags(FALSE, kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation);
}

@end


@implementation AudioManager (Callback)

#pragma mark- Callback
static void audioSessionInterruptionCallback(void *inClientData, UInt32 inInterruptionState) {
    NSLog(@"AudioSession被打断:%ld", inInterruptionState);
    AudioManager *manager = (AudioManager *) inClientData;
    if (inInterruptionState == kAudioSessionBeginInterruption)
        [manager notifyBeginInterruption];
    else if (inInterruptionState == kAudioSessionEndInterruption)
        [manager notifyEndInterruption];
}

static void audioRouteChangeListenerCallback(void *inUserData,
        AudioSessionPropertyID inPropertyID,
        UInt32 inPropertyValueSize,
        const void *inPropertyValue) {

    if (inPropertyID != kAudioSessionProperty_AudioRouteChange)
        return;


    AudioManager *audioMgr = [AudioManager sharedInstance];

    CFDictionaryRef routeChangeDictionary = (CFDictionaryRef) inPropertyValue;
    CFNumberRef routeChangeReasonRef = (CFNumberRef)
            CFDictionaryGetValue(routeChangeDictionary, CFSTR (kAudioSession_AudioRouteChangeKey_Reason));
    SInt32 routeChangeReason;
    CFNumberGetValue(routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);


    if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
        NSLog(@"拔出耳机");

        if (![UIDevice currentDevice].proximityState) {
            UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
            AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRoute), &audioRoute);
        }

        if (audioMgr.playing) {
            [UIDevice currentDevice].proximityMonitoringEnabled = YES;
        }
    }
    else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
        NSLog(@"插入耳机");
        [UIDevice currentDevice].proximityMonitoringEnabled = NO;
        UInt32 audioRoute = kAudioSessionOverrideAudioRoute_None;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRoute), &audioRoute);
    }
    else if (routeChangeReason == kAudioSessionRouteChangeReason_NoSuitableRouteForCategory) {
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {

    _applicationActive = YES;
    [self initAudioSession];

    UInt32 otherPlaying = 0;
    UInt32 size = sizeof(otherPlaying);
    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &size, &otherPlaying);
    if (!otherPlaying)
        [self activeAudioSession];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    _applicationActive = NO;

    [self stopPlay];
    [self stopRecord];

    deviceProximityState = NO;
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    UInt32 category = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(category), &category);

    if (_interrupteOthers) {
        _interrupteOthers = NO;
        AudioSessionSetActiveWithFlags(FALSE, kAudioSessionSetActiveFlag_NotifyOthersOnDeactivation);
    }
    else {
        AudioSessionSetActive(FALSE);
    }
}


- (void)proximityStateChanged:(NSNotification *)notification {

    deviceProximityState = [UIDevice currentDevice].proximityState;
    [self prepareDeviceForPlay];

    if (_playObject == nil)
        return;

    if (self.audioPlayer.playing || self.audioPlayer.paused) {
        [self.audioPlayer stop];
        [self notifyAudioPlayFinished:_playObject];
    }

    NSError *error = nil;
    [self.audioPlayer prepareWithContentsOfURL:[NSURL fileURLWithPath:_playObject.audioFilePath]];
    if ([self.audioPlayer playWithError:&error]) {
        NSLog(@"开始播放");
        [self notifyAudioStartPlay:_playObject];
        return;
    }
}

@end

@implementation AudioManager (AudioSession)

static void AudioOutputCallback(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) {
    memset(inBuffer->mAudioData, 0, 160 * 2);
    inBuffer->mAudioDataByteSize = 160 * 2;
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

- (void)activeAudioSessionByPlay {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    if (self.recording) {
        [pool release];
        return;
    }

    BOOL enableProximity = self.proximityMonitoringEnabled;
    self.proximityMonitoringEnabled = NO;
    [self prepareDeviceForPlay];
    self.proximityMonitoringEnabled = enableProximity;


    AudioStreamBasicDescription _dataFormat;
    memset(&_dataFormat, 0, sizeof(_dataFormat));
    _dataFormat.mSampleRate = 8000;
    _dataFormat.mFormatID = kAudioFormatLinearPCM;
    _dataFormat.mFramesPerPacket = 1;
    _dataFormat.mChannelsPerFrame = 1;
    _dataFormat.mBytesPerFrame = 2;
    _dataFormat.mBytesPerPacket = 2;
    _dataFormat.mBitsPerChannel = 16;
    _dataFormat.mReserved = 0;
    _dataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;

    AudioQueueRef _queue = NULL;
    AudioQueueNewOutput(&_dataFormat, AudioOutputCallback, self,
            CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &_queue);


    AudioQueueBufferRef buffers[3];
    for (int i = 0; i < 3; i++)
        AudioQueueAllocateBuffer(_queue, 160 * 2, &buffers[i]);

    Float32 volume = 0.0f;
    AudioQueueSetProperty(_queue, kAudioQueueParam_Volume, &volume, sizeof(volume));


    for (int i = 0; i < 3; i++)
        AudioOutputCallback(NULL, _queue, buffers[i]);

    AudioQueueStart(_queue, NULL);
    AudioQueueStop(_queue, YES);

    for (int i = 0; i < 3; i++)
        AudioQueueFreeBuffer(_queue, buffers[i]);

    AudioQueueDispose(_queue, YES);

    [pool release];
}

- (void)initAudioSession {
    static BOOL sInited = NO;
    if (sInited)
        return;

    sInited = YES;
    AudioSessionInitialize(NULL, NULL, audioSessionInterruptionCallback, self);
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback, self);
}

- (void)activeAudioSession {
    static BOOL firstActive = YES;
    if (firstActive) {

        AudioSessionSetActive(TRUE);

        UInt32 allowMix = TRUE;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(allowMix), &allowMix);


        firstActive = NO;
        [self performSelector:@selector(activeAudioSessionByPlay) withObject:nil afterDelay:1.0f];
    }
    else {
        [self performSelector:@selector(activeAudioSessionByPlay) withObject:nil afterDelay:0.5f];
    }
}

@end

@implementation AudioManager (Notify)

#pragma mark- 通知
- (void)notifyAudioStartPlay:(AudioPlayObject *)object {
    for (id <AudioManagerDelegate> delegateObj in _delegates) {
        if ([delegateObj respondsToSelector:@selector(audioManager:audioStartPlayWithInfo:)]) {
            [delegateObj audioManager:self
               audioStartPlayWithInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                       object.audioFilePath, @"audioFilePath",
                       object.userInfo, @"userInfo",
                       nil]];
        }
    }
}

- (void)notifyAudioPlayFailed:(AudioPlayObject *)object error:(NSError *)error {
    for (id <AudioManagerDelegate> delegateObj in _delegates) {
        if ([delegateObj respondsToSelector:@selector(audioManager:playAudioFailedWithInfo:)]) {
            [delegateObj audioManager:self
              playAudioFailedWithInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                      object.audioFilePath, @"audioFilePath",
                      object.userInfo, @"userInfo",
                      error, @"error",
                      nil]];
        }
    }
}

- (void)notifyAudioPlayFinished:(AudioPlayObject *)object {
    for (id <AudioManagerDelegate> delegateObj in _delegates) {
        if ([delegateObj respondsToSelector:@selector(audioManager:playAudioFinishedWithInfo:)]) {
            [delegateObj audioManager:self
            playAudioFinishedWithInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    object.audioFilePath, @"audioFilePath",
                    object.userInfo, @"userInfo",
                    nil]];
        }
    }
}

- (void)notifyAudioReplay:(AudioPlayObject *)object {
    for (id <AudioManagerDelegate> delegateObj in _delegates) {
        if ([delegateObj respondsToSelector:@selector(audioManager:replayAudioWithInfo:)]) {
            [delegateObj audioManager:self
                  replayAudioWithInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          object.audioFilePath, @"audioFilePath",
                          object.userInfo, @"userInfo",
                          nil]];
        }
    }
}

- (void)notifyAudioRecordFailed:(NSError *)error {
    for (id <AudioManagerDelegate> delegateObj in _delegates) {
        if ([delegateObj respondsToSelector:@selector(audioManager:recordAudioFailedWithError:)])
            [delegateObj audioManager:self recordAudioFailedWithError:error];
    }
}

- (void)notifyBeginInterruption {
    for (id <AudioManagerDelegate> delegateObj in _delegates) {
        if ([delegateObj respondsToSelector:@selector(audioManagerBeginInterruption:)])
            [delegateObj audioManagerBeginInterruption:self];
    }
}

- (void)notifyEndInterruption {
    for (id <AudioManagerDelegate> delegateObj in _delegates) {
        if ([delegateObj respondsToSelector:@selector(audioManagerEndInterruption:)])
            [delegateObj audioManagerEndInterruption:self];
    }
}

@end
