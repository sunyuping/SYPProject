//
//  AudioDecoder.h
//  AudioManager
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioCoder.h"

@interface AudioDecoder : AudioCoder

- (SInt32)decodeWithData:(UInt8 *)audioData 
            dataLength:(UInt32)audioDataLen 
           encodedData:(short *)decodedDataBuffer
     encodedDataLength:(UInt32)decodedDataBufferLen;

@end
