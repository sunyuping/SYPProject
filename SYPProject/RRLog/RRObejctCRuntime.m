//
//  RRObejctCRuntime.m
//  RRFramework
//
//  Created by 玉平 孙 on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RRObejctCRuntime.h"
#import "RRLog.h"

@implementation RRObejctCRuntime

+(void)displayIvarList:(id)obj {
    unsigned int ivarCount =0 ;
    Ivar* ivar=class_copyIvarList([obj class],&ivarCount);
    for(int i=0 ;i<ivarCount;i++) {
        const char* name = ivar_getName(ivar[i]);
        const char* typeEncoding = ivar_getTypeEncoding(ivar[i]);
        int offset = ivar_getOffset(ivar[i]);
        RRLOGI("name =%s typeEncoding=%s offset=%d ",name,typeEncoding,offset);
    }
}
+(void)displayPropertyList:(id)obj {
    unsigned int methodCount =0;
    Method* method = class_copyMethodList([obj class],&methodCount);
    for(int i=0 ;i<methodCount;i++) {
        const char* name =  sel_getName(method_getName(method[i]));
        const char* typeEncoding = method_getTypeEncoding(method[i]);
        RRLOGI("name =%s typeEncoding=%s",name,typeEncoding);
    }
}
+(void)displayMethodList:(id)obj {
    
}
+(void)displayProtocolList:(id)obj {
    
}

+(id)objectgetIvar:(id)obj name:(const char *)name {
    Ivar ivar = class_getInstanceVariable([obj class],name);
    if (ivar) {
        return (void *)((char *)self + ivar_getOffset(ivar));
    }
    return nil;
}
@end
