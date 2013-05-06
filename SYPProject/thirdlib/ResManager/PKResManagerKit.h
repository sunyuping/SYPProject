//
//  PKResManager.h
//  SYPFrameWork
//
//  Created by sunyuping on 12-12-27.
//  Copyright (c) 2012年 sunyuping. All rights reserved.
//

#ifndef PKResManagerKit_PKResManagerKit_h
#define PKResManagerKit_PKResManagerKit_h

#ifndef __IPHONE_4_0
#error "PKResManager uses features only available in iOS SDK 4.0 and later."
#endif



#import "UIImage+PKImage.h"
#import "UIColor+PKColor.h"
#import "UIFont+PKFont.h"
#import "PKResManager.h"

#define BUNDLE_PREFIX    @"bundle://"
#define DOCUMENTS_PREFIX @"documents://"

#define kAllResStyle     @"kAllResStyle"
#define kNowResStyle     @"kNowResStyle"

#define SAVED_STYLE_DIR  @"SavedStyleDir"
#define TEMP_STYLE_DIR   @"TempStyleDir"

#define kStyleID       @"kStyleID"
#define kStyleName     @"kStyleName"
#define kStyleVersion  @"kStyleVersion"
#define kStyleURL      @"kStyleURL"
// color
#define kColor           @"rgb"
#define kColorHL         @"rgb_hl"
#define kShadowColor     @"shadow_rgb"
#define kShadowColorHL   @"shadow_rgb_hl"
#define kShadowOffset    @"shadow_offset"

#define SYSTEM_STYLE_LIGHT      @"light"
#define SYSTEM_STYLE_NIGHT      @"night"
#define SYSTEM_STYLE_LIGHT_URL  @"bundle://style_light.bundle"
#define SYSTEM_STYLE_NIGHT_URL  @"bundle://style_night.bundle"

#define SYSTEM_STYLE_ID         @""
#define SYSTEM_STYLE_VERSION    @"999.0"

#define CONFIG_PLIST_PATH    @"/#config/styleConfig"
#define PREVIEW_PATH      @"/#config/preview"

// error
#define PK_ERROR_DOMAIN   @"PK_ERROR_DOMAIN"

#endif