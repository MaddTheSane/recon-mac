//
//  ITIconStore.m
//  iTerm
//
//  Created by Steve Gehrman on 2/2/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ITIconStore.h"

@interface ITIconStore ()
- (NSString*)iconFromSystemIconsBundleWithName:(NSString*)iconName;

@property (nonatomic, strong) NSBundle *coreTypesBundle;
@end

@implementation ITIconStore

+ (ITIconStore*)sharedInstance;
{
	static ITIconStore* shared = nil;
	
	if (!shared)
		shared = [[ITIconStore alloc] init];
	
	return shared;
}

- (NSImage*)image:(NSString*)identifier;
{
	return [[self coreTypesBundle] imageForResource:identifier];
}

- (NSImage*)popupArrowImage:(NSColor*)color
					  small:(BOOL)small;
{
    NSImage *result;
	int height=0, width=0;
	
	if (small)
	{
		height = 4;
		width = 6;
	}
	else
	{
		height = 5;
		width = 7;
	}
	
	NSRect arrowRect=NSMakeRect(0,0, width, height);
	
	NSSize arrowSize = arrowRect.size;
	
    result = [[NSImage alloc] initWithSize:arrowSize];
    
    [result lockFocus];
	{
		NSBezierPath *linePath = [NSBezierPath bezierPath];
		[linePath moveToPoint:NSMakePoint(NSMinX(arrowRect), NSMinY(arrowRect))];
		[linePath lineToPoint:NSMakePoint(NSMidX(arrowRect), NSMaxY(arrowRect))];
		[linePath lineToPoint:NSMakePoint(NSMaxX(arrowRect), NSMinY(arrowRect))];			
		[linePath closePath];
		
		[color set];
		
		[linePath fill];
	}
	[result unlockFocus];
    
    return result;    
}

//----------------------------------------------------------
//  coreTypesBundle 
//---------------------------------------------------------- 
@synthesize coreTypesBundle=mCoreTypesBundle;

- (NSBundle *)coreTypesBundle
{
	if (!mCoreTypesBundle)
		[self setCoreTypesBundle:[NSBundle bundleWithPath:@"/System/Library/CoreServices/CoreTypes.bundle"]];
	
    return mCoreTypesBundle; 
}

- (NSString*)iconFromSystemIconsBundleWithName:(NSString*)iconName;
{
	NSString* path = [[self coreTypesBundle] pathForImageResource:iconName];
	
    return path;
}

@end
