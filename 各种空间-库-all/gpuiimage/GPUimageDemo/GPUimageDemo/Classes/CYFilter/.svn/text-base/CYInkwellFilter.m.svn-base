//
//  CYInkwellFilter.m
//  CYFilter
//
//  Created by chen yi on 12-10-18.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYInkwellFilter.h"

NSString *const kCYInkWellShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     texel = vec3(dot(vec3(0.3, 0.6, 0.1), texel));
     texel = vec3(texture2D(inputImageTexture2, vec2(texel.r, .16666)).r);
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation CYInkwellFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kCYInkWellShaderString]))
    {
		return nil;
    }
    [self.pictureImagePaths addObject:@"inkwellMap"];
    return self;
}


@end
