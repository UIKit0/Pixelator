//
//  NSImage+CGImageConversion.m
//  Pixellation
//
//  Created by Shon Frazier on 3/18/12.
//  Copyright (c) 2012 Fyrestead. All rights reserved.
//

#import "NSImage+CGImageConversion.h"


static void BitmapReleaseCallback( void* info, const void* data, size_t size ) {
	id bir = (__bridge_transfer NSBitmapImageRep*)info;
	DLog(@"%@", bir);
}

@implementation NSImage (CGImageConversion)

- (NSBitmapImageRep*) bitmap {
	// returns a 32-bit bitmap rep of the receiver, whatever its original format. The image rep is not added to the image.
	NSSize size = [self size];
	int rowBytes = ((int)(ceil(size.width)) * 4 + 0x0000000F) & ~0x0000000F; // 16-byte aligned
	int bps=8, spp=4, bpp=bps*spp;
	
	// NOTE: These settings affect how pixels are converted to NSColors
	NSBitmapImageRep *imageRep = [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil
																		 pixelsWide:size.width
																		 pixelsHigh:size.height
																	  bitsPerSample:bps
																	samplesPerPixel:spp
																		   hasAlpha:YES
																		   isPlanar:NO
																	 colorSpaceName:NSCalibratedRGBColorSpace
																	   bitmapFormat:NSAlphaFirstBitmapFormat
																		bytesPerRow:rowBytes
																	   bitsPerPixel:bpp];
	
	if (!imageRep) return nil;
	
	NSGraphicsContext* imageContext = [NSGraphicsContext graphicsContextWithBitmapImageRep:imageRep];
	
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:imageContext];
	[self drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
	[NSGraphicsContext restoreGraphicsState];
	
	return imageRep;
}

- (CGImageRef) cgImage {
	NSBitmapImageRep*	bm = [self bitmap]; // data provider will release this
	int					rowBytes, width, height;
	
	rowBytes = [bm bytesPerRow];
	width = [bm pixelsWide];
	height = [bm pixelsHigh];
	
	CGDataProviderRef provider = CGDataProviderCreateWithData((__bridge void *)bm, [bm bitmapData], rowBytes * height, BitmapReleaseCallback );
	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName( kCGColorSpaceGenericRGB );
	CGBitmapInfo	bitsInfo = kCGImageAlphaLast;
	
	CGImageRef img = CGImageCreate( width, height, 8, 32, rowBytes, colorspace, bitsInfo, provider, NULL, NO, kCGRenderingIntentDefault );
	
	CGDataProviderRelease( provider );
	CGColorSpaceRelease( colorspace );
	
	return img;
}

@end
