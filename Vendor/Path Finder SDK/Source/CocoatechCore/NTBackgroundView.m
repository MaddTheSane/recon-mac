//
//  NTBackgroundView.m
//  CocoatechCore
//
//  Created by Steve Gehrman on Sun Mar 17 2002.
//  Copyright (c) 2001 CocoaTech. All rights reserved.
//

#import "NTBackgroundView.h"
#import "NTGeometry.h"
#import "NSImage-NTExtensions.h"

@interface NTBackgroundView ()
+ (void)drawBackgroundColorInView:(NSView*)view
							color:(NSColor*)color 
						   inRect:(NSRect)rect
		  eraseWhiteIfTransparent:(BOOL)eraseWhiteIfTransparent;

+ (void)drawBackgroundImageInView:(NSView*)view
						 clipRect:(NSRect)clipRect
							image:(NSImage*)image
						 fraction:(CGFloat)fraction
				 imageDrawingMode:(NTImageDrawingMode)imageDrawingMode;
@end

@implementation NTBackgroundView

- (id)initWithFrame:(NSRect)frame;
{
    self = [super initWithFrame:frame];

    mv_drawingMode = NTImageDrawingModeTile;
	[self setWhiteWhenBackgroundColorIsTransparent:YES];
	[self setImageOpacity:1.0];

    return self;
}

- (BOOL)isOpaque;
{
    // we are only opaque if our backcolor has an alpha component or an image
    if (mv_backColor)
	{
		if ([self whiteWhenBackgroundColorIsTransparent])
			return YES;
		else
			return ([mv_backColor alphaComponent] == 1.0);
	}
    
    if (mv_backImage)
        return YES;
    
    return [super isOpaque];
}

@synthesize imageDrawingMode=mv_drawingMode;
@synthesize backgroundColor=mv_backColor;

- (void)drawRect:(NSRect)rect;
{    
	[[self class] drawBackgroundInView:self
						clipRect:rect
						   color:[self backgroundColor] 
		 eraseWhiteIfTransparent:[self whiteWhenBackgroundColorIsTransparent]
						   image:mv_backImage
					   imagePath:mv_imagePath
							  fraction:[self imageOpacity]
				imageDrawingMode:mv_drawingMode];
}

// pass the firstResponder to my subviews (this is what scrollview does with it's contentView)
- (BOOL)becomeFirstResponder;
{
    BOOL result = [super becomeFirstResponder];

    if (![self acceptsFirstResponder])
    {
        NSArray* subviews = [self subviews];
        NSView* subview;

        for (subview in subviews)
        {
            if ([subview acceptsFirstResponder])
            {
                result = [[self window] makeFirstResponder:subview];

                break;
            }
        }
    }

    return result;
}

- (void)setImage:(NSImage*)image;
{
	if (image != mv_backImage)
	{
		mv_backImage = nil;
		
		if ([image isValid])
		{
			mv_backImage = image;
			
			//[mv_backImage setScalesWhenResized:YES];
		}
	}
}

@synthesize whiteWhenBackgroundColorIsTransparent=mv_whiteWhenBackgroundColorIsTransparent;
@synthesize imagePath=mv_imagePath;

//---------------------------------------------------------- 
//  imageOpacity 
//----------------------------------------------------------
@synthesize imageOpacity=mv_imageOpacity;

+ (void)drawBackgroundColorInView:(NSView*)view
							color:(NSColor*)color 
						   inRect:(NSRect)rect
		  eraseWhiteIfTransparent:(BOOL)eraseWhiteIfTransparent;
{
    if (color)
    {
		if (eraseWhiteIfTransparent)
		{
			if ([color alphaComponent] != 1.0)
			{
				[[NSColor whiteColor] set];
				[NSBezierPath fillRect:rect];
			}
		}
		
		// optimization, if alpha is zero, don't do anything
		if ([color alphaComponent] != 0.0)
		{
			[color set];
			[NSBezierPath fillRect:rect];
		}
	}
}

+ (void)drawBackgroundImageInView:(NSView*)view
						 clipRect:(NSRect)clipRect
							image:(NSImage*)image
						 fraction:(CGFloat)fraction
				 imageDrawingMode:(NTImageDrawingMode)imageDrawingMode;
{
    if (image)
    {
        NSSize imageSize = [image size];
		
        if (!NSEqualSizes(NSZeroSize, imageSize))
        {
            NSRect rect = [view bounds];
            NSRect scaledRect = rect;
			
            if (imageDrawingMode == NTImageDrawingModeScale)
            {
                int tmp;
                float ratio;
                int diff;
				
                ratio = imageSize.height/imageSize.width;
				
                // the width will stay the same, must figure out height
                tmp = scaledRect.size.width * ratio;
				
                if (tmp < rect.size.height)
                {
                    ratio = imageSize.width/imageSize.height;
					
                    // the width will stay the same, must figure out height
                    scaledRect.size.width = scaledRect.size.height * ratio;
					
                    // center the image
                    diff = (scaledRect.size.width - rect.size.width) /  2;
                    scaledRect.origin.x -= diff;
                }
                else
                {
                    scaledRect.size.height = tmp;
					
                    diff = (scaledRect.size.height - rect.size.height) /  2;
                    scaledRect.origin.y -= diff;
                }
				
                [image setSize:NSMakeSize(scaledRect.size.width, scaledRect.size.height)];
				
                // turn on high image interpolation level so image draws high quality
                [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
                
                [image drawAtPoint:scaledRect.origin fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:fraction];
            }
            else if (imageDrawingMode == NTImageDrawingModeTile)
                [image tileInView:view fraction:fraction clipRect:clipRect];
            else if (imageDrawingMode == NTImageDrawingModeCenter)
            {
                NSRect rect = [view bounds];
                NSRect drawRect = NSMakeRect(0,0,imageSize.width, imageSize.height);
                
                drawRect = [NTGeometry rect:drawRect centeredIn:rect scaleToFitContainer:NO];
                
                [image drawAtPoint:drawRect.origin fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:fraction];
            }
        }
    }
}

@end

@implementation NTBackgroundView (Utilities)

+ (void)drawBackgroundInView:(NSView*)view
					clipRect:(NSRect)clipRect
					   color:(NSColor*)color 
	 eraseWhiteIfTransparent:(BOOL)eraseWhiteIfTransparent
					   image:(NSImage*)image
				   imagePath:(NSString*)imagePath
					fraction:(CGFloat)fraction
			imageDrawingMode:(NTImageDrawingMode)imageDrawingMode;
{
	[self drawBackgroundColorInView:view
							  color:color
							 inRect:clipRect 
			eraseWhiteIfTransparent:eraseWhiteIfTransparent];
	
	if (image)
	{
		[self drawBackgroundImageInView:view
							   clipRect:clipRect
								  image:image 
							   fraction:fraction
					   imageDrawingMode:imageDrawingMode];
	}
	else if (imagePath)
	{
		NSImage* image=nil;
		
		NS_DURING
			image = [[NSImage alloc] initWithContentsOfFile:imagePath];
		NS_HANDLER
			image = nil;
		NS_ENDHANDLER
		
		if (image)
		{
			[image normalizeSize];  // Dan Woods suggestion?
			
			[image setCacheMode:NSImageCacheNever];
			//[image setScalesWhenResized:YES];
			[self drawBackgroundImageInView:view
								   clipRect:clipRect
									  image:image 
								   fraction:fraction
						   imageDrawingMode:imageDrawingMode];
        }
	}
}

@end

