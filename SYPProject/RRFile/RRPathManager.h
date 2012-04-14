//
//  RRPathManager.h
//  SYPProject
//
//  Created by 玉平 孙 on 12-1-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRFileManager.h"
#import "RRSingleton.h"

@interface RRPathManager : NSObject{
    NSString* _rootPath;
    RRFileManager* _fileManager;
}
+(RRPathManager*) defaultPathManager;
-(NSMutableString*) getLogPath;
-(NSMutableString*) getDatabasePath;
-(NSMutableString*) getCachePath;
-(NSMutableString*) getDownloadPath;

-(NSMutableString*) getApplicationPath;
-(NSMutableString*) getSystemVideoPath;
-(NSMutableString*) getSystemAudioPath;
-(NSMutableString*) getSystemPhotoPath;
@end
