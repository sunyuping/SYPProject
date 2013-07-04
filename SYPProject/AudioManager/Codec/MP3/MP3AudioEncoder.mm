//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "MP3AudioEncoder.h"
#import "lame.h"

@implementation MP3AudioEncoder {
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

- (void)encodeWithData:(short *)pcmData
            dataLength:(UInt32)dataLen
           encodedData:(char **)encodedData
     encodedDataLength:(UInt32 **)encodedDataLen {

    static unsigned char buf[100000];

    short inData[dataLen];
    memcpy(inData, pcmData, dataLen * sizeof(short));

    int len = lame_encode_buffer(_lameGlobalFlags,
            inData,
            inData,
            dataLen,
            buf,
            sizeof(buf));

    if (len > 0) {
        char *outData = (char *) malloc((size_t) (len * sizeof(char)));
        memcpy(outData, buf, (size_t) len);
        *encodedData = outData;

        *encodedDataLen = (UInt32 *) malloc(sizeof(UInt32));
        **encodedDataLen = (UInt32) len;
    }
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