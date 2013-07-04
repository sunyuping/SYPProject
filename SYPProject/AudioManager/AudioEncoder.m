//
//  AudioEncoder.m
//  AudioManager
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import "AudioEncoder.h"

@implementation AudioEncoder

@synthesize rate;
@synthesize channels;


- (BOOL)setup
{
    [super setup];
    
    NSLog(@"AudioEncoder setup with rate=%ld, channels=%ld", rate, channels);
    
    return YES;
}


- (void)encodeWithData:(short *)pcmData 
            dataLength:(UInt32)dataLen 
           encodedData:(char **)encodedData
     encodedDataLength:(UInt32 **)encodedDataLen
{
    
}

@end
