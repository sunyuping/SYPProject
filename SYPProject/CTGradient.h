#import <Foundation/Foundation.h>
#import <CoreGraphics/CGGeometry.h>
#import <UIKit/UIKit.h>

#import <CoreFoundation/CoreFoundation.h>
#import <CoreGraphics/CGColor.h>

//
//  CTGradient.h
//
//  Created by Zac White on 10/1/07.
//  Copyright (c) 2007 Chad Weider.
//  Some rights reserved: <http://creativecommons.org/licenses/by/2.5/>
//
//  Basically a copy and paste of CTGradient with some modifications to
//  work on the iPhone.

typedef struct _CTGradientElement
{
    float red, green, blue, alpha;
    float position;

    struct _CTGradientElement *nextElement;
} CTGradientElement;

typedef enum  _CTBlendingMode
{
    CTLinearBlendingMode,
    CTChromaticBlendingMode,
    CTInverseChromaticBlendingMode
} CTGradientBlendingMode;

@interface CTGradient : NSObject
{
    CTGradientElement* elementList;
    CTGradientBlendingMode blendingMode;

    CGFunctionRef gradientFunction;
}

+ (id)gradientWithBeginningColor:(CGColorRef)begin endingColor:(CGColorRef)end;

+ (id)aquaSelectedGradient;
+ (id)aquaNormalGradient;
+ (id)aquaPressedGradient;

+ (id)unifiedSelectedGradient;
+ (id)unifiedNormalGradient;
+ (id)unifiedPressedGradient;
+ (id)unifiedDarkGradient;

+ (id)sourceListSelectedGradient;
+ (id)sourceListUnselectedGradient;

+ (id)rainbowGradient;
+ (id)hydrogenSpectrumGradient;

- (CTGradient *)gradientWithAlphaComponent:(float)alpha;

//- (CTGradient *)addColorStop:(NSColor *)color atPosition:(float)position;	//positions given relative to [0,1]
- (CTGradient *)removeColorStopAtIndex:(unsigned)index;
- (CTGradient *)removeColorStopAtPosition:(float)position;

- (CTGradientBlendingMode)blendingMode;
//- (NSColor *)colorStopAtIndex:(unsigned)index;
//- (NSColor *)colorAtPosition:(float)position;

- (void)drawSwatchInRect:(NSRect)rect;
- (void)fillRect:(NSRect)rect angle:(float)angle; //fills rect with axial gradient
                                                  //	angle in degrees
- (void)radialFillRect:(NSRect)rect;              //fills rect with radial gradient
                                                  //  gradient from center outwards
//- (void)fillBezierPath:(NSBezierPath *)path angle:(float)angle;
//- (void)radialFillBezierPath:(NSBezierPath *)path;

@end
