//
//  Pixelator.h
//  Pixelator
//
//  Created by Shon Frazier on 3/28/12.
//  Copyright (c) 2012 Fyrestead. All rights reserved.
//
//  Licensed under GPLv3 - see LICENSE in project root
//  Other licensing arrangements availbale by contacting
//  the author
//

#import <Foundation/Foundation.h>
#import "AttributeBezierPath.h"
#import "NSImage+CGImageConversion.h"


typedef enum {
	PVSampleMethodAverageOfBlock = 1,
	PVSampleMethodSinglePixel = 2
} PVSampleMethod;

typedef enum {
	PVPixelShapeSquare = 0, //default
	PVPixelShapeRoundedRect = 1, //requires corner diameter
	PVPixelShapeCircle = 2,
	PVPixelShapeBezierPath = 3 //requires a bezier path, which should exist within a single unit in quadrant one, range [0, 1]
} PVPixelShape;

typedef enum {
	PVBackgroundStyleNone = 0,
	PVBackgroundStyleSolidColor = 1,
	PVBackgroundStyleImage = 2, //tiles
} PVBackgroundStyle;


@interface Pixelator : NSObject

- (id) initWithOutputImageSize:(NSSize) outSz;

@property (strong,nonatomic) IBOutlet NSImage *inputImage;
@property (readonly) IBOutlet NSImage *outputImage;
@property (assign) NSSize outputImageSize;

@end
