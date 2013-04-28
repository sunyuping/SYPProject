//
//  CYFilterChain.h
//  CYFilter
//
//  Created by yi chen on 12-7-25.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

typedef enum {
	
	CYCaptureStatueLiving, //滤镜源，是实时
	CYCaptureStatuePicture //滤镜源，是图片
	
}CYCaptureStatue;


/*
	通过滤镜链可以自己添加一些滤镜的组合，定制流程如CYYellowCake所示
	同时需要往filter.json中添加一条纪录
 */
@interface CYFilterChain : NSObject

/*
	改滤镜的描述
 */
@property (nonatomic, readonly) NSString *title;

@property(nonatomic,retain)GPUImageOutput<GPUImageInput> *finallyFilter;

- (void)addFilterToChain:(id)filter;

@end
