//
//  CYImageFilter.m
//  CYFilter
//
//  Created by chen yi on 12-10-18.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "CYImageFilter.h"

@implementation CYImageFilter


- (void)dealloc{
	self.pictureImagePaths = nil;
	
	glReleaseShaderCompiler();
	
	[super dealloc];
}


- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;
{
    if (!(self = [super initWithFragmentShaderFromString:fragmentShaderString]))
    {
        return nil;
    }
    self.pictureImagePaths = [NSMutableArray array];
	
    return self;
}


- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString fragmentShaderFromString:(NSString *)fragmentShaderString;
{
	if (!(self = [super initWithVertexShaderFromString:vertexShaderString fragmentShaderFromString:fragmentShaderString]))
	{
		return nil;
	}

    
    runSynchronouslyOnVideoProcessingQueue(^{
        [GPUImageOpenGLESContext useImageProcessingContext];
		// This does assume a name of " inputImageTexture " for the fragment shader
		filterInputTextureUniform2 = [filterProgram uniformIndex:@"inputImageTexture2"];
        filterInputTextureUniform3 = [filterProgram uniformIndex:@"inputImageTexture3"];
        filterInputTextureUniform4 = [filterProgram uniformIndex:@"inputImageTexture4"];
        filterInputTextureUniform5 = [filterProgram uniformIndex:@"inputImageTexture5"];
        filterInputTextureUniform6 = [filterProgram uniformIndex:@"inputImageTexture6"];
		      
    });
    
    return self;
}


- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates sourceTexture:(GLuint)sourceTexture;
{
    if (self.preventRendering)
    {
        return;
    }
    
    [GPUImageOpenGLESContext setActiveShaderProgram:filterProgram];
    [self setUniformsForProgramAtIndex:0];
    [self setFilterFBO];
    
    glClearColor(backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha);
    glClear(GL_COLOR_BUFFER_BIT);
	
	glActiveTexture(GL_TEXTURE2);
	glBindTexture(GL_TEXTURE_2D, sourceTexture);
	glUniform1i(filterInputTextureUniform, 2);
	
	
	///陈毅 add ///////
	if (filterSourceTexture2 != 0) {
		glActiveTexture(GL_TEXTURE3);
		glBindTexture(GL_TEXTURE_2D, filterSourceTexture2);
		glUniform1i(filterInputTextureUniform2, 3);
	}
	
	if (filterSourceTexture3 != 0) {
		glActiveTexture(GL_TEXTURE4);
		glBindTexture(GL_TEXTURE_2D, filterSourceTexture3);
		glUniform1i(filterInputTextureUniform3, 4);
	}
	
	if (filterSourceTexture4 !=  0) {
		glActiveTexture(GL_TEXTURE5);
		glBindTexture(GL_TEXTURE_2D, filterSourceTexture4);
		glUniform1i(filterInputTextureUniform4, 5);
	}
	
	if (filterSourceTexture5 != 0 ) {
		glActiveTexture(GL_TEXTURE6);
		glBindTexture(GL_TEXTURE_2D, filterSourceTexture5);
		glUniform1i(filterInputTextureUniform5, 6);
	}
	
	if (filterSourceTexture6 != 0) {
		glActiveTexture(GL_TEXTURE7);
		glBindTexture(GL_TEXTURE_2D, filterSourceTexture6);
		glUniform1i(filterInputTextureUniform6, 7);
	}
	
	//////////////////
	
    glVertexAttribPointer(filterPositionAttribute, 2, GL_FLOAT, 0, 0, vertices);
	glVertexAttribPointer(filterTextureCoordinateAttribute, 2, GL_FLOAT, 0, 0, textureCoordinates);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}


- (NSInteger)nextAvailableTextureIndex;
{
	if (filterSourceTexture == 0)
    {
        return 0;//设置filterSourceTexture
    }
	
	return  1 ; //设置filterSourceTexture2~6
}

- (void)setInputTexture:(GLuint)newInputTexture atIndex:(NSInteger)textureIndex;
{
	if (textureIndex == 0)
    {
        filterSourceTexture = newInputTexture;
    }
    else if (filterSourceTexture2 == 0)
    {
        filterSourceTexture2 = newInputTexture;
    }
    else if (filterSourceTexture3 == 0) {
		
        filterSourceTexture3 = newInputTexture;
    }
    else if (filterSourceTexture4 == 0) {
		
        filterSourceTexture4 = newInputTexture;
    }
    else if (filterSourceTexture5 == 0) {
		
        filterSourceTexture5 = newInputTexture;
    }
    else if(filterSourceTexture6 == 0) {
		
        filterSourceTexture6 = newInputTexture;
    }
	
}


@end
