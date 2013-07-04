//
//  Header.h
//  AudioManager
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface AudioPlayer(Protected)

- (void)finishPlay;

- (BOOL)onPlayWithError:(NSError **)outError;
- (void)onPause;
- (void)onStop;
- (void)onVolumeChanged;

- (AudioDecoder *)currentDecoder;

@end

@interface AudioPlayer(Notification)

- (void)notifyPlayFinished;
- (void)notifyPlayOccurError:(NSError *)error;

@end

