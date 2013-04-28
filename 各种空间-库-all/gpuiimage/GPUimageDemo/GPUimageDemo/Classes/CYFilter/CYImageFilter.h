//
//  CYImageFilter.h
//  CYFilter
//
//  Created by chen yi on 12-10-18.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "GPUImageFilter.h"

@interface CYImageFilter : GPUImageFilter
{
	GLuint filterSourceTexture2,filterSourceTexture3,filterSourceTexture4,filterSourceTexture5,filterSourceTexture6;
    GLint  filterInputTextureUniform2,filterInputTextureUniform3,filterInputTextureUniform4,filterInputTextureUniform5,filterInputTextureUniform6;
	NSMutableArray *_pictureImagePaths;

}

@property(nonatomic, retain)NSMutableArray *pictureImagePaths;

@end
