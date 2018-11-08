//
//  PSMTabBarCell.h
//  PSMTabBarControl
//
//  Created by John Pannell on 10/13/05.
//  Copyright 2005 Positive Spin Media. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PSMTabBarControl.h"

@class PSMTabBarControl;
@class PSMProgressIndicator;

@interface PSMTabBarCell : NSActionCell {
    // sizing
    NSRect              _frame;
    NSSize              _stringSize;
    int                 _currentStep;
    BOOL                _isPlaceholder;
    
    // state
    int                 _tabState;
    NSTrackingRectTag   _closeButtonTrackingTag;    // left side tracking, if dragging
    NSTrackingRectTag   _cellTrackingTag;           // right side tracking, if dragging
    BOOL                _closeButtonOver;
    BOOL                _closeButtonPressed;
    PSMProgressIndicator *_indicator;
    BOOL                _isInOverflowMenu;
    BOOL                _hasCloseButton;
    BOOL                _isCloseButtonSuppressed;
    BOOL                _hasIcon;
    int                 _count;

    //iTerm add-on
    NSColor             *_labelColor;
}

// creation/destruction
- (id)initWithControlView:(PSMTabBarControl *)controlView;
- (id)initPlaceholderWithFrame:(NSRect)frame expanded:(BOOL)value inControlView:(PSMTabBarControl *)controlView;

// accessors
@property NSTrackingRectTag closeButtonTrackingTag;
@property NSTrackingRectTag cellTrackingTag;
@property (readonly) CGFloat width;
@property NSRect frame;
- (void)setStringValue:(NSString *)aString;
@property (readonly) NSSize stringSize;
- (NSAttributedString *)attributedStringValue;
@property int tabState;
- (NSProgressIndicator *)indicator;
@property BOOL isInOverflowMenu;
@property BOOL closeButtonPressed;
@property BOOL closeButtonOver;
@property BOOL hasCloseButton;
@property (getter=isCloseButtonSuppressed) BOOL closeButtonSuppressed;
@property (nonatomic) BOOL hasIcon;
@property (nonatomic) int count;
@property BOOL isPlaceholder;
@property (nonatomic) int currentStep;

// component attributes
- (NSRect)indicatorRectForFrame:(NSRect)cellFrame;
- (NSRect)closeButtonRectForFrame:(NSRect)cellFrame;
- (CGFloat)minimumWidthOfCell;
- (CGFloat)desiredWidthOfCell;

// drawing
- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

// tracking the mouse
- (void)mouseEntered:(NSEvent *)theEvent;
- (void)mouseExited:(NSEvent *)theEvent;

// drag support
- (NSImage *)dragImage;

// archiving
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;

// iTerm add-on
@property (strong) NSColor *labelColor;

@end

@interface PSMTabBarControl (CellAccessors)

- (id<PSMTabStyle>)style;

@end
