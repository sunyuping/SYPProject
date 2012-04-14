//
//  RMPhotosUploadbinResponse.h
//  RMSDK
//
//  Created by renren-inc on 11-10-24.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMObject.h"


@interface RMPhotosUploadbinResponse : RMResponse {
    NSString *photoId;      /// 照片的id                      id of the photo
    NSString *albumId;      /// 照片所在相册id                 id of album which the photo belongs to
    NSString *userId;       /// 一张照片的所有者用户id           id of the photo's owner
    NSString *imageHead;    /// 100*100相册列表中的大小         the size of the photos on the album list (100*100)
    NSString *imageMain;    /// 200*200封面大小               the size of the cover photo (200*200)
    NSString *imageLarge;   /// 500*500正常相片               the size of the normal photo (500*500)
    NSString *caption;      /// 照片的描述信息                 decription of photo
}

@property (nonatomic, retain) NSString *photoId;
@property (nonatomic, retain) NSString *albumId;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *imageHead;
@property (nonatomic, retain) NSString *imageMain;
@property (nonatomic, retain) NSString *imageLarge;
@property (nonatomic, retain) NSString *caption;


@end