//
//  Pixelator.m
//  Pixelator
//
//  Created by Shon Frazier on 3/28/12.
//  Copyright (c) 2012 Fyrestead. All rights reserved.
//
//  Licensed under GPLv3 - see LICENSE in project root
//  Other licensing arrangements availbale by contacting
//  the author
//

#import "Pixelator.h"


// NOTE: This is not exactly reusable outside this file. It's completely dependent on the settings
// used to make the bitmap in NSImage(CGImageConversion)-bitmap.
static NSColor *NSColorFromPixel(NSUInteger pixel[8]) {
	CGFloat redf, greenf, bluef, alphaf;
	NSUInteger redi, greeni, bluei, alphai;
	
	alphai = pixel[0];
	redi = pixel[1];
	greeni = pixel[2];
	bluei = pixel[3];
	
	redf = ((CGFloat)redi)/255.;
	greenf = ((CGFloat)greeni)/255.;
	bluef = ((CGFloat)bluei)/255.;
	alphaf = ((CGFloat)alphai)/255.;
	
	return [NSColor colorWithCalibratedRed:redf green:greenf blue:bluef alpha:alphaf];
}

static NSImage *NSImageFromCGImage(CGImageRef cgi) {
	CGRect rect;
	rect.size.width = CGImageGetWidth(cgi);
	rect.size.height = CGImageGetWidth(cgi);
	rect.origin = NSMakePoint(0., 0.);
	
	NSImage* image = [[NSImage alloc] initWithSize:rect.size];
	[image lockFocus];
	CGContextDrawImage([[NSGraphicsContext currentContext] graphicsPort], *(CGRect*)&rect, cgi);
	[image unlockFocus];
	
	return image;
}

static NSBitmapImageRep *NSBitmapImageRepFromCGImage(CGImageRef cgimage) {
	size_t width = CGImageGetWidth(cgimage);
	size_t height = CGImageGetHeight(cgimage);
	size_t bitsPerComponent = CGImageGetBitsPerComponent(cgimage);
	size_t bytesPerRow = CGImageGetBytesPerRow(cgimage);
	CGColorSpaceRef space = CGImageGetColorSpace(cgimage);
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(cgimage);
	
	CGRect rect;
	rect.size.width = width;
	rect.size.height = height;
	rect.origin.x = 0.;
	rect.origin.y = 0.;
	
	CGContextRef bitmapCtx = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, space, bitmapInfo);
	CGContextDrawImage(bitmapCtx, rect, cgimage);
	
	return nil;
}


@interface Pixelator ()

@property (assign) CGRect bounds;

@property (assign) NSUInteger sampleRate;
@property (assign) PVSampleMethod sampleMethod;
@property (assign) NSUInteger whichPixel;

@property (assign) CGFloat pixelSize;
@property (assign) CGFloat padding;
@property (assign) PVPixelShape pixelShape;

@property (assign) PVBackgroundStyle backgroundStyle;
@property (strong) NSColor *pixelBackgroundColor;
@property (strong) NSImage *pixelBackgroundImage;

@end


@implementation Pixelator

- (id) initWithOutputImageSize:(NSSize) outSz {
	if(self=[super init]) {
		outputImageSize = outSz;
		bounds = NSZeroRect;
		bounds.size = outSz;
	}
	
	return self;
}


- (void) setInputImage:(NSImage *)img {
	inputImage = img;
	outputImage = nil;
}

- (NSImage *) outputImage {
	if(!outputImage) {
		/*much of this code is copied from another project and might need cleaning up*/
		NSMutableSet *abpaths = nil;
		NSBitmapImageRep *sourceImageRep = [inputImage bitmap];
		CGRect finalRect;
		
		if ((sourceImageRep) && ((!abpaths)) ) {
			abpaths = [NSMutableSet set];
			
			NSUInteger pixel[4]; memset(pixel, 0, sizeof(pixel));
			NSUInteger x, y;
			NSRect currentRectangle;
			currentRectangle.size.height =
			currentRectangle.size.width = pixelSize;
			
			CGFloat finalWidth = padding + (pixelSize + padding)*(sourceImageRep.pixelsWide/sampleRate);
			CGFloat finalHeight = padding + (pixelSize + padding)*(sourceImageRep.pixelsHigh/sampleRate);
			
			finalRect = NSMakeRect(0.0, 0.0, finalWidth, finalHeight);
			
			AttributedBezierPath *abpath;
			for(y=0; (y*sampleRate)<sourceImageRep.pixelsHigh; y++) {
				currentRectangle.origin.y = ((CGFloat)(y))*(currentRectangle.size.height + padding) + padding;
				
				for(x=0; (x*sampleRate)<sourceImageRep.pixelsWide; x++) {
					currentRectangle.origin.x = ((CGFloat)(x))*(currentRectangle.size.width + padding) + padding;
					
					[sourceImageRep getPixel:pixel atX:(x*sampleRate) y:(y*sampleRate)];
					
					abpath = [AttributedBezierPath attributedBezierPath];
					//[abpath.bezierPath appendBezierPathWithRect:currentRectangle];
					[abpath.bezierPath appendBezierPathWithOvalInRect:currentRectangle];
					abpath.fillColor = NSColorFromPixel(pixel);
					abpath.shouldFill = YES;
					
					[abpaths addObject:abpath];
				}
			}
		}
		
		if(sourceImageRep != nil)  {
			// draw background
			switch (backgroundStyle) {
				case PVBackgroundStyleSolidColor:
					if(pixelBackgroundColor!=nil) {
						NSBezierPath *bg = [NSBezierPath bezierPath];
						[bg appendBezierPathWithRect:self.bounds];
						[pixelBackgroundColor setFill];
						[bg fill];
					}
					break;
				case PVBackgroundStyleImage:
					if(pixelBackgroundImage!=nil) {
						NSColor *bg = [NSColor colorWithPatternImage:pixelBackgroundImage];
						[bg setFill];
						NSRectFill(finalRect);
					}
					break;
				default:
					break;
			}
		}
		
		[outputImage lockFocus];
		for(AttributedBezierPath *abp in abpaths) {
			[abp draw];
		}
		[outputImage unlockFocus];
	}
	
	return outputImage;
}

@synthesize inputImage;
@synthesize outputImage;
@synthesize outputImageSize;

@synthesize bounds;

@synthesize sampleRate;
@synthesize sampleMethod;
@synthesize whichPixel;

@synthesize pixelSize;
@synthesize padding;
@synthesize pixelShape;

@synthesize backgroundStyle;
@synthesize pixelBackgroundColor;
@synthesize pixelBackgroundImage;

@end
