//
//  AttributeBezierPath.m
//  Pixellation
//
//  Created by Shon Frazier on 3/18/12.
//  Copyright (c) 2012 Fyrestead. All rights reserved.
//

#import "AttributeBezierPath.h"


@implementation AttributedBezierPath

@synthesize bezierPath, fillColor, strokeColor, shouldFill, shouldStroke;

+ (AttributedBezierPath *) attributedBezierPath {
	AttributedBezierPath *abp = [[AttributedBezierPath alloc] init];
	
	return abp;
}

- (id) init {
	self = [super init];
	
	if(self) {
		bezierPath = [NSBezierPath bezierPath];
		shouldStroke = NO;
		shouldFill = NO;
	}
	
	return self;
}

- (void) draw {
	if (shouldFill && (fillColor!=nil)) {
		[fillColor setFill];
		[bezierPath fill];
	}
	if (shouldStroke && (strokeColor!=nil)) {
		[strokeColor setStroke];
		[bezierPath stroke];
	}
}

@end
