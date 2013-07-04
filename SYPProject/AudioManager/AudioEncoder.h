//
//  AudioEncoder.h
//  AudioManager
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioCoder.h"

@interface AudioEncoder : AudioCoder


/*!
 @property
 @abstract  比特率，或者采样率，越高音质越好，相应的文件也会越大
            常用数据大小:8,000, 16000, 96000....
 */
@property(nonatomic, assign)UInt32 rate;

/*!
 @property
 @abstract  音频通道数量, 至少为1
 */
@property(nonatomic, assign)UInt32 channels;


- (void)encodeWithData:(short *)pcmData 
            dataLength:(UInt32)dataLen 
           encodedData:(char **)encodedData
     encodedDataLength:(UInt32 **)encodedDataLen;

@end
