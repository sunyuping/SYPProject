/*!
 @header  AudioQueuePlayer.m 
 //
 //  Created by sunyuping on 13-2-20.
 //  Copyright (c) 2013年 sunyuping. All rights reserved.
 //
*/

#import "AudioQueuePlayer.h"
#import <AudioToolbox/AudioQueue.h>
#import "AudioDecoder.h"
#import "AudioPlayer+Protected.h"


#define BUFFER_BYTE_SIZE 160*2


@interface AudioQueuePlayer(Private)

- (void)handleOutputCallback:(AudioQueueRef)inAQ buffer:(AudioQueueBufferRef) inBuffer;

@end

@implementation AudioQueuePlayer

static void AudioOutputCallback(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) 
{
    AudioQueuePlayer *player = (AudioQueuePlayer*)aqData;
    [player handleOutputCallback:inAQ buffer:inBuffer];
}

- (BOOL)setup
{
    memset(&_dataFormat, 0, sizeof(_dataFormat));
    _dataFormat.mSampleRate = 8000;
    _dataFormat.mFormatID = kAudioFormatLinearPCM;
    _dataFormat.mFramesPerPacket = 1;
    _dataFormat.mChannelsPerFrame = 1;
    _dataFormat.mBytesPerFrame = 2;
    _dataFormat.mBytesPerPacket = 2;
    _dataFormat.mBitsPerChannel = 16;
    _dataFormat.mReserved = 0;
    _dataFormat.mFormatFlags =  kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    
    OSStatus err = AudioQueueNewOutput(&_dataFormat, AudioOutputCallback, self, 
                                       CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &_queue);
    if(err != noErr)
    {
        NSLog(@"执行AudioQueueNewOutput失败, 错误码: %ld", err);
        return NO;   
    }
    
    for(int i = 0; i < NUM_BUFFERS; i++) 
    {
        err = AudioQueueAllocateBuffer(_queue, BUFFER_BYTE_SIZE, &_buffers[i]);
        if(err != noErr)
            NSLog(@"执行AudioQueueAllocateBuffer申请音频缓存失败,错误码: %ld", err);
    }
    
    //音量波动
    UInt32 enableMetering = YES;
    OSStatus status;
    status = AudioQueueSetProperty(_queue,
                                   kAudioQueueProperty_EnableLevelMetering,
                                   &enableMetering,
                                   sizeof(enableMetering));
    if (status)
        NSLog(@"设置获取音量波动失败，错误码:%ld",status);
    
    return YES;
}

- (void)cleanup
{
    if(_queue != NULL)
    {
        OSStatus err = noErr;
        
        for(int i = 0; i < NUM_BUFFERS; i++) 
            err = AudioQueueFreeBuffer(_queue, _buffers[i]);
        
        if( err != noErr)
            NSLog(@"释放AudioQueue缓存失败, 错误码:%ld", err);
        
        err = AudioQueueDispose(_queue, true);
        if( err != noErr)
            NSLog(@"释放AudioQueue失败, 错误码:%ld", err);
        
        _queue = NULL;
        
    }

    if(_fileStream){
        [_fileStream close];
        [_fileStream release];
        _fileStream = nil;
    }
    
}

- (void)startQueueThread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    OSStatus  errCode = AudioQueueStart(_queue, NULL);
    if (errCode != noErr)  
    {
        NSLog(@"Thread执行AudioQueueStart失败, 错误原因: %ld", errCode);
        NSError *error = [NSError  errorWithDomain:@"AudioPlayer" 
                                              code:errCode
                                           message:@"执行AudioQueueStart失败"];

        [self performSelectorOnMainThread:@selector(stop) withObject:nil waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(notifyPlayOccurError:) withObject:error waitUntilDone:NO];
    }
    [pool release];
}

- (BOOL)onPlayWithError:(NSError **)outError
{

    OSStatus err = noErr;
    
    //如果暂停了则恢复播放
    if(self.paused && _queue != NULL)
    {
        NSLog(@"恢复播放");
        
        err = AudioQueueStart(_queue, NULL);
        
        if(err != noErr)
        {
            NSLog(@"恢复播放AudioQueue失败，错误码:%ld",err);
            if(outError != nil)
                *outError = [NSError  errorWithDomain:@"AudioPlayer" code:err message:NSLocalizedStringFromTable(@"恢复播放AudioQueue失败",RS_CURRENT_LANGUAGE_TABLE,nil)];
        }
        
        return err == noErr;
    }
    
    
    //初始化
    if(![self setup])
    {
        NSLog(@"初始化音频设置失败");
        if(outError != nil)
            *outError = [NSError  errorWithDomain:@"AudioPlayer" code:11 message:NSLocalizedStringFromTable(@"初始化音频设置失败",RS_CURRENT_LANGUAGE_TABLE,nil)];
        
        return NO;   
    }
    

    //打开文件
    _fileStream = [NSInputStream inputStreamWithURL:self.url];
    if(_fileStream != nil)
    {
        [_fileStream retain];
        [_fileStream open];   
    }
    
    if(_fileStream == nil || _fileStream.streamError)
    {
        NSLog(@"打开音乐文件失败,文件路径:%@,错误:%@",self.url,_fileStream.streamError);
        [self cleanup];
        if(outError != nil)
        {
            *outError = [NSError  errorWithDomain:@"AudioPlayer" 
                                             code:12 
                                          message:_fileStream.streamError.localizedDescription];
        }
        return NO;
    }
    
    //填充buffer
    for(int i=0;i<NUM_BUFFERS;i++)
        [self handleOutputCallback:_queue buffer:_buffers[i]];   
    
    
    UInt32 otherPlaying = 0;
    UInt32 size = sizeof(otherPlaying);
    AudioSessionGetProperty(kAudioSessionProperty_OtherAudioIsPlaying, &size, &otherPlaying);
    
    
    //如果其他在播放音乐, 可以阻塞, 否则开启线程播放
    if(otherPlaying)
    {
        err = AudioQueueStart(_queue, NULL);
        if (err != noErr)  
        {
            NSLog(@"执行AudioQueueStart失败, 错误原因: %ld", err);
            [self cleanup];
            if(outError != nil)
            {
                *outError = [NSError  errorWithDomain:@"AudioPlayer" 
                                                 code:err
                                              message:NSLocalizedStringFromTable(@"执行AudioQueueStart失败",RS_CURRENT_LANGUAGE_TABLE,nil)];
            }
            return NO;
        } 
    }
    else 
    {
        [NSThread detachNewThreadSelector:@selector(startQueueThread) toTarget:self withObject:nil];
    }

    return YES;
}

- (void)onPause
{
    if(_queue == NULL)
        NSLog(@"还没有创建AudioQueue,却调用了暂停操作，逻辑有异常!");
    
    if(self.paused)
    {
        NSLog(@"当前Audio已经处于暂停状态,再次执行了暂停调用");
        return;
    }
        
    if(AudioQueuePause(_queue) != noErr)
        NSLog(@"暂停失败, AudioQueuePause错误");
}

- (void)onStop
{
    NSLog(@"停止播放");
    
    if(_queue == NULL)
    {
        NSLog(@"当前Audio未处于播放状态,再次执行了停止播放调用");
        return;
    }
    
    OSStatus err = AudioQueueStop(_queue, YES);
    if(err != noErr)
        NSLog(@"执行AudioQueueStop失败, 错误码:%ld",err);
    
    [self cleanup];
}

- (void)onVolumeChanged
{
    if(_queue != NULL)
    {
        NSLog(@"AudioQueue音量变化,%f",self.volume);
        
        float v = self.volume;
        OSStatus err = AudioQueueSetProperty(_queue, kAudioQueueParam_Volume, &v, sizeof(v));
        if(err != noErr)
            NSLog(@"设置AudioQueue音量失败, 音量值:%f,错误码:%ld",v,err);
    }
}

- (void)handleOutputCallback:(AudioQueueRef)inAQ buffer:(AudioQueueBufferRef) inBuffer 
{
    
    if(_queue == NULL)
        return;
    
    
    short   decodeDataBuffer[BUFFER_BYTE_SIZE/2];
    SInt32  decodeDataBufferLen = [[self currentDecoder] decodeWithData:NULL 
                                                dataLength:0 
                                               encodedData:decodeDataBuffer 
                                         encodedDataLength:BUFFER_BYTE_SIZE/2];
    if(decodeDataBufferLen <= 0)
    {
        uint8_t     dataBuffer[1024];
        int         dataBufferLen = [_fileStream read:dataBuffer maxLength:1024];
        
        decodeDataBufferLen = [[self currentDecoder] decodeWithData:dataBuffer 
                                            dataLength:dataBufferLen
                                           encodedData:decodeDataBuffer 
                                     encodedDataLength:BUFFER_BYTE_SIZE/2];
        
    }
    
    if(decodeDataBufferLen < 0)
    {
        AudioQueueStop(_queue, YES);
        [self cleanup];
        [self finishPlay];
        return;
    }
    
    memcpy(inBuffer->mAudioData, decodeDataBuffer, decodeDataBufferLen*sizeof(short));
    inBuffer->mAudioDataByteSize = decodeDataBufferLen*sizeof(short);
    AudioQueueEnqueueBuffer(_queue, inBuffer, 0, NULL);
}

- (float)averagePower
{
    AudioQueueLevelMeterState state[1];
    UInt32  statesize = sizeof(state);
    OSStatus status;
    status = AudioQueueGetProperty(_queue, kAudioQueueProperty_CurrentLevelMeter, &state, &statesize);
    if (status)
    {
        NSLog(@"Error retrieving meter data\n");
        return 0.0f;
    }
    return state[0].mAveragePower;
}

- (float)peakPower
{
    AudioQueueLevelMeterState state[1];
    UInt32  statesize = sizeof(state);
    OSStatus status;
    status = AudioQueueGetProperty(_queue, kAudioQueueProperty_CurrentLevelMeter, &state, &statesize);
    if (status)
    {
        NSLog(@"Error retrieving meter data\n");
        return 0.0f;
    }
    return state[0].mPeakPower;
}

- (void)dealloc {
    [_fileStream release];
    [super dealloc];
}


@end

