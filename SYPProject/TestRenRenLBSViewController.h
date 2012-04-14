//
//  TestRenRenLBSViewController.h
//  SYPProject
//
//  Created by 玉平 孙 on 12-3-21.
//  Copyright (c) 2012年 RenRen.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMRequestContextDelegate.h"
#import "RMSetStatusContext.h"
#import "RMPhotosUploadbinContext.h"
#import "RMPlaceGetPoiCategoryContext.h"
#import "RMPlacePoiListContext.h"
#import "RMPlaceGetNearByRecommendPoiExtraListContext.h"
@interface TestRenRenLBSViewController : UIViewController<RMRequestContextDelegate>{
    UITextView *_result;
    RMPlaceGetNearByRecommendPoiExtraListContext *poiExtraListContext;
    RMPlacePoiListContext *placePoiListContext;
    RMPlaceGetPoiCategoryContext *getPoiCategoryContext;
    RMSetStatusContext *setStatusContext ;
    RMPhotosUploadbinContext *photosUploadbinContext;
    NSInteger testNum;
}

@end
