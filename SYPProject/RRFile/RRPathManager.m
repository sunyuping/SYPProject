//
//  RRPathManager.m
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RRPathManager.h"
#import "RRLog.h"

RR_DECLARE_SINGLETON(RRPathManager)

@implementation RRPathManager

RR_IMPLETEMENT_SINGLETON(RRPathManager,defaultPathManager)

-(id) init {
    RRLOG_NULLPOINT([super init]);
    NSArray* array = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory,NSUserDomainMask,YES);
    _rootPath = [array objectAtIndex:0];
    RRLOG_NULLPOINT(_rootPath);
    [_rootPath retain];    
    _fileManager = [RRFileManager defaultManager];
    RRLOG_NULLPOINT(_fileManager);
    [_fileManager replaceDirectoryAtPath:_rootPath];
    return self;    
}

-(void)dealloc{
    [super dealloc];
    [_rootPath release];
    _fileManager =nil ;
}
-(NSMutableString*) getLogPath {
    NSMutableString* logPath = [NSMutableString stringWithString:_rootPath];
    RRLOG_NULLPOINT(logPath);
    [logPath appendString:@"/RRLog"];
    [_fileManager replaceDirectoryAtPath:logPath];
    [logPath appendString:@"/"];
    return logPath;
}
-(NSMutableString*) getDatabasePath {
    return nil;
}
-(NSMutableString*) getCachePath {
    return nil;
}
-(NSMutableString*) getDownloadPath {
    return nil;
}
-(NSMutableString*) getApplicationPath {
    return nil;
}
-(NSMutableString*) getSystemVideoPath {
    return nil;    
}
-(NSMutableString*) getSystemAudioPath {
    return nil;    
}
-(NSMutableString*) getSystemPhotoPath {
    return nil;    
}

@end
