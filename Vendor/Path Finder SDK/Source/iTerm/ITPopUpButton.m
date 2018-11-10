//
//  ITPopUpButton.m
//  iTerm
//
//  Created by Steve Gehrman on 2/2/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ITPopUpButton.h"
#import "ITIconStore.h"
#import "ITIconStore.h"

@interface ITPopUpButton ()
@property (nonatomic, strong, null_resettable) NSImage *arrowImage;

@property (strong) NSImage *contentImage;
@end

@implementation ITPopUpButton

- (void)sizeToFit;
{
}

//---------------------------------------------------------- 
// dealloc
//---------------------------------------------------------- 
- (void)dealloc
{
	[self setContentImage:nil];
}

- (void)encodeWithCoder:(NSCoder *)coder 
{
    [coder encodeObject:[self contentImageID] forKey:@"imageID"];
}

- (id)initWithCoder:(NSCoder *)coder 
{
	if (self = [super initWithCoder:coder])
		[self setContentImageID:[coder decodeObjectForKey:@"imageID"]];

	return self;
}

//---------------------------------------------------------- 
//  contentImageID 
//---------------------------------------------------------- 
@synthesize contentImageID=mContentImageID;

- (void)drawRect:(__unused NSRect)rect;
{
	NSRect toRect = [self bounds];
	NSRect fromRect = [self bounds];
	fromRect.origin = NSZeroPoint;
	
	toRect.origin.x += 2;
	[[self contentImage] drawInRect:toRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
	
	NSRect arrowRect = [self bounds];
	NSSize arrowSize = [[self arrowImage] size];
	arrowRect.origin.y = NSMaxY(arrowRect) - arrowSize.height;
	arrowRect.origin.x = NSMaxX(arrowRect) - arrowSize.width;
	arrowRect.size = arrowSize;
	
	fromRect = arrowRect;
	fromRect.origin = NSZeroPoint;
	[[self arrowImage] drawInRect:arrowRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
}

//---------------------------------------------------------- 
//  contentImage 
//---------------------------------------------------------- 
- (NSImage *)contentImage
{
	if (!mContentImage)
	{
		NSImage* image=nil;
		
		if ([[self contentImageID] isEqualToString:@"newwin"])
		{
			NSBundle *thisBundle = [NSBundle bundleForClass: [self class]];

			image = [thisBundle imageForResource:@"newwin"];
		}
		else
			image = [NSImage imageNamed:NSImageNamePreferencesGeneral];
		
		[self setContentImage:image];
	}
	
    return mContentImage; 
}

- (void)setContentImage:(NSImage *)theContentImage
{
    if (mContentImage != theContentImage)
    {
        mContentImage = theContentImage;
		
		//[mContentImage setScalesWhenResized:YES];
		[mContentImage setFlipped:YES];
		[mContentImage setSize:[self bounds].size];
    }
}

@synthesize contentImage=mContentImage;

//---------------------------------------------------------- 
//  arrowImage 
//---------------------------------------------------------- 
- (NSImage *)arrowImage
{
	if (!mArrowImage)
		[self setArrowImage:[[ITIconStore sharedInstance] popupArrowImage:[NSColor blackColor] small:YES]];
	
    return mArrowImage; 
}

@synthesize arrowImage=mArrowImage;

@end
