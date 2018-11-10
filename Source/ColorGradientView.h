//
//  ColorGradientView.h
//  recon
//
//  Created by Sumanth Peddamatham on 8/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// Thanks: http://www.katoemba.net/makesnosenseatall/tag/nsgradient/

#import <Cocoa/Cocoa.h>


IB_DESIGNABLE
@interface ColorGradientView : NSView
{
   NSColor *startingColor;
   NSColor *endingColor;
   CGFloat angle;
}

// Define the variables as properties
@property(nonatomic, strong) IBInspectable NSColor *startingColor;
@property(nonatomic, strong) IBInspectable NSColor *endingColor;
@property(assign) IBInspectable CGFloat angle;

@end

