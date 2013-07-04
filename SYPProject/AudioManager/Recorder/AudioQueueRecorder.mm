/*!
 @header  AudioQueueRecorder.m 
 //
 //  Created by sunyuping on 13-2-20.
 //  Copyright (c) 2013年 sunyuping. All rights reserved.
 //
 */

#import "AudioQueueRecorder.h"
#include <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>
#import "AudioRecorder+Protected.h"



#define NUM_BUFFERS 3
#define kAudioConverterPropertyMaximumOutputPacketSize          'xops'
#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface AudioQueueRecorder(Private)

- (void)handleInputBufferWithAudioQueue:(AudioQueueRef)aq
                                 buffer:(AudioQueueBufferRef)inBuffer
                              startTime:(AudioTimeStamp *)startTime
                             numPackets:(UInt32)inNumPackets
                             packetDesc:(AudioStreamPacketDescription *)inPacketDesc;

@end


typedef struct
{
    AudioStreamBasicDescription dataFormat;
    AudioQueueRef               queue;
    AudioQueueBufferRef         buffers[NUM_BUFFERS];
    UInt32                      bufferByteSize; 
    NSOutputStream              *fileStream;
} AQRecordState;


// Derive the Buffer Size. I punt with the max buffer size.
static void DeriveBufferSize (AudioQueueRef audioQueue, AudioStreamBasicDescription ASBDescription, Float64 seconds, UInt32 *outBufferSize)
{
    static const int maxBufferSize = 0x50000; // punting with 50k
    int maxPacketSize = ASBDescription.mBytesPerPacket;
    if (maxPacketSize == 0)
    {                           
        UInt32 maxVBRPacketSize = sizeof(maxPacketSize);
        AudioQueueGetProperty(audioQueue, kAudioConverterPropertyMaximumOutputPacketSize, &maxPacketSize, &maxVBRPacketSize);
    }
    
    Float64 numBytesForTime = ASBDescription.mSampleRate * maxPacketSize * seconds;
    *outBufferSize =  (UInt32)((numBytesForTime < maxBufferSize) ? numBytesForTime : maxBufferSize);
}


static void HandleInputBuffer (void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer, const AudioTimeStamp *inStartTime,
                               UInt32 inNumPackets, const AudioStreamPacketDescription *inPacketDesc)
{
    
    AudioQueueRecorder *recorder = (AudioQueueRecorder*)aqData;
    [recorder handleInputBufferWithAudioQueue:inAQ 
                                       buffer:inBuffer
                                    startTime:(AudioTimeStamp*)inStartTime 
                                   numPackets:inNumPackets 
                                   packetDesc:(AudioStreamPacketDescription*)inPacketDesc];    
}


@implementation AudioQueueRecorder

- (id)init
{
    if(self = [super init])
    {
        _state = new AQRecordState;
        
        //初始化
        ((AQRecordState*)_state)->queue = NULL;
        ((AQRecordState*)_state)->fileStream = NULL;
        for(int i = 0; i < NUM_BUFFERS; i++)
            ((AQRecordState*)_state)->buffers[i] = NULL;
    }
    
    return self;
}

- (void)dealloc
{
    delete (AQRecordState*)_state;
    [super dealloc];
}

- (AQRecordState*)recorderState
{
    return (AQRecordState*)_state;   
}


//销毁状态,重置
- (void)cleanup
{
    //销毁AudioQueue
    if([self recorderState]->queue != NULL)
    {
        AudioQueueDispose([self recorderState]->queue, YES);
        [self recorderState]->queue = NULL;
    }
    
    //销毁缓存
    for(int i = 0; i < NUM_BUFFERS; i++)
    {
        if([self recorderState]->buffers[i] != NULL)
            AudioQueueFreeBuffer([self recorderState]->queue,[self recorderState]->buffers[i]);
        
        [self recorderState]->buffers[i] = NULL;
    }
    
    
    //关闭文件
    if([self recorderState]->fileStream)
    {
        [[self recorderState]->fileStream close];
        [[self recorderState]->fileStream release];
    }
}


- (NSTimeInterval) currentTime
{
    AudioTimeStamp outTimeStamp;
    
    OSStatus status = AudioQueueGetCurrentTime([self recorderState]->queue, NULL, &outTimeStamp, NULL);
    if (status)
    {
        NSLog(@"获取当前录音时间失败,错误码:%ld",status);
        return 0.0f;
    }
    
    return outTimeStamp.mSampleTime / [(NSNumber *)[[self settings] objectForKey:@"rate"] intValue];
}


- (void)setupAudioFormat:(AudioStreamBasicDescription*)format
{
    format->mSampleRate = [(NSNumber *)[[self settings] objectForKey:@"rate"] intValue];
    format->mFormatID = kAudioFormatLinearPCM;
    format->mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    format->mChannelsPerFrame = 1; // mono
    format->mBitsPerChannel = 16;
    format->mFramesPerPacket = 1;
    format->mBytesPerPacket = 2;
    format->mBytesPerFrame = 2;
    format->mReserved = 0;
}


- (BOOL)onStartRecordWithSettings:(NSDictionary *)settings error:(NSError **)error
{
    
    [self setupAudioFormat:&(((AQRecordState*)_state)->dataFormat)];
    
    //创建AudioQueue
    OSStatus status;
    status = AudioQueueNewInput(&[self recorderState]->dataFormat,
                                HandleInputBuffer,
                                self, 
                                CFRunLoopGetMain(),
                                kCFRunLoopCommonModes, 
                                0, 
                                &([self recorderState]->queue));
    if (status) 
    {
        if(error != nil){
            *error = [NSError errorWithDomain:@"AudioRecorder" code:status message:NSLocalizedStringFromTable(@"创建AudioQueue失败",RS_CURRENT_LANGUAGE_TABLE,nil)];
        }
        
        NSLog(@"创建AudioQueue失败");
        return NO;
    }
    
    
    //创建文件
    [self recorderState]->fileStream = [[NSOutputStream outputStreamWithURL:self.url append:NO] retain];
    [[self recorderState]->fileStream open];
    if([self recorderState]->fileStream.streamError != nil)
    {
        
        if(error != nil)
        {
            *error = [NSError errorWithDomain:@"AudioRecorder" 
                                         code:status 
                                      message:[self recorderState]->fileStream.streamError.localizedDescription];   
        }
        
        NSLog(@"创建音频文件失败,%@",[self recorderState]->fileStream.streamError);
        
        [[self recorderState]->fileStream release];
        AudioQueueDispose([self recorderState]->queue, YES);
        return NO;
    }
  
    DeriveBufferSize([self recorderState]->queue, [self recorderState]->dataFormat, 0.5, &[self recorderState]->bufferByteSize);
    
    //创建缓存
    for(int i = 0; i < NUM_BUFFERS; i++)
    {
        status = AudioQueueAllocateBuffer([self recorderState]->queue, [self recorderState]->bufferByteSize, &[self recorderState]->buffers[i]);
        if (status)
        {
            if(error!=nil){
                *error = [NSError errorWithDomain:@"AudioRecorder" code:status message:NSLocalizedStringFromTable(@"音频数据缓存入队列失败",RS_CURRENT_LANGUAGE_TABLE,nil)];
            }
            NSLog(@"创建音频数据缓存失败,错误码:%ld",status);
            break;
        }
        
        status = AudioQueueEnqueueBuffer([self recorderState]->queue, [self recorderState]->buffers[i], 0, NULL);
        if (status) 
        {
            if(error!=nil){
                *error = [NSError errorWithDomain:@"AudioRecorder" code:status message:NSLocalizedStringFromTable(@"音频数据缓存入队列失败",RS_CURRENT_LANGUAGE_TABLE,nil)];
            }
            NSLog(@"音频数据缓存入队列失败,错误码:%ld",status);
            break;
        }      
    }
    
   
    if(!status)
    {
        //音量波动
        UInt32 enableMetering = YES;
        status = AudioQueueSetProperty([self recorderState]->queue, 
                                       kAudioQueueProperty_EnableLevelMetering, 
                                       &enableMetering,
                                       sizeof(enableMetering));
        if (status)
            NSLog(@"设置获取音量波动失败，错误码:%ld",status);
        
        //开始录音咯
        status = AudioQueueStart([self recorderState]->queue, NULL);
        if (status)
        {
            //录音操作失败鸟....
            if(error!=nil){
                *error = [NSError errorWithDomain:@"AudioRecorder" code:status message:NSLocalizedStringFromTable(@"AudioQueueStart执行失败",RS_CURRENT_LANGUAGE_TABLE,nil)];
            }
            NSLog(@"录音操作失败鸟..错误码:%ld", status);
        }
    }
    
    //clean
    if(status)
    {
        [self cleanup];
        return NO;
    }
    
    return YES;
}


- (void)onStopRecord
{
    NSLog(@"AudioQueue录音机停止");
    
    AudioQueueFlush([self recorderState]->queue);
    AudioQueueStop([self recorderState]->queue, YES);

    [self cleanup];
}


//处理回调
- (void)handleInputBufferWithAudioQueue:(AudioQueueRef)aq
                                 buffer:(AudioQueueBufferRef)inBuffer
                              startTime:(AudioTimeStamp *)startTime
                             numPackets:(UInt32)inNumPackets
                             packetDesc:(AudioStreamPacketDescription *)inPacketDesc
{

    if (inNumPackets > 0)
    {
        char *encodedData = NULL;
        UInt32 *encodedDataLen = NULL;

// 变调的
//        AQ_set_if_soundtouch(_ram,1);
//        AQ_set_pitch_value(_ram,12);
        
//        AQ_set_if_denoise(_ram,1);
//        
//        AQ_effecter_reset(_ram);
//        
//        AQ_put_samples(_ram,(int16_t*)inBuffer->mAudioData,inBuffer->mAudioDataByteSize);
        
        size_t samples_size = inBuffer->mAudioDataByteSize/sizeof(short);
        short *samples = (short *)malloc(inBuffer->mAudioDataByteSize);
        
        
//        uint32_t receDataPerLen = 0;
//                
//        short * pageData = (short *)malloc(sizeof(short) * 1024);
//        int16_t page = 0;
//        
//        while ((receDataPerLen = AQ_receive_samples(_ram, pageData,sizeof(short) *  1024)) > 0) {
//            memcpy(samples + page * 1024, pageData, sizeof(short) * receDataPerLen);
//            page += 1;
//        }
        
        
//        free(pageData);
        
        [self.currentEncoder encodeWithData:samples
                                 dataLength:samples_size
                                encodedData:&encodedData
                          encodedDataLength:&encodedDataLen];
        
        free(samples);
        
//        [self.currentEncoder encodeWithData:(short*)inBuffer->mAudioData
//                                 dataLength:inBuffer->mAudioDataByteSize/2
//                                encodedData:&encodedData 
//                          encodedDataLength:&encodedDataLen];
        
        if(encodedDataLen != NULL && encodedData != NULL)
        {
            //写入数据
            [[self recorderState]->fileStream write:(const uint8_t *)encodedData
                                          maxLength:*encodedDataLen];
        }
        
        //释放内存
        if(encodedDataLen != NULL)
            free(encodedDataLen);
        
        if(encodedData != NULL)
            free(encodedData);
        
        //复用buffer
        if(self.isRecording)
            AudioQueueEnqueueBuffer ([self recorderState]->queue, inBuffer, 0, NULL);
    }
}

- (float)averagePower
{
    AudioQueueLevelMeterState state[1];
    UInt32  statesize = sizeof(state);
    OSStatus status;
    status = AudioQueueGetProperty([self recorderState]->queue, kAudioQueueProperty_CurrentLevelMeter, &state, &statesize);
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
    status = AudioQueueGetProperty([self recorderState]->queue, kAudioQueueProperty_CurrentLevelMeter, &state, &statesize);
    if (status)
    {
        NSLog(@"Error retrieving meter data\n"); 
        return 0.0f;
    }
    return state[0].mPeakPower;
}

@end



 