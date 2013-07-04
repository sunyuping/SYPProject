/*!
 @header  AudioQueueRecorder.h 
 //
 //  Created by sunyuping on 13-2-20.
 //  Copyright (c) 2013年 sunyuping. All rights reserved.
 //
*/

#import <Foundation/Foundation.h>
#import "AudioRecorder.h"

@interface AudioQueueRecorder : AudioRecorder
{
    void *_state;
}

@end

