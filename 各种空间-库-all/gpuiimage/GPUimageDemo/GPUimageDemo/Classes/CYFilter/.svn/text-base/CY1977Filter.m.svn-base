//
//  CY1977Filter.m
//  CYFilter
//
//  Created by chen yi on 12-10-18.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CY1977Filter.h"

NSString *const kCY1977ShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     texel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .83333)).b);
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );

@implementation CY1977Filter
- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kCY1977ShaderString]))
    {
		return nil;
    }
	
    [self.pictureImagePaths addObject:@"1977map"];
    [self.pictureImagePaths addObject:@"1977blowout"];
	
    return self;
}

@end
