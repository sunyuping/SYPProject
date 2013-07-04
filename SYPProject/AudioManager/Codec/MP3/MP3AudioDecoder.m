//
//  MP3AudioDecoder.m
//  service
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "MP3AudioDecoder.h"
#import "lame.h"

@implementation MP3AudioDecoder {
    NSInteger _sampleRate;
    
    lame_global_flags *_lameGlobalFlags;
}

- (id)initWithSampleRate:(NSInteger)sampleRate {
    if (self = [super init]) {
        _sampleRate = sampleRate;
    }
    return self;
}

- (BOOL)setup {
    _lameGlobalFlags = lame_init();
    if (_lameGlobalFlags == NULL)
        return NO;
    
    lame_set_num_channels(_lameGlobalFlags, 1);
    lame_set_in_samplerate(_lameGlobalFlags, _sampleRate);
    lame_set_mode(_lameGlobalFlags, MONO);
    
    if (lame_init_params(_lameGlobalFlags) < 0) {
        [self finish];
        return NO;
    }
    
    return YES;
}

- (SInt32)decodeWithData:(UInt8 *)audioData
              dataLength:(UInt32)audioDataLen
             encodedData:(short *)decodedDataBuffer
       encodedDataLength:(UInt32)decodedDataBufferLen
{
//    lame_encode_buffer_interleaved(<#lame_global_flags *gfp#>, <#short *pcm#>, <#int num_samples#>, <#unsigned char *mp3buf#>, <#int mp3buf_size#>)
    
//    static unsigned char buf[100000];
//    
//    short inData[audioDataLen];
//    memcpy(inData, audioData, audioDataLen * sizeof(short));
//    
//    int len = lame_encode_buffer(_lameGlobalFlags,
//                                 inData,
//                                 inData,
//                                 dataLen,
//                                 buf,
//                                 sizeof(buf));

    NSLog(@"audioData is %s",audioData);
    NSLog(@"audioDataLen is %lu",audioDataLen);
//    NSLog(@"decodedDataBuffer is %d",decodedDataBuffer);
    NSLog(@"decodedDataBufferLen is %lu",decodedDataBufferLen);
    
    return -1;
}

- (void)finish {
    if (_lameGlobalFlags) {
        lame_close(_lameGlobalFlags);
        _lameGlobalFlags = NULL;
    }
}

- (NSString *)format {
    return @"mp3";
}
@end
