//
//  RRLog.h
//  RRFrameWork
//
//  Created by 玉平 孙 on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

/*!
 For debugging:
 Go into the "Get Info" contextual menu of your (test) executable (inside the "Executables" group in the left panel of XCode). 
 Then go in the "Arguments" tab. You can add the following environment variables:
 
 Default:   Set to:
 ç                        NO       "YES"
 NSZombieEnabled                       NO       "YES"
 NSDeallocateZombies                   NO       "YES"
 NSHangOnUncaughtException             NO       "YES"
 
 NSEnableAutoreleasePool              YES       "NO"
 NSAutoreleaseFreedObjectCheckEnabled  NO       "YES"
 NSAutoreleaseHighWaterMark             0       non-negative integer
 NSAutoreleaseHighWaterResolution       0       non-negative integer
 
 For info on these varaiables see NSDebug.h; http://theshadow.uw.hu/iPhoneSDKdoc/Foundation.framework/NSDebug.h.html
 
 For malloc debugging see: http://developer.apple.com/mac/library/documentation/Performance/Conceptual/ManagingMemory/Articles/MallocDebug.html
 */

#import "RRDefines.h"
#import "RRSingleton.h"
#import "RRFileHandle.h"


@interface RRLog : NSObject {
@private
    RRFileHandle* _fileHandle;
    NSDateFormatter* _dateFormatter;
    NSMutableString* _logString;
}
@property (nonatomic,assign,readonly) NSMutableString* logString;

+(RRLog*)defaultLog;
@end

RREXTERN void RRLogWrite(const char* tag,const char* fileName,const char* functionName,int linenum,const char* format,...) ;
RREXTERN void RRLogStack(void);
RREXTERN void RRLogNSError(NSError* aError);

#define RRLOG_ON

#ifdef RRLOG_ON

#define RRLOGI(STRING,ARG...) do {RRLogWrite("INFO",__FILE__,__PRETTY_FUNCTION__,__LINE__,STRING,##ARG);}while(0);
#define RRLOGW(STRING,ARG...) do {RRLogWrite("WARRING",__FILE__,__PRETTY_FUNCTION__,__LINE__,STRING,##ARG);}while(0);
#define RRLOGE(STRING,ARG...) do {RRLogWrite("ERROR",__FILE__,__PRETTY_FUNCTION__,__LINE__,STRING,##ARG);RRLOG_STACK;}while(0);

#else

#define RRLOGI
#define RRLOGW
#define RRLOGE
#endif

#define RRLOG_STACK                       do{RRLogStack();}while(0);          

#define RRASSERT(condation,desc,...)      do{if((condation)==NO){RRLOGE(desc,##__VA_ARGS__);RRLOG_STACK;NSAssert(condation,[NSString stringWithUTF8String:desc],##__VA_ARGS__);}}while(0);

#define RRLOG_NSERROR(error)               do{if ((error)!=nil) {RRLogNSError(error);RRASSERT(0,"");}}while(0);
#define RRLOG_NULLPOINT(ptr)               do{if(ptr==nil){RRASSERT(0,"");}}while(0);
#define RRLOG_RETNULL(condition,desc,...)  do{if((condition)==NO){RRLOGE(desc,##__VA_ARGS__);return nil;}}while(0);
#define RRLOG_RETBOOL(condition,desc,...)  do{if((condition)==NO){RRLOGE(desc,##__VA_ARGS__);return NO ;}}while(0);
