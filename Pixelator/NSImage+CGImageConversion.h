//
//  NSImage+CGImageConversion.h
//  Pixellation
//
//  Created by Shon Frazier on 3/18/12.
//  Copyright (c) 2012 Fyrestead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSImage (CGImageConversion)

- (NSBitmapImageRep*) bitmap;
- (CGImageRef) cgImage;

@end
