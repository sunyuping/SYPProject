//
//  AudioRecorder.m
//  AudioManager
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "AudioRecorder.h"
#import "AudioRecorder+Protected.h"


@interface AudioRecorderImpl : NSObject {

}

@property(nonatomic, retain)NSMutableArray *encoders;
@property(nonatomic, retain)AudioEncoder *currentEncoder;
@property(nonatomic, assign)BOOL isRecording;
@property(nonatomic, retain)NSURL   *url;
@property(nonatomic, retain)NSMutableDictionary *settings;



- (AudioEncoder *)searchEncoderByFormat:(NSString *)format;

@end


@implementation AudioRecorderImpl
@synthesize encoders;
@synthesize currentEncoder;
@synthesize isRecording;
@synthesize url;
@synthesize settings;

- (id)init
{
    if(self = [super init])
    {
        isRecording = NO;
        encoders = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [encoders release];
    [currentEncoder  release];
    [url  release];
    [settings  release];
    
    [super dealloc];
}

- (AudioEncoder *)searchEncoderByFormat:(NSString *)format
{
    for(AudioEncoder *encoder in self.encoders)
    {
        if([encoder.format compare:format] == 0)
            return encoder;
    }
    
    return nil;
}

@end


@implementation AudioRecorder

@synthesize encoders;
@synthesize recording;
@synthesize settings;
@synthesize url;
@synthesize currentTime;
//@synthesize meteringEnabled;


#pragma mark- init & dealloc

- (id)init
{

    if(self = [super init])
    {
        _impl = [[AudioRecorderImpl alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [(AudioRecorderImpl*)_impl release];
    [super dealloc];
}

#pragma mark- 属性
- (NSArray *)encoders
{
    return ((AudioRecorderImpl*)_impl).encoders;
}

- (AudioEncoder *)currentEncoder
{
    return ((AudioRecorderImpl*)_impl).currentEncoder;
}

- (BOOL)isRecording
{
    return ((AudioRecorderImpl*)_impl).isRecording;
}

- (NSURL *)url
{
    return ((AudioRecorderImpl*)_impl).url;
}
 
- (NSTimeInterval)currentTime
{
    return 0;
}

- (NSDictionary *)settings
{
    return ((AudioRecorderImpl*)_impl).settings;
}


#pragma mark- 对外接口

- (void)registeEncoder:(AudioEncoder *)encoder
{
    //检测支持格式是否已经存在
    [[(AudioRecorderImpl*)_impl encoders] addObject:encoder];
}

- (BOOL)recordWithURL:(NSURL *)fileUrl settings:(NSDictionary *)userSettings error:(NSError **)outError
{   
    NSLog(@"开始录音, 保存地址:%@, 设置:%@", fileUrl, userSettings);
    
    //检查参数
    if(fileUrl == nil)
    {
        if(*outError != nil)
            *outError = [NSError errorWithDomain:@"AudioRecorder" code:1 message:NSLocalizedStringFromTable(@"参数错误, 未设置录音文件保存地址",RS_CURRENT_LANGUAGE_TABLE,nil)];
        
        NSLog(@"录音操作，保存文件路径不能为空");
        return NO;
    }
    
    NSMutableDictionary *mtDic = [NSMutableDictionary dictionary];
    if(userSettings == nil)
    {
        [mtDic setObject:[NSNumber numberWithInt:44100] forKey:@"rate"];
        [mtDic setObject:[NSNumber numberWithInt:1] forKey:@"channels"];
        [mtDic setObject:[NSNumber numberWithInt:0] forKey:@"duration"];
    }
    else 
    {
        if([userSettings objectForKey:@"rate"])
            [mtDic setObject:[userSettings objectForKey:@"rate"] forKey:@"rate"];
        else 
            [mtDic setObject:[NSNumber numberWithInt:44100] forKey:@"rate"];
        
        
        if([userSettings objectForKey:@"channels"])
            [mtDic setObject:[userSettings objectForKey:@"channels"] forKey:@"channels"];
        else 
            [mtDic setObject:[NSNumber numberWithInt:1] forKey:@"channels"];
        
        
        if([userSettings objectForKey:@"duration"])
            [mtDic setObject:[userSettings objectForKey:@"duration"] forKey:@"duration"];
        else 
            [mtDic setObject:[NSNumber numberWithInt:0] forKey:@"duration"];
    }
    
    
    //查找编码器
    NSString *format =  [[fileUrl absoluteString] pathExtension];
    AudioEncoder *encoder = [(AudioRecorderImpl *)_impl searchEncoderByFormat:format];
    if(encoder == nil)
    {
        NSLog(@"未找到对应录音编码器,对应格式:%@",format);
        if(outError != nil)
            *outError = [NSError errorWithDomain:@"AudioRecorder" code:2 message:NSLocalizedStringFromTable(@"录音格式错误,未查找到对应的编码器",RS_CURRENT_LANGUAGE_TABLE,nil)];
        
        return NO;
    }
    
    ((AudioRecorderImpl *)_impl).url = fileUrl;
    ((AudioRecorderImpl *)_impl).settings = mtDic;
    ((AudioRecorderImpl *)_impl).currentEncoder = encoder;

    encoder.rate = [[mtDic objectForKey:@"rate"] unsignedIntValue];
    encoder.channels = [[mtDic objectForKey:@"channels"] unsignedIntValue];
    [encoder setup];
    
    //具体的播放器实例处理
    if(![self onStartRecordWithSettings:userSettings error:outError])
    {
        [encoder finish];
        ((AudioRecorderImpl *)_impl).url = nil;
        ((AudioRecorderImpl *)_impl).currentEncoder = nil;
        
        return NO;   
    }

    ((AudioRecorderImpl *)_impl).isRecording = TRUE;
    
    return YES;
}

- (void)stop
{
    NSLog(@"停止录音");
    
    if(!self.isRecording)
    {
        NSLog(@"当前没有在录音, 没必要调用‘停止’操作");
        return;   
    }
    
    [self onStopRecord];
    
    //关闭编码器
    if(self.currentEncoder != nil)
        [self.currentEncoder finish];
    
    ((AudioRecorderImpl*)_impl).isRecording = NO;
    ((AudioRecorderImpl *)_impl).currentEncoder = nil;
}


- (void)stopAndDelete
{
    NSLog(@"停止录音并删除录音文件");
    
    if(!self.isRecording)
    {
        NSLog(@"当前没有在录音, 没必要调用‘停止’操作");
        return;   
    }
    
    [self stop];
    //删除文件
    [[NSFileManager defaultManager] removeItemAtURL:self.url error:nil];
}



- (float)averagePower
{
    return 0.0f;
}

- (float)peakPower
{
    return 0.0f;
}


#pragma mark- protected
- (BOOL)onStartRecordWithSettings:(NSDictionary *)settings error:(NSError **)error
{
    return NO;
}


- (void)onStopRecord
{
    
}



@end
