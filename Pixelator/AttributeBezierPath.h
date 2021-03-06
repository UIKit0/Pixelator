//
//  AttributeBezierPath.h
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

@interface AttributedBezierPath : NSObject {
@private
	NSBezierPath *bezierPath;
	NSColor *fillColor;
	NSColor *strokeColor;
	
	bool shouldStroke;
	bool shouldFill;
}
+ (AttributedBezierPath *) attributedBezierPath;

@property (readonly) NSBezierPath *bezierPath;
@property (retain) NSColor *fillColor;
@property (retain) NSColor *strokeColor;
@property bool shouldStroke;
@property bool shouldFill;

- (void) draw;

@end