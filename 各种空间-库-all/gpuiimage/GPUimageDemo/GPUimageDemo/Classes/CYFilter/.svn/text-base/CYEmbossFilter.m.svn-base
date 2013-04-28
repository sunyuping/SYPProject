//
//  CYEmbossFilter.m
//  CYFilter
//
//  Created by chen yi on 12-10-18.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYEmbossFilter.h"
NSString *kCYEmbossFilterShaderString = SHADER_STRING
(// 1
	precision lowp float;
	
	varying highp vec2 textureCoordinate;
 
	uniform sampler2D inputImageTexture;
 
	void main()
	{
		// 2
		vec2 onePixel = vec2(1.0 / 480.0, 1.0 / 320.0);

		// 3
		vec2 texCoord = textureCoordinate;
		
		// 4
		vec4 color;
		color.rgb = vec3(0.5);//临界阈值设为一半
		
		color -= texture2D(inputImageTexture, texCoord - onePixel) * 5.0;
		color += texture2D(inputImageTexture, texCoord + onePixel) * 5.0;
		// 5
		color.rgb = vec3((color.r + color.g + color.b) / 3.0);
		gl_FragColor = vec4(color.rgb, 1);
	}
);


@implementation CYEmbossFilter

- (id)init{
	
	if (self = [super initWithFragmentShaderFromString:kCYEmbossFilterShaderString]) {
		
		return self;
	}
	
	return nil;
}



@end
