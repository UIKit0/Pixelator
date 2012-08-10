//
//  NSImage+CGImageConversion.h
//  Pixellation
//
//  Created by Shon Frazier on 3/18/12.
//  Copyright (c) 2012 Fyrestead. All rights reserved.
//
//  Licensed under GPLv3 - see LICENSE in project root
//  Other licensing arrangements availbale by contacting
//  the author
//

#import <Foundation/Foundation.h>

@interface NSImage (CGImageConversion)

- (NSBitmapImageRep*) bitmap;
- (CGImageRef) cgImage;

@end
