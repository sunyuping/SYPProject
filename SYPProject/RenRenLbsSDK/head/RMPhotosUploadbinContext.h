//
//  RMPhotosUploadbinContext.h
//  RMSDK
//
//  Created by renren-inc on 11-10-24.
//  Copyright 2011年 Renren Inc. All rights reserved.
//  - Powered by Team Pegasus. -
//

#import "RMCommonContextPublic.h"
#import "RMPhotosUploadbinResponse.h"


@interface RMPhotosUploadbinContext : RMCommonContext {
    RMPhotosUploadbinResponse *response;    ///< 返回的结果  
    NSString *aid;                          ///上传的相册id，缺省值应用的相册
    NSString *caption;                      ///照片的描述信息
    NSInteger from;                         ///分享来源应用id
    NSString *place_data;                   ///描述地理位置的JSON格式字符串
    NSInteger upload_type;                  ///上传照片的来源：（1=首页拍照上传；2=首页相册上传；3=poi页拍照上传；4=poi页相册上传）
    NSInteger photo_index;                  ///本次上传的序号（从1开始，当photo_index == photo_total时表示上传完成，发送新鲜事）
    NSInteger photo_total;                  ///本批次的上传总量（当photo_total不为存在切不为0时表示为批量上传方式）

}
@property(copy,nonatomic) NSString *aid;
@property(copy,nonatomic) NSString *caption;
@property(assign,nonatomic) NSInteger from;
@property(copy,nonatomic) NSString *place_data;
@property(assign,nonatomic) NSInteger upload_type;
@property(assign,nonatomic) NSInteger photo_index;
@property(assign,nonatomic) NSInteger photo_total;
@property(retain,nonatomic) UIImage *photo;

/**
 *一键上传图片
 *异步请求
 *@param image 图片文件按标准的HTTP Multipart方式传输，可按标准自行选择编码方式；此值不参与sig值运算。
 */        
-(void)asynPhotosUploadbinWithImage:(UIImage *)image;
/**
 *一键上传图片
 *同步请求
 *@param image 图片文件按标准的HTTP Multipart方式传输，可按标准自行选择编码方式；此值不参与sig值运算。
 *@param error 错误信息
 *@return YES 成功 NO 失败
 */
-(BOOL)synPhotosUploadbinWithImage:(UIImage *)image error:(RMError **)error;
-(void)cancelUpload;
-(RMPhotosUploadbinResponse *)getContextResponse;

@end
