//
//  RRFileHandle.h
//  RRFramework
//
//  Created by 玉平 孙 on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRDefines.h"

typedef enum {
    RRFileReadMode     =1,
    RRFileWriteMode    =2,
    RRFileReadWriteMode=3
}TRRFileMode;

@class RRFileHandle;

@interface RRFileHandle : NSObject {
    NSFileHandle* _fileHandle ;
    TRRFileMode _fileMode;
}
@property (nonatomic,assign,readonly) NSFileHandle* fileHandle ;

+(RRFileHandle*) fileHandleCreateFile:(NSString*) path mode:(TRRFileMode) mode ;
+(RRFileHandle*) fileHandleOpenFile:(NSString*) path mode:(TRRFileMode) mode ;
+(RRFileHandle*) fileHandleReplaceFile:(NSString*) path mode:(TRRFileMode) mode ;

-(NSUInteger)fileSize;
-(NSData *)readDataOfLength:(NSUInteger)length;
-(void)writeData:(NSData *)data;
-(void)writeData:(const void *)bytes length:(NSUInteger)length; 
-(unsigned long long)offsetInFile;
-(unsigned long long)seekToEndOfFile;
-(void)seekToFileOffset:(unsigned long long)offset;
-(NSData *)availableData;
/*
 截断或者增加文件大小
 */
-(void)truncateFileAtOffset:(unsigned long long)offset;
-(void)synchronizeFile;
-(void)closeFile;

@end
