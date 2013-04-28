//
// Created by chenyi on 12-11-8.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GPUImageGaussianSelectiveBlurCircleFilter.h"
#import "GPUImageGaussianBlurFilter.h"
#import "GPUImageTwoInputFilter.h"


NSString *const kGPUImageGaussianSelectiveBlurCircleFragmentShaderString = SHADER_STRING
(
varying highp vec2 textureCoordinate;
varying highp vec2 textureCoordinate2;

uniform sampler2D inputImageTexture;
uniform sampler2D inputImageTexture2;

uniform lowp float excludeCircleRadius;
uniform lowp vec2 excludeCirclePoint;
uniform lowp float excludeBlurSize;
uniform highp float aspectRatio;
uniform lowp int isEditing;

void main()
{
    lowp vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
    lowp vec4 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2);
    //此处圆形区域要除以宽高比 否则会得到椭圆
    highp vec2 textureCoordinateToUse = vec2(textureCoordinate2.x, textureCoordinate2.y / aspectRatio);
    lowp vec2 modifyCirclePoint = vec2(excludeCirclePoint.x,excludeCirclePoint.y / aspectRatio);

    highp float distanceFromCenter = distance(modifyCirclePoint, textureCoordinateToUse);

	if(1 == isEditing){
		//如果正在编辑 模糊区域变色,先混合一次
		blurredImageColor = mix(sharpImageColor,vec4(220.0/255.0,220.0/255.0,220.0/255.0,1.0),0.8);
		gl_FragColor = mix(sharpImageColor, blurredImageColor, smoothstep(excludeCircleRadius - excludeBlurSize, excludeCircleRadius, distanceFromCenter));
	}else{
		gl_FragColor = mix(sharpImageColor, blurredImageColor, smoothstep(excludeCircleRadius - excludeBlurSize, excludeCircleRadius, distanceFromCenter));
	}
//	gl_FragColor = sharpImageColor;
}
);
@implementation GPUImageGaussianSelectiveBlurCircleFilter {

}


@synthesize excludeCirclePoint = _excludeCirclePoint, excludeCircleRadius = _excludeCircleRadius, excludeBlurSize = _excludeBlurSize;
@synthesize blurSize = _blurSize;
@synthesize aspectRatio = _aspectRatio;

@synthesize isEditing = _isEditing;

//非arc
- (void)dealloc {
    [blurFilter release];
//    [selectiveFocusFilter release];
    [super dealloc];
}
- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }

    hasOverriddenAspectRatio = NO;
	_isEditing = NO;
	
    // First pass: apply a variable Gaussian blur
    blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [self addFilter:blurFilter];

    // Second pass: combine the blurred image with the original sharp one
    selectiveFocusFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:kGPUImageGaussianSelectiveBlurCircleFragmentShaderString];
    [self addFilter:selectiveFocusFilter];

    // Texture location 0 needs to be the sharp image for both the blur and the second stage processing
    [blurFilter addTarget:selectiveFocusFilter atTextureLocation:1];

    // To prevent double updating of this filter, disable updates from the sharp image side
    self.initialFilters = [NSArray arrayWithObjects:blurFilter, selectiveFocusFilter, nil];
    self.terminalFilter = selectiveFocusFilter;

    self.blurSize = 2.0;

    self.excludeCircleRadius = 60.0/320.0;
    self.excludeCirclePoint = CGPointMake(0.5f, 0.5f);
    self.excludeBlurSize = 30.0/320.0;

    return self;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;
{
    CGSize oldInputSize = inputTextureSize;
    [super setInputSize:newSize atIndex:textureIndex];
    inputTextureSize = newSize;

    if ( (!CGSizeEqualToSize(oldInputSize, inputTextureSize)) && (!hasOverriddenAspectRatio) && (!CGSizeEqualToSize(newSize, CGSizeZero)) )
    {
        _aspectRatio = (inputTextureSize.width / inputTextureSize.height);
        [selectiveFocusFilter setFloat:_aspectRatio forUniformName:@"aspectRatio"];
    }
}

#pragma mark -
#pragma mark Accessors

- (void)setBlurSize:(CGFloat)newValue;
{
    blurFilter.blurSize = newValue;
}

- (CGFloat)blurSize;
{
    return blurFilter.blurSize;
}

- (void)setExcludeCirclePoint:(CGPoint)newValue;
{
    _excludeCirclePoint = newValue;
    [selectiveFocusFilter setPoint:newValue forUniformName:@"excludeCirclePoint"];
}

- (void)setExcludeCircleRadius:(CGFloat)newValue;
{
    _excludeCircleRadius = newValue;
    [selectiveFocusFilter setFloat:newValue forUniformName:@"excludeCircleRadius"];
}

- (void)setExcludeBlurSize:(CGFloat)newValue;
{
    _excludeBlurSize = newValue;
    [selectiveFocusFilter setFloat:newValue forUniformName:@"excludeBlurSize"];
}

- (void)setAspectRatio:(CGFloat)newValue;
{
    hasOverriddenAspectRatio = YES;
    _aspectRatio = newValue;
    [selectiveFocusFilter setFloat:_aspectRatio forUniformName:@"aspectRatio"];
}

-(void)setIsEditing:(BOOL)isEditing {
   _isEditing = isEditing;
   [selectiveFocusFilter setInteger:(GLint)_isEditing forUniformName:@"isEditing" ];
}
@end