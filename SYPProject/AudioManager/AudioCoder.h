//
//  AudioCoder.h
//  AudioManager
//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioCoder : NSObject

/*!
 @property
 @abstract  编解码器针对的音频格式,如:ogg,mp3,wma
 */
@property(nonatomic, readonly)NSString *format;

- (BOOL)setup;

- (void)finish;


@end
