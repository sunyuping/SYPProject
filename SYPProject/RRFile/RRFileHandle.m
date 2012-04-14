//
//  RRFileHandle.m
//  RRFramework
//
//  Created by 玉平 孙 on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RRFileHandle.h"
#import "RRObejctCRuntime.h"
#import "RRFileManager.h"
#import "RRLog.h"

@interface RRFileHandle(PrivateMethod)
-(id)initWithCreateFile:(NSString*)path mode:(TRRFileMode)mode;
-(id)initWithOpenFile:(NSString*)path mode:(TRRFileMode)mode;
-(id)initWithReplaceFile:(NSString*)path mode:(TRRFileMode)mode;
-(id)internalCreateFile:(NSString*)path mode:(TRRFileMode)mode;
-(void)dealloc ;
@end


@implementation RRFileHandle

@synthesize fileHandle = _fileHandle;

+(RRFileHandle*) fileHandleCreateFile:(NSString*) path mode:(TRRFileMode) mode {
    RRFileHandle* fileHandle =[[RRFileHandle alloc] initWithCreateFile:path mode:mode];
    return [fileHandle autorelease];
}
+(RRFileHandle*) fileHandleOpenFile:(NSString*) path mode:(TRRFileMode) mode  {
    RRFileHandle* fileHandle =[[RRFileHandle alloc] initWithOpenFile:path mode:mode];
    return [fileHandle autorelease];
}
+(RRFileHandle*) fileHandleReplaceFile:(NSString*) path mode:(TRRFileMode) mode {
    RRFileHandle* fileHandle =[[RRFileHandle alloc] initWithReplaceFile:path mode:mode];
    return [fileHandle autorelease];
}
-(id)internalCreateFile:(NSString*)path mode:(TRRFileMode)mode {
    if (mode==RRFileReadMode) {
        return [NSFileHandle fileHandleForReadingAtPath:path];
    }
    else if (mode==RRFileWriteMode) {
        return [NSFileHandle fileHandleForWritingAtPath:path];
    }
    else if (mode==RRFileReadWriteMode) {
        return [NSFileHandle fileHandleForUpdatingAtPath:path];
    }
    
    _fileMode = mode;
    return nil;
}
-(id)initWithCreateFile:(NSString*)path mode:(TRRFileMode) mode {
    RRFileManager* fileManager = [RRFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path] == YES) {
        RRASSERT(0,"FILE EXISTS");
    }
    RRLOG_NULLPOINT([super init]);
    if([fileManager createEmptyFileAtPath:path]==NO){
        RRASSERT(0,"FILE CREATE FAILED");
    }
    _fileHandle = [self internalCreateFile:path mode:mode];
    RRLOG_NULLPOINT(_fileHandle);
    [_fileHandle retain];
    return self;
}

-(id)initWithOpenFile:(NSString*)path mode:(TRRFileMode) mode {
    if ([[RRFileManager defaultManager] fileExistsAtPath:path] == NO) {
        RRASSERT(0,"FILE NO EXISTS");
    }
    RRLOG_NULLPOINT([super init]);
    _fileHandle = [self internalCreateFile:path mode:mode];
    RRLOG_NULLPOINT(_fileHandle);
    [_fileHandle retain];
    return self;
        
}
-(id)initWithReplaceFile:(NSString*)path mode:(TRRFileMode) mode {
    if ([[RRFileManager defaultManager] fileExistsAtPath:path] == NO) {
        RRASSERT([[RRFileManager defaultManager] createEmptyFileAtPath:path],"");
    }
    RRLOG_NULLPOINT([super init]);
    _fileHandle = [self internalCreateFile:path mode:mode];
    RRLOG_NULLPOINT(_fileHandle);
    [_fileHandle retain];
    [_fileHandle truncateFileAtOffset:0];
    return self;
}
-(void)dealloc {
    [super dealloc];
    [self closeFile];
    RRRelease(_fileHandle);
}
-(NSUInteger)fileSize {
    NSUInteger pos = [self offsetInFile];
    [self seekToFileOffset:0];
    NSUInteger size = [self seekToEndOfFile] ;
    [self seekToFileOffset:pos];
    return size;
}
-(NSData *)readDataOfLength:(NSUInteger)length {
    return [_fileHandle readDataOfLength:length];
}
-(void)writeData:(NSData *)data {
    RRLOG_NULLPOINT(data);
    [_fileHandle writeData:data];
}
-(void)writeData:(const void *)bytes length:(NSUInteger)length {
    RRLOG_NULLPOINT(bytes);
    [_fileHandle writeData:[NSData dataWithBytesNoCopy:(void *)bytes length:length freeWhenDone:NO]];

   // [_fileHandle writeData:[NSData dataWithBytesNoCopy:(void *)bytes length:length]];
}
-(unsigned long long)offsetInFile {
    return [_fileHandle offsetInFile];
}
-(unsigned long long)seekToEndOfFile {
    return [_fileHandle seekToEndOfFile];
}
-(void)seekToFileOffset:(unsigned long long)offset {
    [_fileHandle seekToFileOffset:offset];
}
-(NSData *)availableData {
    return [_fileHandle availableData];
}
/*
 截断或者增加文件大小
 */
-(void)truncateFileAtOffset:(unsigned long long)offset {
    [_fileHandle truncateFileAtOffset:offset];
}
-(void)synchronizeFile {
    [_fileHandle synchronizeFile]; 
}
-(void)closeFile {
    [_fileHandle closeFile];
}
@end
