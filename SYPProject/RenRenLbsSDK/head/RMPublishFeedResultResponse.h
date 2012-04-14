//
//  RMPublishFeedResultResponse.h
//  RMSDK
//
//  Created by 王 永胜 on 12-2-13.
//  Copyright (c) 2012年 人人网. All rights reserved.
//

#import "RMObject.h"

@interface RMPublishFeedResultResponse : RMResponse{
    NSString *feedId;          ///发布成功后新鲜事的Id。    Id of the feed after published successfully.
}
@property(nonatomic, readonly)NSString *feedId;

@end
