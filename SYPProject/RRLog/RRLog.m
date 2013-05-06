//
//  RRLog.m
//  RRFrameWork
//
//  Created by 玉平 孙 on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RRLog.h"
#import "RRFileManager.h"
#import "RRPathManager.h"

RR_DECLARE_SINGLETON(RRLog)

@implementation RRLog

@synthesize logString = _logString;

RR_IMPLETEMENT_SINGLETON(RRLog,defaultLog)

-(id) init {
    [super init];
    NSMutableString* logFile = [[RRPathManager defaultPathManager] getLogPath];
    [logFile appendString:@"log.log"];
    _fileHandle = [RRFileHandle fileHandleReplaceFile:logFile mode:RRFileWriteMode];
    [_fileHandle retain];
    
    _logString = [NSMutableString stringWithCapacity:1024];
    [_logString retain];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:MM:SS"];
    
    return self;
}
-(void)dealloc {
  //  [super dealloc];
    RRRelease(_dateFormatter);
    RRRelease(_logString);
    RRRelease(_fileHandle);                
}

-(void)write:(const char*)tag fileName:(const char*) filename functionName:(const char*) functionName lineNum:(int)lineNum format:(const char*)format arg:(va_list) arg{
    [_logString setString:@" "];
    [_logString appendString:[NSString RR_stringWithCString:tag]];
    [_logString appendString:@" "];
    
    CFStringAppendFormatAndArguments((CFMutableStringRef)_logString,NULL,(CFStringRef)[NSString RR_stringWithCString:format],arg);
    if (!(filename==NULL || functionName==NULL)) {
        [_logString appendString:@"\r\n"];
        [_logString appendFormat:@"filename =%s function =%s line =%d ",filename,functionName,lineNum];
        [_logString appendString:@"\r\n"];
    }
    NSLog(@"%@",_logString);
    NSDate* currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    [_logString insertString:[_dateFormatter stringFromDate:currentDate] atIndex:0];
    [_fileHandle writeData:[_logString UTF8String] length:[_logString length]];
}
-(void)writeStack:(char**) strs callstack:(unsigned int*)callstack count:(int)count {
    [_logString setString:@" "];
    [_logString appendString:@" ERROR STACK \r\n"];
    for(int i = 1;i<count;i++) {
        [_logString appendFormat:@"%s \r\n",strs[i]];
    }
    NSLog(@"%@",_logString);
    
    NSDate* currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    [_logString insertString:[_dateFormatter stringFromDate:currentDate] atIndex:0];
    [_fileHandle writeData:[_logString UTF8String] length:[_logString length]];
}
-(void)writeNSError:(NSError*) aError{
    [_logString setString:@" "];
    [_logString appendString:[aError description]];
    [_logString appendString:@"\r\n"];
    
    NSLog(@"%@",_logString);
    NSDate* currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    [_logString insertString:[_dateFormatter stringFromDate:currentDate] atIndex:0];
    [_fileHandle writeData:[_logString UTF8String] length:[_logString length]];
}
@end

void RRLogWrite(const char* tag,const char* fileName,const char* functionName,int linenum,const char* format,...) {
    NSLock* lock = [[NSLock alloc] init];
    [lock lock];
    va_list argList;
    va_start(argList, format);
    [[RRLog defaultLog] write:tag fileName:fileName functionName:functionName lineNum:linenum format:format arg:argList];
    va_end(argList);
    [lock unlock];
    RRRelease(lock);
}
void RRLogStack(void) {
    NSLock* lock = [[NSLock alloc] init];
    [lock lock];
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    [[RRLog defaultLog] writeStack:strs callstack:(unsigned int*)callstack count:frames];
    free(strs);
    [lock unlock];
    RRRelease(lock);
}
void RRLogNSError(NSError* aError) {
    NSLock* lock = [[NSLock alloc] init];
    [lock lock];
    [[RRLog defaultLog] writeNSError:aError];
    [lock unlock];
    RRRelease(lock);
}
