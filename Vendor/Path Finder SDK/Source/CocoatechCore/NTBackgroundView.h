//
//  NTBackgroundView.h
//  CocoatechCore
//
//  Created by Steve Gehrman on Sun Mar 17 2002.
//  Copyright (c) 2001 CocoaTech. All rights reserved.
//

#import "NTView.h"

typedef NS_ENUM(NSInteger, NTImageDrawingMode)
{
    NTImageDrawingModeTile,
    NTImageDrawingModeScale,
    NTImageDrawingModeCenter
};

// you can set an image or backcolor
@interface NTBackgroundView : NTView
{
    NTImageDrawingMode mv_drawingMode;
    
    NSColor* mv_backColor;

	CGFloat mv_imageOpacity;
	NSImage* mv_backImage;
	NSString* mv_imagePath;
	
	BOOL mv_whiteWhenBackgroundColorIsTransparent;
}

@property (retain) NSColor *backgroundColor;

- (void)setImage:(NSImage*)image;

//! for images that only need to draw infrequently.  Loads the image, draws and releases it.  saves ram for huge images
@property (copy) NSString *imagePath;

@property CGFloat imageOpacity;

//! the default is to tile
@property NTImageDrawingMode imageDrawingMode;

// default is YES
@property BOOL whiteWhenBackgroundColorIsTransparent;

@end

//! non \c NTBackgroundView subclasses can reuse the technology of drawing the background
@interface NTBackgroundView (Utilities)

//! non \c NTBackgroundView subclasses can reuse the technology of drawing the background
+ (void)drawBackgroundInView:(NSView*)view
					clipRect:(NSRect)clipRect
					   color:(NSColor*)color 
	 eraseWhiteIfTransparent:(BOOL)eraseWhiteIfTransparent
					   image:(NSImage*)image
				   imagePath:(NSString*)imagePath
					fraction:(CGFloat)fraction
			imageDrawingMode:(NTImageDrawingMode)imageDrawingMode;

@end

static const NTImageDrawingMode kTileImageMode NS_DEPRECATED_WITH_REPLACEMENT_MAC("NTImageDrawingModeTile", 10_0, 10_7) = NTImageDrawingModeTile;
static const NTImageDrawingMode kScaleImageMode NS_DEPRECATED_WITH_REPLACEMENT_MAC("NTImageDrawingModeScale", 10_0, 10_7) = NTImageDrawingModeScale;
static const NTImageDrawingMode kCenterImageMode NS_DEPRECATED_WITH_REPLACEMENT_MAC("NTImageDrawingModeCenter", 10_0, 10_7) = NTImageDrawingModeCenter;
