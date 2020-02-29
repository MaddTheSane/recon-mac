//
//  PSMTabStyle.h
//  PSMTabBarControl
//
//  Created by John Pannell on 2/17/06.
//  Copyright 2006 Positive Spin Media. All rights reserved.
//

/* 
Protocol to be observed by all style delegate objects.  These objects handle the drawing responsibilities for PSMTabBarCell; once the control has been assigned a style, the background and cells draw consistent with that style.  Design pattern and implementation by David Smith, Seth Willits, and Chris Forsythe, all touch up and errors by John P. :-)
*/

#import "PSMTabBarCell.h"
#import "PSMTabBarControl.h"

@protocol PSMTabStyle <NSObject>

// identity
@property (readonly, copy) NSString *name;

// control specific parameters
@property (readonly) CGFloat leftMarginForTabBarControl;
@property (readonly) CGFloat rightMarginForTabBarControl;
@property (readonly) CGFloat topMarginForTabBarControl;

// add tab button
@property (readonly, retain) NSImage *addTabButtonImage;
@property (readonly, retain) NSImage *addTabButtonPressedImage;
@property (readonly, retain) NSImage *addTabButtonRolloverImage;

// cell specific parameters
- (NSRect)dragRectForTabCell:(PSMTabBarCell *)cell orientation:(PSMTabBarOrientation)orientation;
- (NSRect)closeButtonRectForTabCell:(PSMTabBarCell *)cell;
- (NSRect)iconRectForTabCell:(PSMTabBarCell *)cell;
- (NSRect)indicatorRectForTabCell:(PSMTabBarCell *)cell;
- (NSRect)objectCounterRectForTabCell:(PSMTabBarCell *)cell;
- (CGFloat)minimumWidthOfTabCell:(PSMTabBarCell *)cell;
- (CGFloat)desiredWidthOfTabCell:(PSMTabBarCell *)cell;

// cell values
- (NSAttributedString *)attributedObjectCountValueForTabCell:(PSMTabBarCell *)cell;
- (NSAttributedString *)attributedStringValueForTabCell:(PSMTabBarCell *)cell;

// drawing
- (void)drawTabCell:(PSMTabBarCell *)cell;
- (void)drawBackgroundInRect:(NSRect)rect drawLineAtBottom:(BOOL)drawLineAtBottom;
- (void)drawTabBar:(PSMTabBarControl *)bar inRect:(NSRect)rect drawLineAtBottom:(BOOL)drawLineAtBottom;

@end

@interface PSMTabBarControl (StyleAccessors)

- (NSMutableArray<PSMTabBarCell *> *)cells;

@end
