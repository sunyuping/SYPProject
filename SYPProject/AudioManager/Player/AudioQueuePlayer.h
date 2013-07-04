/*!
 @header  AudioQueuePlayer.h 
 //
 //  Created by sunyuping on 13-2-20.
 //  Copyright (c) 2013年 sunyuping. All rights reserved.
 //
*/

#import <Foundation/Foundation.h>
#import "AudioPlayer.h"
#include <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>

#define NUM_BUFFERS 3

@interface AudioQueuePlayer : AudioPlayer
{
    AudioStreamBasicDescription _dataFormat;
    AudioQueueRef               _queue;
    AudioQueueBufferRef         _buffers[NUM_BUFFERS];
    UInt32                      _bufferByteSize; 
    NSInputStream               *_fileStream;
}

@end

