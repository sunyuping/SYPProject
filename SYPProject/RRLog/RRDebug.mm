//
//  RRDebug.m
//  RRFramework
//
//  Created by 玉平 孙 on 12-1-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RRDebug.h"
#import "RRDefines.h"
#include <cxxabi.h>
#include <map>
#include <string>
#include <execinfo.h>
#include <stdio.h>
#include "RRLog.h"
static std::map<unsigned int, std::string>* objectiveCMethodNames = NULL;

void addClass(Class c) ;
inline static unsigned int lookupFunction(unsigned int addr, const char** name) {
    if (objectiveCMethodNames == NULL)
        return NULL;
    // Find the next function
    std::map<unsigned int, std::string>::iterator iter = objectiveCMethodNames->upper_bound( addr );
    // Go back a function: now we are looking at the right one!
    iter--;
    *name = iter->second.c_str();
    return iter->first;
}
inline static void  addObjectiveCMethod(unsigned int addr, const char* name) {
    (*objectiveCMethodNames)[addr] = std::string(name); 
}

void addClass(Class c) {
    unsigned int method_count;
    Method *method_list = class_copyMethodList(c, &method_count);
    for (int i = 0; i < method_count; i++) {
        Method      func = method_list[i];
        const char* name = sel_getName( method_getName( func ) );
        unsigned int      addr = (unsigned int) method_getImplementation( func );
        addObjectiveCMethod(addr,[[NSString stringWithFormat:@"[%s %s]",class_getName(c), name] cString]);
    }
}

@implementation RRDebug

+(void)loadDebugSymbol {
    objectiveCMethodNames = new std::map<unsigned int, std::string>();
    int numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0 ) {
        Class *classes = (Class*) malloc(sizeof(Class) * numClasses);
        numClasses     = objc_getClassList(classes, numClasses);
        for (int i = 0; i < numClasses; ++i) {
            addClass(classes[i]);
        }
        free(classes);
    }
}
+(NSString*)lookupFunction:(unsigned int) address backtrace:(const char*)backtrace  {
    char functionSymbol[64*1024];
    char moduleName    [64*1024];
    int  offset        = 0;
    sscanf(backtrace, "%*d %s %*s %s %*s  %d", &moduleName,&functionSymbol, &offset);
    unsigned int addr = address;
    if (objectiveCMethodNames) {
        const char* objcName;
        unsigned int objcAddr = lookupFunction(addr, &objcName);
        if ( (objcAddr != 0) && (addr > objcAddr) && (addr - objcAddr < offset)) {
            RRLOGE("\t%8.8x — %s  + %d\t\t(%s)\n", addr, objcName, addr - objcAddr, moduleName);
            //printf("\t%8.8x — %s  + %d\t\t(%s)\n", addr, objcName, addr - objcAddr, moduleName);
            return NULL;
           // continue; 
        };
    };
    int   validCppName;
    char* functionName = abi::__cxa_demangle(functionSymbol, NULL, 0, &validCppName);
    if (validCppName == 0) {
        printf(   "\t%8.8x — %s + %d\t\t(%s)\n",addr, functionName, offset, moduleName);
    }
    else {
        printf(   "\t%8.8x — %s + %d\t\t(%s)\n",addr, functionSymbol, offset, moduleName);
    }
    if (functionName) {
        free(functionName);
    }
    return NULL;
}
@end
