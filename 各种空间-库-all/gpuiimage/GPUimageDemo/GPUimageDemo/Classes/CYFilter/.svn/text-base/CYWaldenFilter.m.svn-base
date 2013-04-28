//
//  CYWaldenFilter.m
//  CYFilter
//
//  Created by chen yi on 12-10-18.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYWaldenFilter.h"
NSString *const kCYWaldenShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //map
 uniform sampler2D inputImageTexture3; //vigMap
 
 void main()
 {
     
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     
     texel = vec3(
                  texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,  //此处等同于曲线调整颜色RGB的分布
                  texture2D(inputImageTexture2, vec2(texel.g, .5)).g,
                  texture2D(inputImageTexture2, vec2(texel.b, .83333)).b);
     
     vec2 tc = (2.0 * textureCoordinate) - 1.0;
     float d = dot(tc, tc);
     vec2 lookup = vec2(d, texel.r);    //x轴固定，y轴就是RGB值
     texel.r = texture2D(inputImageTexture3, lookup).r;
     lookup.y = texel.g;
     texel.g = texture2D(inputImageTexture3, lookup).g;
     lookup.y = texel.b;
     texel.b	= texture2D(inputImageTexture3, lookup).b;
     
     gl_FragColor = vec4(texel, 1.0);
 }
 );
@implementation CYWaldenFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kCYWaldenShaderString]))
    {
		return nil;
    }
	
	[self.pictureImagePaths addObject:@"waldenMap"];
	[self.pictureImagePaths addObject:@"vignetteMap"];
	
    return self;
}

@end
