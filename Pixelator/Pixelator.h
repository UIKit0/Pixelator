//
//  Pixelator.h
//  Pixelator
//
//  Created by Shon Frazier on 3/28/12.
//  Copyright (c) 2012 Fyrestead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pixelator : NSObject {
	NSImage *imputImage;
	NSImage *outputImage;
}

@property (strong) IBOutlet NSImage *inputImage;
@property (readonly) IBOutlet NSImage *outputImage;

@end
