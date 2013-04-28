//
//  CYSkinWhiteFilter.m
//  CYFilter
//
//  Created by chen yi on 12-10-19.
//  Copyright (c) 2012年 renren. All rights reserved.
//
//#define max(a,b,c) max(a,max(b,c))
//#define min(a,b,c) min(a,min(b,c))

#import "CYSkinWhiteFilter.h"

//之前想采用人脸识别去美化皮肤的后来发相效果不佳

// refer: 人脸检测

// http://stackoverflow.com/questions/263380/showing-too-much-skin-detection-in-software
// http://wenku.baidu.com/view/338f7fc3d5bbfd0a7956734f.html
// http://zh.wikipedia.org/wiki/CIE1931%E8%89%B2%E5%BD%A9%E7%A9%BA%E9%97%B4
// http://zh.wikipedia.org/wiki/Lab%E8%89%B2%E5%BD%A9%E7%A9%BA%E9%97%B4

//NSString *kCYSkinWhiteFilterShaderString = SHADER_STRING
//(// 1
// precision lowp float;
//
// varying highp vec2 textureCoordinate;
//
// uniform sampler2D inputImageTexture;
//
// //计算
// float fInv (float t) {
//
//	 float T0 =  6.0/29.0;
//	 float T1 = 29.0 / 6.0;
//	 if (t > pow(T0,3.0))
//	 {
//		 return pow(t,1.0 / 3.0);
//	 }
//
//	 return 1.0 / 3.0 * T1 * T1 * t + 16.0 / 116.0;
// }
//
// void main()
// {
//
//	 vec3 color = texture2D(inputImageTexture, textureCoordinate).rgb;
//	 vec4 textureColor = texture2D(inputImageTexture, textureCoordinate);
//
//	 //从RGB -->XYZ
//
//	 mat3 maxtrix = mat3(2.7689,1.7518,1.1302,
//						 1.0002,4.5907,0.0600,
//						 0.0000,0.0565,5.5943);
//
//	 vec3 xyz = maxtrix * color;
//	 vec3 xyz0 = maxtrix * vec3(1.0,1.0,1.0);//白点
//
//
//	 //XYZ --->LAB
//	 float xn = xyz0.r;
//	 float yn = xyz0.g;
//	 float zn = xyz0.b;
//
//	 float l = 116.0 * fInv(xyz.g / yn ) - 16.0;
//	 float a = 500.0 * (fInv(xyz.r / xn ) - fInv(xyz.g / yn) );
//	 float b = 200.0 * ( fInv(xyz.g / yn ) - fInv(xyz.b / zn) );
//	 a = a / (l + a + b );
//	 b = b / (l + a + b );
//
////	 如果处于某个范围内的话，改变肤色
//	 if(a > 0.151 && a < 0.5 ){ // && b < 0.87 && b >0.45){
//
//		 gl_FragColor = vec4(vec3(1.0,0.0,0.0), 1.0);//红色用于标记面部识别区域
////		 gl_FragColor = vec4(color + 0.02,1.0);
//	 }else{
//		 gl_FragColor = vec4(color ,1.0);
//	 }
//
////	 float key = a;
////	 gl_FragColor = vec4(vec3(1.0,1.0,1.0) * key, 1.0);
//
// }
//);

@implementation CYSkinWhiteFilter

- (void)dealloc {
    [lookupImageSource release];
    [super dealloc];
}

- (id)init{
//
//	if (![super initWithFragmentShaderFromString:kCYSkinWhiteFilterShaderString]) {
//		return nil;
//	}
//	return self;
    if (!(self = [super init]))
    {
        return nil;
    }

    UIImage *image = [UIImage imageNamed:@"lookup_skinwhite.JPG"];
    NSAssert(image, @"To use CYSkinWhiteFilter you need to add lookup_skinswhite.png from Resources to your application bundle.");

    lookupImageSource = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];

    [lookupImageSource addTarget:lookupFilter atTextureLocation:1];
    [lookupFilter release];

    [lookupImageSource processImage];

    //添加一个双边模糊 以实现磨皮效果
    GPUImageBilateralFilter *bilateralFilter = [[GPUImageBilateralFilter alloc] init];
    bilateralFilter.blurSize = 0.5;
    [lookupFilter addTarget:bilateralFilter];
    [self addFilter:bilateralFilter];
    [bilateralFilter release];


    self.initialFilters = [NSArray arrayWithObjects:lookupFilter, nil];
    self.terminalFilter = bilateralFilter;

    return self;


}
//


@end
