//
//  MP3AudioDecoder.h
//  service
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "AudioDecoder.h"

@class MP3AudioDecoderInternal;

@interface MP3AudioDecoder : AudioDecoder
{
    MP3AudioDecoderInternal *_impl;
}

- (id)initWithSampleRate:(NSInteger)sampleRate;
@end
