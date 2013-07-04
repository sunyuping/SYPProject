/*!
 @header  RemoteIORecorder.h 
 //
 //  Created by sunyuping on 13-2-20.
 //  Copyright (c) 2013年 sunyuping. All rights reserved.
 //
*/

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AudioRecorder.h"

@interface RemoteIORecorder : AudioRecorder
{
    AudioBufferList             *_audioBuffer;
	AudioUnit					_audioUnit;
	double						_currSeconds;
	UInt64						_startHostTime;
    AudioStreamBasicDescription _audioFormat;
    NSOutputStream              *_fileStream;
}


@end

