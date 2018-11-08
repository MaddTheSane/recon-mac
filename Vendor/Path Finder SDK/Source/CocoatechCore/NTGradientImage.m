//
//  NTGradientImage.m
//  CocoatechCore
//
//  Created by Steve Gehrman on 9/15/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NTGradientImage.h"
#import "NSGraphicsContext-NTExtensions.h"
#import "NSImage-NTExtensions.h"
#import "NTGradient.h"

@interface NTGradientImage ()
@property (nonatomic) int imageHeight;

@property (nonatomic, retain) NSImage *image;
@end

static const int kImageWidth = 10;

@implementation NTGradientImage

+ (NTGradientImage*)gradientImage:(NTGradient*)gradient color:(NSColor*)color;
{
	return [self gradientImage:gradient color:color backColor:nil];
}

+ (NTGradientImage*)gradientImage:(NTGradient*)gradient color:(NSColor*)color backColor:(NSColor*)backColor;
{
	NTGradientImage* result = [[NTGradientImage alloc] init];
	
	[result setGradient:gradient];
	[result setColor:color];
	[result setBackColor:backColor];
	
	return result;
}

- (void)drawInRect:(NSRect)rect rotation:(CGFloat)rotation;
{
	SGS;
	[NSGraphicsContext rotateContext:rotation inRect:rect];			
	[self drawInRect:rect];
	RGS;
}

- (void)drawInRect:(NSRect)rect;
{
	NSRect drawRect = rect;
	
	if (NSWidth(drawRect) > 0)
	{
		[self setImageHeight:MAX(1, drawRect.size.height)];
		
		NSImage* image = [self image];
		
		NSRect imageRect = NSZeroRect;
		imageRect.size = [image size];
		
		[image drawInRectHQ:drawRect fromRect:imageRect operation:NSCompositeSourceOver fraction:1];
	}
}

- (void)drawInPath:(NSBezierPath*)path inRect:(NSRect)inRect rotation:(CGFloat)rotation;
{
	SGS;
	[NSGraphicsContext rotateContext:rotation inRect:inRect];			
	[self drawInPath:path];
	RGS;
}

- (void)drawInPath:(NSBezierPath*)path;
{	
	[self drawInPath:path inRect:NSZeroRect];
}

- (void)drawInPath:(NSBezierPath*)path inRect:(NSRect)inRect;
{
	if (NSIsEmptyRect(inRect))
		inRect = [path bounds];

	SGS;
		
	[path addClip];
	[self drawInRect:inRect];
	
	RGS;
}

//---------------------------------------------------------- 
//  gradient 
//---------------------------------------------------------- 
@synthesize gradient=mv_gradient;

- (void)setGradient:(NTGradient *)theGradient
{
    if (mv_gradient != theGradient) {
        mv_gradient = theGradient;
		
		// reset image
		[self setImage:nil];
    }
}

//---------------------------------------------------------- 
//  color 
//---------------------------------------------------------- 
@synthesize color=mv_color;

- (void)setColor:(NSColor *)theColor
{
    if (mv_color != theColor) {
        mv_color = theColor;
		
		// reset image
		[self setImage:nil];
    }
}

//---------------------------------------------------------- 
//  backColor 
//---------------------------------------------------------- 
@synthesize backColor=mBackColor;

- (void)setBackColor:(NSColor *)theBackColor
{
    if (mBackColor != theBackColor) {
        mBackColor = theBackColor;
		
		// reset image
		[self setImage:nil];
    }
}

//---------------------------------------------------------- 
//  imageHeight 
//---------------------------------------------------------- 
@synthesize imageHeight=mv_imageHeight;

- (void)setImageHeight:(int)theImageHeight
{
    mv_imageHeight = theImageHeight;
	
	// reset image if height has changed
	if (mv_imageHeight != [[self image] size].height)
		[self setImage:nil];
}

//---------------------------------------------------------- 
//  image 
//---------------------------------------------------------- 
- (NSImage *)image;
{
	if (!mv_image)
		[self setImage:[[self gradient] imageWithSize:NSMakeSize(kImageWidth, [self imageHeight]) color:[self color] backColor:[self backColor]]];
	
    return mv_image; 
}

@synthesize image=mv_image;

@end

