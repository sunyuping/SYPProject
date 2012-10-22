    //
    //  DataStatistic.m
    //  ShareDemo
    //
    //  Created by Buzzinate Buzzinate on 12-2-28.
    //  Copyright (c) 2012年 Buzzinate Co. Ltd. All rights reserved.
    //

#import "DataStatistic.h"
#import "SHSAPIKeys.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include "CommonCrypto/CommonDigest.h"
#include "AsyncOp.h"

@implementation DataStatistic

NSString *st_id = nil;





- (NSString *)getMA
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    size_t              length;
    unsigned char       mass[6];
    struct if_msghdr    *interfaceMsgStruct;
    struct sockaddr_dl  *socketStruct;
    NSString            *errorFlag = NULL;
    
        // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;              
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces
    
        // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0) 
        errorFlag = @"if_nametoindex failure";
    else
        {
            // Get the size of the data available (store in len)
        if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0) 
            errorFlag = @"sysctl mgmtInfoBase failure";
        else
            {
                // Alloc memory based on above call
            if ((msgBuffer = malloc(length)) == NULL)
                errorFlag = @"buffer allocation failure";
            else
                {
                    // Get system information, store in buffer
                if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
                    errorFlag = @"sysctl msgBuffer failure";
                }
            }
        }
    
        // Befor going any further...
    if (errorFlag != NULL)
        {
        NSLog(@"Error: %@", errorFlag);
        return errorFlag;
        }
    
        // Map msgbuffer to interface message structure
    interfaceMsgStruct = (struct if_msghdr *) msgBuffer;
    
        // Map to link-level socket structure
    socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);
    
        // Copy link layer address data in socket structure to an array
    memcpy(&mass, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);
    
    NSString *mas = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                     mass[0], mass[1], mass[2], 
                     mass[3], mass[4], mass[5]];
    
        // Release the buffer memory
    free(msgBuffer);
    
    return mas;
}



-(void)saveStID:(NSString*)st_id{ 
    [[NSUserDefaults standardUserDefaults] setValue:st_id forKey:@"st_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

-(NSString*)getStID{
    @try {
        NSString *st_id=nil;
        
        st_id= [[NSUserDefaults standardUserDefaults] objectForKey:@"st_id"];
        
        if(st_id) {
            return st_id;
        } 
        else {
            st_id = [self md5:[self getMA]];
            NSLog(@"st_id = %@",st_id);
            if (st_id){
                [self saveStID:st_id];
                return st_id;
            }
            return @"";
        }
    }
    @catch (NSException *exception) {
            //do nothing
        NSLog(@"error description[%@]", [exception description]);
    }
    return @"";
    
    
    
}




-(id)init{
    self = [super init];
    if (self){
        st_id = [self getStID];
    }
    return self;
}


- (NSString*)URLEncodedString:(NSString*)input  
{  
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  
                                                                           (CFStringRef)input,  
                                                                           NULL,  
                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),  
                                                                           kCFStringEncodingUTF8);  
    [result autorelease];  
    return result;  
} 

- (void)sendStatistic:(NSString *)url site:(NSString *)site {
    NSString *publisherUuid = PUBLISHER_UUID;
    if (!publisherUuid) {
        publisherUuid = @"";
    }
    if (!url){
        url =@"";
    }
    NSString *template = @"http://api.bshare.cn/share/stats.json?site=%@&publisherUuid=%@&url=%@&type=11&di=%@";
    
    NSString *myRequestString = [NSString stringWithFormat:template, site, publisherUuid, [self URLEncodedString:url], [self URLEncodedString: st_id]];
    NSLog(@"request = %@",myRequestString);
    NSMutableURLRequest *request = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: myRequestString]];
    [ request setHTTPMethod: @"GET" ];
    
        //#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
    AsyncOp *op = [[AsyncOp alloc] init:url withSite:site withRequest:request];
    [[NSOperationQueue mainQueue]addOperation:op];
    [op release];
    
        //#endif
        //#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
        //[NSURLConnection sendAsynchronousRequest:request 
        //                             queue:[NSOperationQueue mainQueue]
        //                 completionHandler:Nil];
        //#endif
    
    
    [request release];
}

-(void)main {
    
}

@end

