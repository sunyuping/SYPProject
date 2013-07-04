/*!
 @header  RemoteIORecorder.m 
 //
 //  Created by sunyuping on 13-2-20.
 //  Copyright (c) 2013年 sunyuping. All rights reserved.
 //
*/

#import "RemoteIORecorder.h"
#include <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioFile.h>
#import "AudioRecorder+Protected.h"


@interface RemoteIORecorder (Private)

-(void)				cleanUp;
-(NSString*)		configureAU;		// Returns error string, NIL on success.
-(AudioBufferList*)	allocateAudioBufferListWithNumChannels: (UInt32)numChannels size: (UInt32)size;
-(void)				destroyAudioBufferList: (AudioBufferList*)list;
-(void)             handleAudioInputWithFlags:(AudioUnitRenderActionFlags*)ioActionFlags 
                                    timeStamp:(AudioTimeStamp*)inTimeStamp
                                    busNumber:(UInt32)inBusNumber 
                                 numberFrames:(UInt32)inNumberFrames
                                         data:(AudioBufferList*)ioData;

@end



@implementation RemoteIORecorder


static OSStatus AudioInputProc( void* inRefCon, AudioUnitRenderActionFlags* ioActionFlags, const AudioTimeStamp* inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList* ioData)
{   
    
    RemoteIORecorder *	recorder = (RemoteIORecorder*)inRefCon;
    
    
    OSStatus status = AudioUnitRender(recorder->_audioUnit, 
                                      ioActionFlags, 
                                      inTimeStamp, 
                                      inBusNumber, 
                                      inNumberFrames, 
                                      recorder->_audioBuffer);
    if(status != noErr)
        return status;
    
    [recorder handleAudioInputWithFlags:ioActionFlags 
                              timeStamp:(AudioTimeStamp*)inTimeStamp
                              busNumber:inBusNumber
                           numberFrames:inNumberFrames
                                   data:recorder->_audioBuffer];
	 
    
    //	// Render into audio buffer
    //	err = AudioUnitRender( afr->audioUnit, ioActionFlags, inTimeStamp,
    //                          inBusNumber, inNumberFrames, afr->audioBuffer);
    //	if( err )
    //		fprintf( stderr, "AudioUnitRender() failed with error %i\n", err );
    //	
    //	// Write to file, ExtAudioFile auto-magicly handles conversion/encoding
    //	// NOTE: Async writes may not be flushed to disk until a the file
    //	// reference is disposed using ExtAudioFileDispose
    //	err = ExtAudioFileWriteAsync( afr->outputAudioFile, inNumberFrames, afr->audioBuffer);
    //	if( err != noErr )
    //	{
    //		char	formatID[5] = { 0 };
    //		*(UInt32 *)formatID = CFSwapInt32HostToBig(err);
    //		formatID[4] = '\0';
    //		fprintf(stderr, "ExtAudioFileWrite FAILED! %d '%-4.4s'\n",err, formatID);
    //		return err;
    //	}
    //	
    //	UInt64	nanos = AudioConvertHostTimeToNanos( inTimeStamp->mHostTime -afr->startHostTime );
    //	afr->currSeconds = ((double)nanos) * 0.000000001;
    //	
    //	if( afr->delegateWantsTimeChanges )	// Don't waste time syncing to other threads if nobody is listening:
    //		[afr performSelectorOnMainThread: @selector(notifyDelegateOfTimeChange) withObject: nil waitUntilDone: NO];
    //	
	return noErr;
}

- (NSTimeInterval) currentTime
{
//    AudioTimeStamp outTimeStamp;
//    
//    OSStatus status = AudioQueueGetCurrentTime([self recorderState]->queue, NULL, &outTimeStamp, NULL);
//    if (status)
//    {
//        LogError(@"获取当前录音时间失败,错误码:%d",status);
//        return 0.0f;
//    }
//    
//    return outTimeStamp.mSampleTime / [(NSNumber *)[[self settings] objectForKey:@"rate"] intValue];
    
    return 0;
}

- (void)setupAudioFormat
{
    _audioFormat.mSampleRate = [(NSNumber *)[[self settings] objectForKey:@"rate"] intValue];
    _audioFormat.mFormatID = kAudioFormatLinearPCM;
    _audioFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
    _audioFormat.mChannelsPerFrame = 1; // mono
    _audioFormat.mBitsPerChannel = 16;
    _audioFormat.mFramesPerPacket = 1;
    _audioFormat.mBytesPerPacket = 2;
    _audioFormat.mBytesPerFrame = 2;
    _audioFormat.mReserved = 0;
}

- (BOOL)onStartRecordWithSettings:(NSDictionary *)settings error:(NSError **)error
{
    [self setupAudioFormat];
    
    NSString *errorMsg = [self configureAU];
    if(errorMsg != nil)
    {
        return NO;
    }
    
//    AudioSessionInitialize(NULL, NULL, NULL, NULL);
//    AudioSessionSetActive(TRUE);
	//_startHostTime = AudioGetCurrentHostTime();
	OSStatus err = AudioOutputUnitStart(_audioUnit);
    if(err != noErr)
    {
        return NO;
    }
    
    return YES;
}

- (void)onStopRecord
{
    if(_audioUnit != nil)
        AudioOutputUnitStop(_audioUnit);   
    
    [self cleanUp];
}


@end

@implementation RemoteIORecorder(Private)

-(void)cleanUp
{
    if(_audioUnit)
    {
        AudioComponentInstanceDispose(_audioUnit);
		_audioUnit = NULL;
    }
    
    if(_fileStream)
    {
        [_fileStream close];
        [_fileStream release];
        _fileStream = nil;
    }
    
    if(_audioBuffer)
    {
        [self destroyAudioBufferList:_audioBuffer];
        _audioBuffer = nil;
    }
        
}


-(NSString*)configureAU
{

	AudioComponentDescription	description;
	OSStatus					err = noErr;
	
	if(_audioUnit)
	{
		AudioComponentInstanceDispose(_audioUnit);
		_audioUnit = NULL;
	}
	
	description.componentType = kAudioUnitType_Output;
	description.componentSubType = kAudioUnitSubType_RemoteIO;
	description.componentManufacturer = kAudioUnitManufacturer_Apple;
	description.componentFlags = 0;
	description.componentFlagsMask = 0;
    
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &description);
    err = AudioComponentInstanceNew(inputComponent, &_audioUnit);
    if( err != noErr )
    {
        _audioUnit = nil;
        return [NSString stringWithFormat: @"Couldn't open AudioUnit component (ID=%ld)", err];
    }
    
    //创建文件
    _fileStream = [[NSOutputStream outputStreamToFileAtPath:[self.url absoluteString] append:NO] retain];
    [_fileStream open];
    if(_fileStream.streamError != nil)
    {
        NSLog(@"创建音频文件失败,%@",_fileStream.streamError);
        [self cleanUp];
        return _fileStream.streamError.localizedDescription;
    }

    	
	//开启录音
    UInt32 flag = 1;
	err = AudioUnitSetProperty(_audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &flag, sizeof(UInt32) );
	if(err != noErr)
    {
        [self cleanUp];
        return [NSString stringWithFormat: @"Couldn't set EnableIO property on the audio unit (ID=%ld)", err];
    }
    
    //开启播放
    flag = 0;
    err = AudioUnitSetProperty(_audioUnit, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, 0, &flag, sizeof(UInt32) );
    if( err != noErr )
    {
        [self cleanUp];
        return [NSString stringWithFormat: @"Couldn't set EnableIO property on the audio unit (ID=%ld)", err];
    }
    
	
	//设置数据输入回调
    AURenderCallbackStruct callback;
	callback.inputProc = AudioInputProc;
	callback.inputProcRefCon = self;
	err = AudioUnitSetProperty(_audioUnit, kAudioOutputUnitProperty_SetInputCallback, 
                               kAudioUnitScope_Global, 
                               1, 
                               &callback, 
                               sizeof(AURenderCallbackStruct) );
	if(err != noErr)
	{
		[self cleanUp];
		return [NSString stringWithFormat: @"Could not install render callback on our AudioUnit (ID=%ld)", err];
	}
	
	//设置数据格式
	err = AudioUnitSetProperty(_audioUnit, 
                               kAudioUnitProperty_StreamFormat,
                               kAudioUnitScope_Input, 
                               0, 
                               &_audioFormat, 
                               sizeof(_audioFormat));
	if(err != noErr)
	{
		[self cleanUp];
		return [NSString stringWithFormat: @"Could not SetProperty StreamFormat on our AudioUnit (ID=%ld", err];
	}
    
//    err = AudioUnitSetProperty(_audioUnit, 
//                         kAudioUnitProperty_StreamFormat,
//                         kAudioUnitScope_Output, 
//                         0, 
//                         &audioFormat, 
//                         sizeof(audioFormat));
//    if(err != noErr)
//	{
//		[self cleanUp];
//		return [NSString stringWithFormat: @"Could not install render callback on our AudioUnit (ID=%d)", err];
//	}	
	
	//初始化AU
	err = AudioUnitInitialize(_audioUnit);
	if(err != noErr)
	{
		[self cleanUp];
		return [NSString stringWithFormat: @"Could not initialize the AudioUnit (ID=%ld)", err];
	}
	
	//申请缓存空间
	_audioBuffer = [self allocateAudioBufferListWithNumChannels:_audioFormat.mChannelsPerFrame
                                                           size: _audioFormat.mSampleRate * _audioFormat.mBytesPerFrame];
	if(_audioBuffer == NULL)
	{
		[self cleanUp];
		return [NSString stringWithFormat: @"Could not allocate buffers for recording (ID=%ld", err];
	}
	
	return nil;
}

-(AudioBufferList*)allocateAudioBufferListWithNumChannels:(UInt32)numChannels size: (UInt32)size
{
	AudioBufferList*			list = NULL;
	UInt32						i = 0;
	
	list = (AudioBufferList*) calloc( 1, sizeof(AudioBufferList) + numChannels * sizeof(AudioBuffer) );
	if( list == NULL )
		return NULL;
	
	list->mNumberBuffers = numChannels;
	
	for( i = 0; i < numChannels; ++i )
	{
		list->mBuffers[i].mNumberChannels = 1;
		list->mBuffers[i].mDataByteSize = size;
		list->mBuffers[i].mData = malloc(size);
		if(list->mBuffers[i].mData == NULL)
		{
			[self destroyAudioBufferList: list];
			return NULL;
		}
	}
	
	return list;
}

-(void)destroyAudioBufferList: (AudioBufferList*)list
{
    if(!list)
        return;
    
    for(UInt32 i = 0; i < list->mNumberBuffers; i++ )
    {
        if( list->mBuffers[i].mData )
            free(list->mBuffers[i].mData);
    }
    free(list);

}


-(void) handleAudioInputWithFlags:(AudioUnitRenderActionFlags*)ioActionFlags 
                        timeStamp:(AudioTimeStamp*)inTimeStamp
                        busNumber:(UInt32)inBusNumber 
                     numberFrames:(UInt32)inNumberFrames
                             data:(AudioBufferList*)ioData
{
    for(int i = 0; i < inNumberFrames; i++)
    {
        
        char *encodedData = NULL;
        UInt32 *encodedDataLen = NULL;
        
        AudioBuffer *inBuffer = &ioData->mBuffers[i];
        [self.currentEncoder encodeWithData:(short*)inBuffer->mData 
                                 dataLength:inBuffer->mDataByteSize/2
                                encodedData:&encodedData 
                          encodedDataLength:&encodedDataLen];
        
        if(encodedDataLen != NULL && encodedData != NULL)
        {
            //写入数据
            [_fileStream write:(const uint8_t *)encodedData 
                                          maxLength:*encodedDataLen];
        }
        
        //释放内存
        if(encodedDataLen != NULL)
            free(encodedDataLen);
        
        if(encodedData != NULL)
            free(encodedData);
    }
}

@end

