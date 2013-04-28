//
//  CYColorSketchFilter.m
//  CYFilter
//
//  Created by chen yi on 12-10-19.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYColorSketchFilter.h"

/*	此处边缘提取算法采用的是索贝儿算子
 */
NSString *const kCYColorSketchFragmentShaderString = SHADER_STRING
(
 precision mediump float;
 
 varying vec2 textureCoordinate;
 varying vec2 leftTextureCoordinate;
 varying vec2 rightTextureCoordinate;
 
 varying vec2 topTextureCoordinate;
 varying vec2 topLeftTextureCoordinate;
 varying vec2 topRightTextureCoordinate;
 
 varying vec2 bottomTextureCoordinate;
 varying vec2 bottomLeftTextureCoordinate;
 varying vec2 bottomRightTextureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {   //参考 sketch shader
     vec3 bottomLeftIntensity = texture2D(inputImageTexture, bottomLeftTextureCoordinate).rgb;
     vec3 topRightIntensity = texture2D(inputImageTexture, topRightTextureCoordinate).rgb;
     vec3 topLeftIntensity = texture2D(inputImageTexture, topLeftTextureCoordinate).rgb;
     vec3 bottomRightIntensity = texture2D(inputImageTexture, bottomRightTextureCoordinate).rgb;
     vec3 leftIntensity = texture2D(inputImageTexture, leftTextureCoordinate).rgb;
     vec3 rightIntensity = texture2D(inputImageTexture, rightTextureCoordinate).rgb;
     vec3 bottomIntensity = texture2D(inputImageTexture, bottomTextureCoordinate).rgb;
     vec3 topIntensity = texture2D(inputImageTexture, topTextureCoordinate).rgb;
	 
	 //x轴近似差分
     vec3 h = -topLeftIntensity - 2.0 * topIntensity - topRightIntensity + bottomLeftIntensity + 2.0 * bottomIntensity + bottomRightIntensity;
  
	 //y轴近似差分
	 vec3 v = -bottomLeftIntensity - 2.0 * leftIntensity - topLeftIntensity + bottomRightIntensity + 2.0 * rightIntensity + topRightIntensity;
     
     vec3 mag ;
	 mag.r = 1.0 - length(vec2(h.r , v.r ));
     mag.g = 1.0 - length(vec2(h.g , v.g ));
	 mag.b = 1.0 - length(vec2(h.b , v.b ));
	 
	
	 gl_FragColor =  vec4(mag,1.0); 

  }
 );

@implementation CYColorSketchFilter

- (id)init;
{
	
    if (!(self = [self initWithFragmentShaderFromString :kCYColorSketchFragmentShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
