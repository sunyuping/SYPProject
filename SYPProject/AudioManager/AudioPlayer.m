//
//  AudioPlayer.m
//  AudioManager
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioPlayer+Protected.h"
#import "AudioDecoder.h"
#import <AVFoundation/AVAudioPlayer.h>


@interface AudioPlayerInternal : NSObject

@property(nonatomic, retain) NSMutableArray *decoders;
@property(nonatomic, retain) AudioDecoder *currentDecoder;
@property(nonatomic, retain) AVAudioPlayer *systemPlayer;

@end

@implementation AudioPlayerInternal

@synthesize decoders, currentDecoder, systemPlayer;

- (void)dealloc {
    self.decoders = nil;
    self.currentDecoder = nil;
    self.systemPlayer = nil;
    [super dealloc];
}

@end


@interface AudioPlayer (Private)

- (BOOL)playWithSystemPlayer:(NSURL *)audioUrl error:(NSError **)outError;

- (BOOL)canProcessedBySystemPlayer:(NSString *)audioFilePath;

- (AudioDecoder *)decoderCanProcessAudioFile:(NSString *)audioFilePath;

@end

@implementation AudioPlayer
@synthesize playing;
@synthesize paused;
@synthesize duration;
@synthesize volume;
@synthesize url;
@synthesize delegate;


#pragma mark- 初始化
- (id)init {
    if (self = [super init]) {
        volume = 1.0f;
        playing = NO;
        paused = NO;
        duration = 0;

        _internal = [[AudioPlayerInternal alloc] init];
        _internal.decoders = [[[NSMutableArray alloc] init] autorelease];
    }

    return self;
}

- (void)dealloc {
    if (playing || paused)
        [self stop];

    [url release];
    [_internal release];

    [super dealloc];
}

#pragma mark- 属性设置&获取
- (void)setVolume:(float)newVolume {
    volume = newVolume;
    volume > 1.0f ? volume = 1.0f : (volume < 0.0f ? volume = 0.0f : volume);

    if (_internal.systemPlayer != nil)
        _internal.systemPlayer.volume = volume;
    else
        [self onVolumeChanged];
}


#pragma mark- 公共方法
- (BOOL)prepareWithContentsOfURL:(NSURL *)aUrl {
    if (playing || paused) {
        NSLog(@"未停止播放,却准备播放其他");
        [self stop];
    }

    [url release];
    url = nil;

    if (![aUrl checkResourceIsReachableAndReturnError:nil]
            && ![[NSFileManager defaultManager] fileExistsAtPath:[aUrl path]]) {
        return NO;
    }

    url = [aUrl retain];
    return YES;
}

- (void)registerAudioDecoder:(AudioDecoder *)decoder {
    NSLog(@"注册音频解码器,支持格式:%@", decoder.format);
    [_internal.decoders addObject:decoder];
}

- (BOOL)playWithError:(NSError **)outError {
    if (self.paused) {
        NSLog(@"恢复播放音频文件");
        if (_internal.systemPlayer != nil)
            [_internal.systemPlayer play];
        else
            [self onPlayWithError:outError];

        paused = NO;
        playing = YES;
        return TRUE;
    }

    //使用系统播放
    if ([self canProcessedBySystemPlayer:[url pathExtension]]) {
        NSLog(@"使用系统播放器播放音频文件：%@", url);
        playing = [self playWithSystemPlayer:url error:outError];
        return playing;
    }

    NSLog(@"使用自有解码器播放音频文件:%@", url);


    //查找对应解码器
    AudioDecoder *decoder = [self decoderCanProcessAudioFile:[url pathExtension]];
    if (decoder == nil) {
        if (outError != nil)
            *outError = [NSError errorWithDomain:@"AudioPlayer" code:1 message:NSLocalizedStringFromTable(@"播放音频文件失败,未查找到对应解码器", RS_CURRENT_LANGUAGE_TABLE, nil)];

        NSLog(@"播放音频文件失败,未查找到对应解码器:%@", url);
        return NO;
    }

    NSLog(@"查找到音频解码器:%@", decoder);

    //初始化解码器
    if (![decoder setup]) {
        if (outError != nil)
            *outError = [NSError errorWithDomain:@"AudioPlayer" code:2 message:NSLocalizedStringFromTable(@"音频解码器初始化失败", RS_CURRENT_LANGUAGE_TABLE, nil)];

        NSLog(@"音频解码器初始化失败");
        return NO;
    }

    _internal.currentDecoder = decoder;

    //开始播放
    if (![self onPlayWithError:outError]) {
        [decoder finish];
        _internal.currentDecoder = nil;
        return NO;
    }

    playing = YES;
    return YES;
}

- (void)pause {
    NSLog(@"暂停播放音频");

    if (_internal.systemPlayer != nil)
        [_internal.systemPlayer pause];
    else
        [self onPause];


    paused = TRUE;
    playing = FALSE;
}

- (void)stop {
    if (_internal.systemPlayer != nil) {
        NSLog(@"停止系统播放器");
        [_internal.systemPlayer stop];
        _internal.systemPlayer = nil;
    }
    else if (_internal.currentDecoder != nil) {
        NSLog(@"停止自解码播放器");
        [self onStop];
        [_internal.currentDecoder finish];
        _internal.currentDecoder = nil;
    }
    else {
        NSLog(@"没有在播放，调用了停止播放操作，是不是逻辑有问题?");
    }

    paused = NO;
    playing = NO;
    duration = 0.0f;
}

- (float)averagePower {
    [_internal.systemPlayer updateMeters];
    return [_internal.systemPlayer averagePowerForChannel:0];
}

- (float)peakPower {

    return[_internal.systemPlayer peakPowerForChannel:0];
}

#pragma mark- Private
- (BOOL)playWithSystemPlayer:(NSURL *)audioUrl error:(NSError **)outError {
    AVAudioPlayer *player = [[[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:outError] autorelease];
    player.meteringEnabled = YES;
    player.delegate = (id <AVAudioPlayerDelegate>) self;
    player.volume = self.volume;
    if ([player play]) {
        NSLog(@"使用系统播放器播放成功");
        duration = player.duration;
        _internal.systemPlayer = player;
        return YES;
    }

    NSLog(@"使用系统播放器播放失败");
    return NO;
}

- (BOOL)canProcessedBySystemPlayer:(NSString *)pathExtesion {
    if (pathExtesion == nil)
        return NO;

    pathExtesion = [pathExtesion lowercaseString];

    if ([pathExtesion compare:@"mp3"] == 0 ||
            [pathExtesion compare:@"caf"] == 0 ||
            [pathExtesion compare:@"wav"] == 0 ||
            [pathExtesion compare:@"aac"] == 0 ||
            [pathExtesion compare:@"midi"] == 0 ||
            [pathExtesion compare:@"ima4"] == 0) {
        NSLog(@"可以使用系统播放器播放文件:%@", pathExtesion);
        return YES;
    }

    NSLog(@"不可以使用系统播放器播放文件:%@", pathExtesion);
    return NO;
}

- (AudioDecoder *)decoderCanProcessAudioFile:(NSString *)pathExtesion {
    if (pathExtesion == nil)
        return nil;

    pathExtesion = [pathExtesion lowercaseString];
    for (AudioDecoder *decoder in _internal.decoders) {
        if ([pathExtesion compare:decoder.format] == 0)
            return decoder;
    }

    return nil;
}

#pragma mark- AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    NSLog(@"系统播放器播放完毕");

    [self stop];
    [self notifyPlayFinished];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"系统音频播放器播放失败:%@", error);

    [self stop];
    [self notifyPlayOccurError:error];
}

@end

@implementation AudioPlayer (Protected)

#pragma mark- 保护方法, 可重载

- (void)finishPlay {
    NSLog(@"播放完毕, 清理资源&通知");

    playing = NO;
    paused = NO;

    if (_internal.currentDecoder != nil) {
        [_internal.currentDecoder finish];
        _internal.currentDecoder = nil;
    }

    [self notifyPlayFinished];
}

- (BOOL)onPlayWithError:(NSError **)outError {
    return NO;
}

- (void)onPause {

}

- (void)onStop {

}

- (void)onVolumeChanged {

}

- (AudioDecoder *)currentDecoder {
    return _internal.currentDecoder;
}

@end

@implementation AudioPlayer (Notification)
#pragma mark- 通知

- (void)notifyPlayFinished {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:)])
        [self.delegate audioPlayerDidFinishPlaying:self];
}

- (void)notifyPlayOccurError:(NSError *)error {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(audioPlayerDidOccurError:error:)])
        [self.delegate audioPlayerDidOccurError:self error:error];
}

@end
