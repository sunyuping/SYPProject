//
//  Created by sunyuping on 13-2-20.
//  Copyright (c) 2013年 sunyuping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioEncoder.h"

@interface AudioRecorder(Protected)

/*!
 @property
 @abstract  当前录音正在使用的编码器,仅当录音操作时有效，非录音时为nil
 */
@property(nonatomic, readonly)AudioEncoder *currentEncoder;


- (BOOL)onStartRecordWithSettings:(NSDictionary *)settings error:(NSError **)error;


- (void)onStopRecord;

@end

