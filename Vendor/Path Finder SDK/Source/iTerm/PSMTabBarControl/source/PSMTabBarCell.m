//
//  PSMTabBarCell.m
//  PSMTabBarControl
//
//  Created by John Pannell on 10/13/05.
//  Copyright 2005 Positive Spin Media. All rights reserved.
//

#import "PSMTabBarCell.h"
#import "PSMTabBarControl.h"
#import "PSMTabStyle.h"
#import "PSMProgressIndicator.h"
#import "PSMTabDragAssistant.h"

@interface PSMTabBarControl ()
- (void)update;
- (void)update:(BOOL)animate;
@end

@implementation PSMTabBarCell

#pragma mark -
#pragma mark Creation/Destruction
- (id)initWithControlView:(PSMTabBarControl *)controlView
{
    if ( (self = [super init]) ) {
        _controlView = controlView;
        _closeButtonTrackingTag = 0;
        _cellTrackingTag = 0;
        _closeButtonOver = NO;
        _closeButtonPressed = NO;
        _indicator = [[PSMProgressIndicator alloc] initWithFrame:NSMakeRect(0.0,0.0,kPSMTabBarIndicatorWidth,kPSMTabBarIndicatorWidth)];
        [_indicator setStyle:NSProgressIndicatorSpinningStyle];
        [_indicator setAutoresizingMask:NSViewMinYMargin];
        _hasCloseButton = YES;
        _isCloseButtonSuppressed = NO;
        _count = 0;
        _isPlaceholder = NO;
        _labelColor = nil;
    }
    return self;
}

- (id)initPlaceholderWithFrame:(NSRect)frame expanded:(BOOL)value inControlView:(PSMTabBarControl *)controlView
{
    if ( (self = [super init]) ) {
        _controlView = controlView;
        _isPlaceholder = YES;
        if (!value) {
			if ([controlView orientation] == PSMTabBarHorizontalOrientation) {
				frame.size.width = 0.0;
			} else {
				frame.size.height = 0.0;
			}
		}
        [self setFrame:frame];
        _closeButtonTrackingTag = 0;
        _cellTrackingTag = 0;
        _closeButtonOver = NO;
        _closeButtonPressed = NO;
        _indicator = nil;
        _hasCloseButton = YES;
        _isCloseButtonSuppressed = NO;
        _count = 0;
        _labelColor = nil;
        
        if (value) {
            [self setCurrentStep:(kPSMTabDragAnimationSteps - 1)];
        } else {
            [self setCurrentStep:0];
        }
    }
    return self;
}

#pragma mark -
#pragma mark Accessors

@synthesize closeButtonTrackingTag=_closeButtonTrackingTag;
@synthesize cellTrackingTag=_cellTrackingTag;

- (CGFloat)width
{
    return _frame.size.width;
}

@synthesize frame=_frame;

- (void)setStringValue:(NSString *)aString
{
    [super setStringValue:aString];
    _stringSize = [[self attributedStringValue] size];
    // need to redisplay now - binding observation was too quick.
    [_controlView update:[(PSMTabBarControl*)[self controlView] automaticallyAnimates]];
}

@synthesize stringSize=_stringSize;

- (NSAttributedString *)attributedStringValue
{
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithAttributedString:[(id <PSMTabStyle>)[(PSMTabBarControl*)_controlView style] attributedStringValueForTabCell:self]];
    
    if (_labelColor) {
        [aString addAttribute:NSForegroundColorAttributeName value:_labelColor range:NSMakeRange(0, [aString length])];
    }
    
    return aString;
}

@synthesize tabState=_tabState;

- (NSProgressIndicator *)indicator
{ 
    return _indicator;
}

@synthesize isInOverflowMenu=_isInOverflowMenu;
@synthesize closeButtonPressed=_closeButtonPressed;
@synthesize closeButtonOver=_closeButtonOver;
@synthesize hasCloseButton=_hasCloseButton;
@synthesize closeButtonSuppressed=_isCloseButtonSuppressed;
@synthesize hasIcon=_hasIcon;

- (void)setHasIcon:(BOOL)value
{
    _hasIcon = value;
    [_controlView update:[(PSMTabBarControl*)[self controlView] automaticallyAnimates]]; // binding notice is too fast
}

@synthesize count=_count;

- (void)setCount:(int)value
{
    _count = value;
    [_controlView update:[(PSMTabBarControl*)[self controlView] automaticallyAnimates]]; // binding notice is too fast
}

@synthesize isPlaceholder=_isPlaceholder;
@synthesize currentStep=_currentStep;

- (void)setCurrentStep:(int)value
{
    if (value < 0)
        value = 0;
    
    if (value > (kPSMTabDragAnimationSteps - 1))
        value = (kPSMTabDragAnimationSteps - 1);
    
    _currentStep = value;
}

#pragma mark -
#pragma mark Bindings

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // the progress indicator, label, icon, or count has changed - redraw the control view
    [_controlView update:[(PSMTabBarControl*)[self controlView] automaticallyAnimates]];
}

#pragma mark -
#pragma mark Component Attributes

- (NSRect)indicatorRectForFrame:(NSRect)cellFrame
{
    return [(id <PSMTabStyle>)[(PSMTabBarControl*)self.controlView style] indicatorRectForTabCell:self];
}

- (NSRect)closeButtonRectForFrame:(NSRect)cellFrame
{
    return [(id <PSMTabStyle>)[(PSMTabBarControl*)self.controlView style] closeButtonRectForTabCell:self];
}

- (CGFloat)minimumWidthOfCell
{
    return [(id <PSMTabStyle>)[(PSMTabBarControl*)self.controlView style] minimumWidthOfTabCell:self];
}

- (CGFloat)desiredWidthOfCell
{
    return [(id <PSMTabStyle>)[(PSMTabBarControl*)self.controlView style] desiredWidthOfTabCell:self];
}  

#pragma mark -
#pragma mark Drawing

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if (_isPlaceholder){
        [[NSColor colorWithCalibratedWhite:0.0 alpha:0.2] set];
        NSRectFillUsingOperation(cellFrame, NSCompositeSourceAtop);
        return;
    }
    
    [(id <PSMTabStyle>)[(PSMTabBarControl*)_controlView style] drawTabCell:self];
}

#pragma mark -
#pragma mark Tracking

- (void)mouseEntered:(NSEvent *)theEvent
{
    // check for which tag
    if ([theEvent trackingNumber] == _closeButtonTrackingTag) {
        _closeButtonOver = YES;
    }
    if ([theEvent trackingNumber] == _cellTrackingTag) {
        [self setHighlighted:YES];
		[_controlView setNeedsDisplay:NO];
    }
	
	//tell the control we only need to redraw the affected tab
	[_controlView setNeedsDisplayInRect:NSInsetRect([self frame], -2, -2)];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    // check for which tag
    if ([theEvent trackingNumber] == _closeButtonTrackingTag) {
        _closeButtonOver = NO;
    }
	
    if ([theEvent trackingNumber] == _cellTrackingTag) {
        [self setHighlighted:NO];
		[_controlView setNeedsDisplay:NO];
    }
	
	//tell the control we only need to redraw the affected tab
	[_controlView setNeedsDisplayInRect:NSInsetRect([self frame], -2, -2)];
}

#pragma mark -
#pragma mark Drag Support

- (NSImage *)dragImage
{
	NSRect cellFrame = [(id <PSMTabStyle>)[(PSMTabBarControl*)_controlView style] dragRectForTabCell:self orientation:[(PSMTabBarControl*)_controlView orientation]];
	//NSRect cellFrame = [self frame];
	
    [_controlView lockFocus];
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:cellFrame];
    [(NSView*)_controlView unlockFocus];
    NSImage *image = [[NSImage alloc] initWithSize:[rep size]];
    [image addRepresentation:rep];
    NSImage *returnImage = [[NSImage alloc] initWithSize:[rep size]];
    [returnImage lockFocus];
    [image drawAtPoint:NSMakePoint(0.0, 0.0) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
    [returnImage unlockFocus];
    if (![[self indicator] isHidden]){
        NSImage *pi = [[NSImage alloc] initByReferencingFile:[[PSMTabBarControl bundle] pathForImageResource:@"pi"]];
        [returnImage lockFocus];
        NSPoint indicatorPoint = NSMakePoint([self frame].size.width - MARGIN_X - kPSMTabBarIndicatorWidth, MARGIN_Y);
        [pi drawAtPoint:indicatorPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
        [returnImage unlockFocus];
    }
    return returnImage;
}

#pragma mark -
#pragma mark Archiving

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    if ([aCoder allowsKeyedCoding]) {
        [aCoder encodeRect:_frame forKey:@"frame"];
        [aCoder encodeSize:_stringSize forKey:@"stringSize"];
        [aCoder encodeInt:_currentStep forKey:@"currentStep"];
        [aCoder encodeBool:_isPlaceholder forKey:@"isPlaceholder"];
        [aCoder encodeInt:_tabState forKey:@"tabState"];
        [aCoder encodeInteger:_closeButtonTrackingTag forKey:@"closeButtonTrackingTag"];
        [aCoder encodeInteger:_cellTrackingTag forKey:@"cellTrackingTag"];
        [aCoder encodeBool:_closeButtonOver forKey:@"closeButtonOver"];
        [aCoder encodeBool:_closeButtonPressed forKey:@"closeButtonPressed"];
        [aCoder encodeObject:_indicator forKey:@"indicator"];
        [aCoder encodeBool:_isInOverflowMenu forKey:@"isInOverflowMenu"];
        [aCoder encodeBool:_hasCloseButton forKey:@"hasCloseButton"];
        [aCoder encodeBool:_isCloseButtonSuppressed forKey:@"isCloseButtonSuppressed"];
        [aCoder encodeBool:_hasIcon forKey:@"hasIcon"];
        [aCoder encodeInt:_count forKey:@"count"];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        if ([aDecoder allowsKeyedCoding]) {
            _frame = [aDecoder decodeRectForKey:@"frame"];
            NSLog(@"decoding cell");
            _stringSize = [aDecoder decodeSizeForKey:@"stringSize"];
            _currentStep = [aDecoder decodeIntForKey:@"currentStep"];
            _isPlaceholder = [aDecoder decodeBoolForKey:@"isPlaceholder"];
            _tabState = [aDecoder decodeIntForKey:@"tabState"];
            _closeButtonTrackingTag = [aDecoder decodeIntegerForKey:@"closeButtonTrackingTag"];
            _cellTrackingTag = [aDecoder decodeIntegerForKey:@"cellTrackingTag"];
            _closeButtonOver = [aDecoder decodeBoolForKey:@"closeButtonOver"];
            _closeButtonPressed = [aDecoder decodeBoolForKey:@"closeButtonPressed"];
            _indicator = [aDecoder decodeObjectForKey:@"indicator"];
            _isInOverflowMenu = [aDecoder decodeBoolForKey:@"isInOverflowMenu"];
            _hasCloseButton = [aDecoder decodeBoolForKey:@"hasCloseButton"];
            _isCloseButtonSuppressed = [aDecoder decodeBoolForKey:@"isCloseButtonSuppressed"];
            _hasIcon = [aDecoder decodeBoolForKey:@"hasIcon"];
            _count = [aDecoder decodeIntForKey:@"count"];
        }
    }
    return self;
}

#pragma mark -
#pragma mark Accessibility

- (BOOL)accessibilityIsIgnored {
	return NO;
}

- (id)accessibilityAttributeValue:(NSString *)attribute {
	id attributeValue = nil;

	if ([attribute isEqualToString: NSAccessibilityRoleAttribute]) {
		attributeValue = NSAccessibilityButtonRole;
	} else if ([attribute isEqualToString: NSAccessibilityHelpAttribute]) {
		if ([[(PSMTabBarControl*)[self controlView] delegate] respondsToSelector:@selector(accessibilityStringForTabView:objectCount:)]) {
			attributeValue = [NSString stringWithFormat:@"%@, %i %@", [self stringValue],
																		[self count],
																		[[(PSMTabBarControl*)[self controlView] delegate] accessibilityStringForTabView:[(PSMTabBarControl*)[self controlView] tabView] objectCount:[self count]]];
		} else {
			attributeValue = [self stringValue];
		}
	} else if ([attribute isEqualToString: NSAccessibilityFocusedAttribute]) {
		attributeValue = [NSNumber numberWithBool:([self tabState] == 2)];
	} else {
        attributeValue = [super accessibilityAttributeValue:attribute];
    }

	return attributeValue;
}

- (NSArray *)accessibilityActionNames
{
	static NSArray *actions;
	
	if (!actions) {
		actions = [[NSArray alloc] initWithObjects:NSAccessibilityPressAction, nil];
	}
	return actions;
}

- (NSString *)accessibilityActionDescription:(NSString *)action
{
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_4
	return NSAccessibilityActionDescription(action);
#else
    return nil;
#endif
}
	
- (void)accessibilityPerformAction:(NSString *)action {
	if ([action isEqualToString:NSAccessibilityPressAction]) {
		// this tab was selected
		[_controlView performSelector:@selector(tabClick:) withObject:self];
	}
}

- (id)accessibilityHitTest:(NSPoint)point {
	return NSAccessibilityUnignoredAncestor(self);
}

- (id)accessibilityFocusedUIElement:(NSPoint)point {
	return NSAccessibilityUnignoredAncestor(self);
}

#pragma mark -
#pragma mark iTerm Add-on

@synthesize labelColor=_labelColor;

@end
