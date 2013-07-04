
//
//  AudioPlayer.h
//  AudioManager
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioDecoder;
@class AudioPlayerInternal;
@protocol AudioPlayerDelegate;

@interface AudioPlayer : NSObject
{
    AudioPlayerInternal    *_internal;
}

@property(nonatomic, readonly)BOOL      playing;
@property(nonatomic, readonly)BOOL      paused;
@property(nonatomic, readonly)NSURL     *url;
@property(nonatomic, assign)float       volume;
@property(nonatomic, readonly)NSTimeInterval duration;
@property(nonatomic, assign)id<AudioPlayerDelegate> delegate;


- (BOOL)prepareWithContentsOfURL:(NSURL *)url;
- (void)registerAudioDecoder:(AudioDecoder *)decoder;
- (BOOL)playWithError:(NSError**)outError;
- (void)pause;
- (void)stop;

- (float)averagePower;
- (float)peakPower;

@end


@protocol AudioPlayerDelegate <NSObject>

@optional
- (void)audioPlayerDidFinishPlaying:(AudioPlayer *)player;
- (void)audioPlayerDidOccurError:(AudioPlayer *)player error:(NSError *)error;

@end
